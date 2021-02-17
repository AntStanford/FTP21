<cfinclude template="/cfformprotect/appConfig/index.cfm">

<cfif CGI.http_cookie IS "">
  <cfset sessiontimeout = CreateTimeSpan(0,0,0,10) />
<cfelse>
  <cfset sessiontimeout = CreateTimeSpan(0,0,20,0) />
</cfif>

<!--- Be sure to change the application name per project; this will be updated automatically when running CMS installer --->
<cfapplication name="#request.appConfigData.name#" clientmanagement="Yes" sessionmanagement="Yes" sessiontimeout="#sessiontimeout#" setClientCookies="yes" setDomainCookies="yes">

<cfif !structKeyExists(application, "settings") OR isDefined("url.init")>

   <cfset settings = structNew()>

   <!--- Get Settings from DB --->
   <cfinclude template="/cfformprotect/appConfig/settingsSetupSubmit.cfm">
   <cfquery name="getSettings" dataSource="booking_clients">
      select * from settings where dsn = <cfqueryparam value="#request.appConfigData.settingsDSN#" cfsqltype="cf_sql_varchar">
   </cfquery>
   <cfif getSettings.recordCount EQ 0>
   		<cfinclude template="/cfformprotect/appConfig/settingsSetupForm.cfm">
   </cfif>

   <cfset settings = queryRowToStruct(getSettings)>
   <cfset settings.bcDSN = 'booking_clients'>

   <!--- Get booking engine info for Escapia customer --->
   <cfquery name="getBookingEngineInfo" dataSource="booking_clients">
      select * from clients where dsn = <cfqueryparam value="#request.appConfigData.clientsDSN#" cfsqltype="cf_sql_varchar">
   </cfquery>


   <cfif getBookingEngineInfo.recordcount gt 0>

      <!--- assign booking engine info to a temp struct --->
      <cfset settings.booking = queryRowToStruct(getBookingEngineInfo)>
      <cfset settings.booking.dir = '#request.appConfigData.bookingDir#'>

      <cfset settings.booking.pmsComponent = "components." & settings.booking.pms>

      <!--- Only execute the code below on the live site --->
      <cfif cgi.server_name neq settings.devURL>

         <!--- set the booking object which contains functions specific to your PMS --->
         <cfset application.bookingObject = CreateObject("Component", "#settings.booking.pmsComponent#").init(settings)>
         <!--- Booking engine settings that only need to run during site init have been moved out of /#settings.booking.dir#/settings.cfm
         and are being included here. --->
         <cfinclude template="/#settings.booking.dir#/settings-inc-init.cfm">

      </cfif>

   </cfif>

   <cfset application.contactInfoEncryptKey = 'ewRoFLEnBCYZfHpe7ZmcVQ==' />

   <!--- Store settings struct in application scope --->
   <cflock scope="Application" timeout="3">
     <cfset application.settings = settings>
   </cflock>

</cfif>

<cflock scope="Application" timeout="3">
   <cfset settings = application.settings>
</cflock>

<cfset settings.ltDSN = 'booking_leadtracker'>

<cfset ICNDeyesOnly = false>

<cfif cgi.server_name eq settings.devURL>
   <cfset settings.globalTimeSpan = "#createtimespan(0,0,0,1)#"> <!--- during development set cache to 1 second --->
   <!--- <cfset settings.clientEmail = settings.devEmail> --->
   <cfset application.bookingObject = CreateObject("Component", "#settings.booking.pmsComponent#").init(settings)>
   <!--- Booking engine settings that only need to run during site init have been moved out of /#settings.booking.dir#/settings.cfm
   and are being included here. --->
   <cfinclude template="/#settings.booking.dir#/settings-inc-init.cfm">
<cfelse>
   <cfset settings.globalTimeSpan = "#createtimespan(0,0,30,0)#"> <!--- during live environement set cache to 30 min --->
</cfif>

<!---
cfformprotect is located in the root of the server; each site is mapped to it using a virutal directory
send-email.cfm contains a centralized email function so we only have one place on the site sending out emails
in case we ever have to change it again. As of 8/2017 we are using the Mailgun API via the cfhttp tag.
We are no longer using the native cfmail tag--->
<cfinclude template="/cfformprotect/icndmailer/send-email.cfm">


<!--- If this is a booking engine website, include our settings file --->
<cfinclude template="/#settings.booking.dir#/settings.cfm">

<!---RETURN AND BOOK COOKIE--->
<cfif isdefined('ReturnAndBookedID')>
   <cfcookie name="ReturnAndBookedID" value="#ReturnAndBookedID#">
</cfif>

<cffunction name="getPageText" returnType="query">

   <cfargument name="filename" type="string" required="true">

   <cfquery dataSource="#settings.dsn#" name="returnPageText">
     select * from cms_pages where slug = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#filename#">
   </cfquery>

   <cfreturn returnPageText>

</cffunction>


<!--- we do this so tinymce to work properly --->
<cfif structKeyExists(COOKIE,"tinymce_domain") is false>
    <cfcookie name="tinymce_domain" value="#replaceNoCase(settings.website,'www.','')#" expires="NEVER">
</cfif>


<cfscript>
/**
 * Returns the substring of a string. It mimics the behaviour of the homonymous php function so it permits negative indexes too.
 *
 * @param buf   The string to parse. (Required)
 * @param start    The start position index. If negative, counts from the right side. (Required)
 * @param length   Number of characters to return. If not passed, returns from start to end (if positive start value). (Optional)
 * @return Returns a string.
 * @author Rudi Roselli Pettazzi (&#114;&#104;&#111;&#100;&#105;&#111;&#110;&#64;&#116;&#105;&#115;&#99;&#97;&#108;&#105;&#110;&#101;&#116;&#46;&#105;&#116;)
 * @version 2, July 2, 2002
 */
function SubStr(buf, start) {
    // third argument (optional)
    var length = 0;
    var sz = 0;

    sz = len(buf);

    if (arrayLen(arguments) EQ 2) {

      if (start GT 0) {
          length = sz;
      } else if (start LT 0) {
          length = sz + start;
          start = 1;
      }

    } else {

      length = Arguments[3];
      if (start GT 0) {
          if (length LT 0)   length = 1+sz+length-start;
      } else if (start LT 0) {
          if (length LT 0) length = length-start;
          start = 1+sz+start;

      }
    }

    if (isNumeric(start) AND isNumeric(length) AND start GT 0 AND length GT 0) return mid(buf, start, length);
    else return "";
}
</cfscript>


<cfscript>
/**
 * Removes HTML from the string.
 * v2 - Mod by Steve Bryant to find trailing, half done HTML.
 * v4 mod by James Moberg - empties out script/style blocks
 *
 * @param string   String to be modified. (Required)
 * @return Returns a string.
 * @author Raymond Camden (&#114;&#97;&#121;&#64;&#99;&#97;&#109;&#100;&#101;&#110;&#102;&#97;&#109;&#105;&#108;&#121;&#46;&#99;&#111;&#109;)
 * @version 4, October 4, 2010
 */
function stripHTML(str) {
   str = reReplaceNoCase(str, "<*style.*?>(.*?)</style>","","all");
   str = reReplaceNoCase(str, "<*script.*?>(.*?)</script>","","all");

   str = reReplaceNoCase(str, "<.*?>","","all");
   //get partial html in front
   str = reReplaceNoCase(str, "^.*?>","");
   //get partial html at end
   str = reReplaceNoCase(str, "<.*$","");
   return trim(str);
}
</cfscript>


<cfscript>
/**
 * Returns a number converted into a string (i.e. 1 becomes &quot;One&quot;).
 * Added catch for number=0. Thanks to Lucas for finding it.
 *
 * @param number   The number to translate. (Required)
 * @return Returns a string.
 * @author Ben Forta (ben@forta.com)
 * @version 2, August 20, 2002
 */
function NumberAsString(number)
{
   VAR Result="";          // Generated result
   VAR Str1="";            // Temp string
   VAR Str2="";            // Temp string
   VAR n=number;           // Working copy
   VAR Billions=0;
   VAR Millions=0;
   VAR Thousands=0;
   VAR Hundreds=0;
   VAR Tens=0;
   VAR Ones=0;
   VAR Point=0;
   VAR HaveValue=0;        // Flag needed to know if to process "0"

   // Initialize strings
   // Strings are "externalized" to simplify
   // changing text or translating
   if (NOT IsDefined("REQUEST.Strs"))
   {
      REQUEST.Strs=StructNew();
      REQUEST.Strs.space="-";
      REQUEST.Strs.and="and";
      REQUEST.Strs.point="Point";
      REQUEST.Strs.n0="Zero";
      REQUEST.Strs.n1="One";
      REQUEST.Strs.n2="Two";
      REQUEST.Strs.n3="Three";
      REQUEST.Strs.n4="Four";
      REQUEST.Strs.n5="Five";
      REQUEST.Strs.n6="Six";
      REQUEST.Strs.n7="Seven";
      REQUEST.Strs.n8="Eight";
      REQUEST.Strs.n9="Nine";
      REQUEST.Strs.n10="Ten";
      REQUEST.Strs.n11="Eleven";
      REQUEST.Strs.n12="Twelve";
      REQUEST.Strs.n13="Thirteen";
      REQUEST.Strs.n14="Fourteen";
      REQUEST.Strs.n15="Fifteen";
      REQUEST.Strs.n16="Sixteen";
      REQUEST.Strs.n17="Seventeen";
      REQUEST.Strs.n18="Eighteen";
      REQUEST.Strs.n19="Nineteen";
      REQUEST.Strs.n20="Twenty";
      REQUEST.Strs.n30="Thirty";
      REQUEST.Strs.n40="Forty";
      REQUEST.Strs.n50="Fifty";
      REQUEST.Strs.n60="Sixty";
      REQUEST.Strs.n70="Seventy";
      REQUEST.Strs.n80="Eighty";
      REQUEST.Strs.n90="Ninety";
      REQUEST.Strs.n100="Hundred";
      REQUEST.Strs.nK="Thousand";
      REQUEST.Strs.nM="Million";
      REQUEST.Strs.nB="Billion";
   }

   // Save strings to an array once to improve performance
   if (NOT IsDefined("REQUEST.StrsA"))
   {
      // Arrays start at 1, to 1 contains 0
      // 2 contains 1, and so on
      REQUEST.StrsA=ArrayNew(1);
      ArrayResize(REQUEST.StrsA, 91);
      REQUEST.StrsA[1]=REQUEST.Strs.n0;
      REQUEST.StrsA[2]=REQUEST.Strs.n1;
      REQUEST.StrsA[3]=REQUEST.Strs.n2;
      REQUEST.StrsA[4]=REQUEST.Strs.n3;
      REQUEST.StrsA[5]=REQUEST.Strs.n4;
      REQUEST.StrsA[6]=REQUEST.Strs.n5;
      REQUEST.StrsA[7]=REQUEST.Strs.n6;
      REQUEST.StrsA[8]=REQUEST.Strs.n7;
      REQUEST.StrsA[9]=REQUEST.Strs.n8;
      REQUEST.StrsA[10]=REQUEST.Strs.n9;
      REQUEST.StrsA[11]=REQUEST.Strs.n10;
      REQUEST.StrsA[12]=REQUEST.Strs.n11;
      REQUEST.StrsA[13]=REQUEST.Strs.n12;
      REQUEST.StrsA[14]=REQUEST.Strs.n13;
      REQUEST.StrsA[15]=REQUEST.Strs.n14;
      REQUEST.StrsA[16]=REQUEST.Strs.n15;
      REQUEST.StrsA[17]=REQUEST.Strs.n16;
      REQUEST.StrsA[18]=REQUEST.Strs.n17;
      REQUEST.StrsA[19]=REQUEST.Strs.n18;
      REQUEST.StrsA[20]=REQUEST.Strs.n19;
      REQUEST.StrsA[21]=REQUEST.Strs.n20;
      REQUEST.StrsA[31]=REQUEST.Strs.n30;
      REQUEST.StrsA[41]=REQUEST.Strs.n40;
      REQUEST.StrsA[51]=REQUEST.Strs.n50;
      REQUEST.StrsA[61]=REQUEST.Strs.n60;
      REQUEST.StrsA[71]=REQUEST.Strs.n70;
      REQUEST.StrsA[81]=REQUEST.Strs.n80;
      REQUEST.StrsA[91]=REQUEST.Strs.n90;
   }

   //zero shortcut
   if(number is 0) return "Zero";

   // How many billions?
   // Note: This is US billion (10^9) and not
   // UK billion (10^12), the latter is greater
   // than the maximum value of a CF integer and
   // cannot be supported.
   Billions=n\1000000000;
   if (Billions)
   {
      n=n-(1000000000*Billions);
      Str1=NumberAsString(Billions)&REQUEST.Strs.space&REQUEST.Strs.nB;
      if (Len(Result))
         Result=Result&REQUEST.Strs.space;
      Result=Result&Str1;
      Str1="";
      HaveValue=1;
   }

   // How many millions?
   Millions=n\1000000;
   if (Millions)
   {
      n=n-(1000000*Millions);
      Str1=NumberAsString(Millions)&REQUEST.Strs.space&REQUEST.Strs.nM;
      if (Len(Result))
         Result=Result&REQUEST.Strs.space;
      Result=Result&Str1;
      Str1="";
      HaveValue=1;
   }

   // How many thousands?
   Thousands=n\1000;
   if (Thousands)
   {
      n=n-(1000*Thousands);
      Str1=NumberAsString(Thousands)&REQUEST.Strs.space&REQUEST.Strs.nK;
      if (Len(Result))
         Result=Result&REQUEST.Strs.space;
      Result=Result&Str1;
      Str1="";
      HaveValue=1;
   }

   // How many hundreds?
   Hundreds=n\100;
   if (Hundreds)
   {
      n=n-(100*Hundreds);
      Str1=NumberAsString(Hundreds)&REQUEST.Strs.space&REQUEST.Strs.n100;
      if (Len(Result))
         Result=Result&REQUEST.Strs.space;
      Result=Result&Str1;
      Str1="";
      HaveValue=1;
   }

   // How many tens?
   Tens=n\10;
   if (Tens)
      n=n-(10*Tens);

   // How many ones?
   Ones=n\1;
   if (Ones)
      n=n-(Ones);

   // Anything after the decimal point?
   if (Find(".", number))
      Point=Val(ListLast(number, "."));

   // If 1-9
   Str1="";
   if (Tens IS 0)
   {
      if (Ones IS 0)
      {
         if (NOT HaveValue)
            Str1=REQUEST.StrsA[0];
      }
      else
         // 1 is in 2, 2 is in 3, etc
         Str1=REQUEST.StrsA[Ones+1];
   }
   else if (Tens IS 1)
   // If 10-19
   {
      // 10 is in 11, 11 is in 12, etc
      Str1=REQUEST.StrsA[Ones+11];
   }
   else
   {
      // 20 is in 21, 30 is in 31, etc
      Str1=REQUEST.StrsA[(Tens*10)+1];

      // Get "ones" portion
      if (Ones)
         Str2=NumberAsString(Ones);
      Str1=Str1&REQUEST.Strs.space&Str2;
   }

   // Build result
   if (Len(Str1))
   {
      if (Len(Result))
         Result=Result&REQUEST.Strs.space&REQUEST.Strs.and&REQUEST.Strs.space;
      Result=Result&Str1;
   }

   // Is there a decimal point to get?
   if (Point)
   {
      Str2=NumberAsString(Point);
      Result=Result&REQUEST.Strs.space&REQUEST.Strs.point&REQUEST.Strs.space&Str2;
   }

   return Result;
}

</cfscript>





<cferror type="exception"  template="/error/error.cfm" exception="any" />
<cferror type="request"    template="/error/error.cfm" exception="any" />
<cferror type="Validation"    template="/error/error.cfm" exception="any" />



<cfscript>
   // we need to configure the site base path (to load  header and footer files, error templates, etc.)
   // cfinclude will not work with absolute path, but it will be work fine if we use a relative
   // path to the directory where the Application.cfm file is located
   application.rv_basePath = "\";// & ListGetAt( getCurrentTemplatePath(), listLen(getCurrentTemplatePath(), "\")-1, "\") & "\";
   application.rv_mappings["components"] = application.rv_basePath & "components\";
   application.rv_mappings["error"] = application.rv_basePath & "error\";

   application.rv_templateHeader = application.rv_mappings["components"] & "header.cfm"; // this can vary by site. double check.
   application.rv_templateFooter = application.rv_mappings["components"] & "footer.cfm"; // this can vary by site. double check.
</cfscript>

<cftry>

   <cfset ravenConfig = structNew()>
   <cfset ravenConfig.publicKey = settings.sentry_publickey>
   <cfset ravenConfig.privateKey = settings.sentry_privatekey>
   <cfset ravenConfig.sentryUrl = settings.sentry_url>
   <cfset ravenConfig.projectID = settings.sentry_projectid>
   <cfset ravenClient = createObject('component', 'error.components.client').init(argumentCollection=ravenConfig)>

<cfcatch>
</cfcatch>
</cftry>


<cfscript>
/**
 * Makes a row of a query into a structure.
 *
 * @param query    The query to work with.
 * @param row   Row number to check. Defaults to row 1.
 * @return Returns a structure.
 * @author Nathan Dintenfass (nathan@changemedia.com)
 * @version 1, December 11, 2001
 */
function queryRowToStruct(query){
   //by default, do this to the first row of the query
   var row = 1;
   //a var for looping
   var ii = 1;
   //the cols to loop over
   var cols = listToArray(query.columnList);
   //the struct to return
   var stReturn = structnew();
   //if there is a second argument, use that for the row number
   if(arrayLen(arguments) GT 1)
      row = arguments[2];
   //loop over the cols and build the struct from the query row
   for(ii = 1; ii lte arraylen(cols); ii = ii + 1){
      stReturn[cols[ii]] = query[cols[ii]][row];
   }
   //return the struct
   return stReturn;
}
</cfscript>

<cfscript>
/**
 * Returns a random string of the specified length of either alpha, numeric or mixed-alpha-numeric characters.
 * v2, support for lower case
 * v3 - more streamlined code
 *
 * @param Type     Type of random string to create. (Required)
 * @param Length   Length of random string to create. (Required)
 * @return Returns a string.
 * @author Joshua Miller (josh@joshuasmiller.com)
 * @version 2, November 4, 2003
 */
function randString(type,ct){
 var i=1;
 var randStr="";
 var randNum="";
 var useList="";
 var alpha="A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z";
 var secure="!,@,$,%,&,*,-,_,=,+,?,~";
 for(i=1;i LTE ct;i=i+1){
  if(type is "alpha"){
   randNum=RandRange(1,52);
   useList=alpha;
  }else if(type is "alphanum"){
   randNum=RandRange(1,62);
   useList="#alpha#,0,1,2,3,4,5,6,7,8,9";
  }else if(type is "secure"){
   randNum=RandRange(1,73);
   useList="#alpha#,0,1,2,3,4,5,6,7,8,9,#secure#";
  }else{
   randNum=RandRange(1,10);
   useList="0,1,2,3,4,5,6,7,8,9";
  }

  randStr="#randStr##ListGetAt(useList,randNum)#";
 }
 return randStr;
}
</cfscript>

<cffunction name="upperFirst" access="public" returntype="string" output="false" hint="I convert the first letter of a string to upper case, while leaving the rest of the string alone.">
      <cfargument name="name" type="string" required="true">
      <cfreturn uCase(left(arguments.name,1)) & right(arguments.name,len(arguments.name)-1)>
</cffunction>

<!--- START SQL INJECTION CODE --->
<cfif structKeyExists(SERVER,"oSecurityCheck") eq false or structKeyExists(URL,"resetSC")>
  <cflock name="SecurityCheck" timeout="10">
   <cfset server.oSecurityCheck = createObject("component","admin.tinymce.SecurityCheck")>
  </cflock>
</cfif>

<cfif structKeyExists(SERVER,"oSecurityCheck")>
   <cfset server.oSecurityCheck.CheckQueryString(cgi.query_string, cgi.server_name, cgi.remote_addr)>
</cfif>
<!--- STOP SQL INJECTION CODE --->


<cfif settings.hasLeadtracker eq 'Yes' and settings.logPagesViewed eq 'yes' and cgi.HTTP_USER_AGENT does not contain 'bot'>

   <!---We don't want to log images, just pages--->
   <cfif not QUERY_STRING contains ".jpg" and not QUERY_STRING contains ".png" and not SCRIPT_NAME contains "/leadtracker/" and not SCRIPT_NAME contains "/api/" and not SCRIPT_NAME contains "receiver-book-now" and not SCRIPT_NAME contains "ajax" and not SCRIPT_NAME contains "JSON">

            <cfif QUERY_STRING is not "">
               <cfset TheQueryString = "?#QUERY_STRING#">
              <cfelse>
               <cfset TheQueryString = "">
            </cfif>

            <cfif HTTP_REFERER is not "">
               <cfset TheReferrer = "#HTTP_REFERER#">
              <cfelse>
               <cfset TheReferrer = "Direct Type In">
            </cfif>

            <cfquery datasource="#settings.dsn#">
                INSERT INTO be_pageviewtracking (siteid,user_agent, visitorip, referringurl, pageviewed,<cfif isdefined('Cookie.TrackingEmail')>TrackingEmail<cfelse>UserTrackerValue</cfif> <cfif isdefined('cookie.LeadTrackerID')>,LeadTrackerID</cfif>)
                VALUES(
                <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#settings.id#">,
               <cfqueryparam CFSQLType="CF_SQL_LONGVARCHAR" value="#HTTP_USER_AGENT#">,
               <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#REMOTE_ADDR#">,
                <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#TheReferrer#">,
                <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="http://#HTTP_HOST##SCRIPT_NAME##TheQueryString#">,
               <cfif isdefined('Cookie.TrackingEmail')><cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#cookie.TrackingEmail#"><cfelse><cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#cookie.UserTrackingCookie#"></cfif> <cfif isdefined('cookie.LeadTrackerID')>,<cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#cookie.LeadTrackerID#"></cfif>
               )
            </cfquery>

   </cfif>

</cfif>

<!--- Mobile Detection --->
<cfset mobileDetect = reFindNoCase("(android|bb\d+|meego).+mobile|avantgo|bada\/|blackberry|blazer|compal|elaine|fennec|hiptop|iemobile|ip(hone|od|ad)|iris|kindle|lge |maemo|midp|mmp|mobile.+firefox|netfront|opera m(ob|in)i|palm( os)?|phone|p(ixi|re)\/|plucker|pocket|psp|series(4|6)0|symbian|treo|up\.(browser|link)|vodafone|wap|windows ce|xda|xiino",CGI.HTTP_USER_AGENT) GT 0 OR reFindNoCase("1207|6310|6590|3gso|4thp|50[1-6]i|770s|802s|a wa|abac|ac(er|oo|s\-)|ai(ko|rn)|al(av|ca|co)|amoi|an(ex|ny|yw)|aptu|ar(ch|go)|as(te|us)|attw|au(di|\-m|r |s )|avan|be(ck|ll|nq)|bi(lb|rd)|bl(ac|az)|br(e|v)w|bumb|bw\-(n|u)|c55\/|capi|ccwa|cdm\-|cell|chtm|cldc|cmd\-|co(mp|nd)|craw|da(it|ll|ng)|dbte|dc\-s|devi|dica|dmob|do(c|p)o|ds(12|\-d)|el(49|ai)|em(l2|ul)|er(ic|k0)|esl8|ez([4-7]0|os|wa|ze)|fetc|fly(\-|_)|g1 u|g560|gene|gf\-5|g\-mo|go(\.w|od)|gr(ad|un)|haie|hcit|hd\-(m|p|t)|hei\-|hi(pt|ta)|hp( i|ip)|hs\-c|ht(c(\-| |_|a|g|p|s|t)|tp)|hu(aw|tc)|i\-(20|go|ma)|i230|iac( |\-|\/)|ibro|idea|ig01|ikom|im1k|inno|ipaq|iris|ja(t|v)a|jbro|jemu|jigs|kddi|keji|kgt( |\/)|klon|kpt |kwc\-|kyo(c|k)|le(no|xi)|lg( g|\/(k|l|u)|50|54|\-[a-w])|libw|lynx|m1\-w|m3ga|m50\/|ma(te|ui|xo)|mc(01|21|ca)|m\-cr|me(rc|ri)|mi(o8|oa|ts)|mmef|mo(01|02|bi|de|do|t(\-| |o|v)|zz)|mt(50|p1|v )|mwbp|mywa|n10[0-2]|n20[2-3]|n30(0|2)|n50(0|2|5)|n7(0(0|1)|10)|ne((c|m)\-|on|tf|wf|wg|wt)|nok(6|i)|nzph|o2im|op(ti|wv)|oran|owg1|p800|pan(a|d|t)|pdxg|pg(13|\-([1-8]|c))|phil|pire|pl(ay|uc)|pn\-2|po(ck|rt|se)|prox|psio|pt\-g|qa\-a|qc(07|12|21|32|60|\-[2-7]|i\-)|qtek|r380|r600|raks|rim9|ro(ve|zo)|s55\/|sa(ge|ma|mm|ms|ny|va)|sc(01|h\-|oo|p\-)|sdk\/|se(c(\-|0|1)|47|mc|nd|ri)|sgh\-|shar|sie(\-|m)|sk\-0|sl(45|id)|sm(al|ar|b3|it|t5)|so(ft|ny)|sp(01|h\-|v\-|v )|sy(01|mb)|t2(18|50)|t6(00|10|18)|ta(gt|lk)|tcl\-|tdg\-|tel(i|m)|tim\-|t\-mo|to(pl|sh)|ts(70|m\-|m3|m5)|tx\-9|up(\.b|g1|si)|utst|v400|v750|veri|vi(rg|te)|vk(40|5[0-3]|\-v)|vm40|voda|vulc|vx(52|53|60|61|70|80|81|83|85|98)|w3c(\-| )|webc|whit|wi(g |nc|nw)|wmlb|wonu|x700|yas\-|your|zeto|zte\-",Left(CGI.HTTP_USER_AGENT,4)) GT 0>
<cfset officeIP = '216.99.119.254'>
<cfset cjIP = '98.213.100.204'>
<cfset samIP = '98.17.131.113'>
<cfset mattIP = '70.35.186.236'>
<cfset coleIP = '75.87.66.209x'>
<cfset lelaIP = '99.1.177.220'>
<cfset clientIP = '24.172.52.242'>
<cfset nathanIP = '71.68.209.85'>
<cfset saraIP = '68.44.158.31'>

<cfif listfind('#officeIP#,#cjIP#,#samIP#,#mattIP#,#coleIP#,#lelaIP#,#clientIP#,#nathanIP#,#saraIP#',cgi.remote_addr)>
   <cfset ICNDeyesOnly = true>
<cfelse>
   <cfset ICNDeyesOnly = false>
</cfif>