<cfoutput>
  
  <!--- booking property detail page ---> 
  <cfif cgi.script_name eq '/#settings.booking.dir#/property.cfm' and isdefined('property.propertyid')> 
    
    <cfset metadata = application.bookingObject.setPropertyMetaData(property)>
    #metadata#
    <cfif cgi.https eq 'off'>
      <link rel="canonical" href="http://#cgi.server_name#/#settings.booking.dir#/#property.seopropertyname#">
    <cfelse>
      <link rel="canonical" href="https://#cgi.server_name#/#settings.booking.dir#/#property.seopropertyname#">
    </cfif>
    
  <!--- booking results page --->  
  <cfelseif cgi.script_name eq '/#settings.booking.dir#/results.cfm'>
      
      <cfset page = getPageText('#settings.booking.dir#/results.cfm?all_properties=true')>
      
    <cfif isdefined('page.metatitle') and len(page.metatitle)>
      <title>#page.metatitle#</title>
    <cfelseif isdefined('page.name') and len(page.name)>
      <title>#page.name# - #settings.company#</title> 
    </cfif>
    <cfif isdefined('page.metadescription') and len(page.metadescription)>
      <meta name="description" content="#page.metadescription#">
    <cfelseif isdefined('page.body') and len(page.body)>
      <cfset tempBody = striphtml(mid(page.body,1,155))>
      <meta name="description" content="#tempBody#">    
    </cfif>
    <cfif cgi.https eq 'off'>
      <link rel="canonical" href="http://#cgi.server_name#/#settings.booking.dir#/results.cfm">
    <cfelse>
      <link rel="canonical" href="https://#cgi.server_name#/#settings.booking.dir#/results.cfm">
    </cfif> 
    
  <!--- booking all properties page --->  
  <cfelseif cgi.script_name eq '/#settings.booking.dir#/all-properties.cfm'>
      
      <cfset page = getPageText('#settings.booking.dir#/all-properties.cfm')>
    <cfif isdefined('page.metatitle') and len(page.metatitle)>
      <title>#page.metatitle#</title>
    <cfelseif isdefined('page.name') and len(page.name)>
      <title>#page.name# - #settings.company#</title>
    </cfif>
    <cfif isdefined('page.metadescription') and len(page.metadescription)>
      <meta name="description" content="#page.metadescription#">
    <cfelseif isdefined('page.body') and len(page.body)>
      <cfset tempBody = striphtml(mid(page.body,1,155))>
      <meta name="description" content="#tempBody#">    
    </cfif>
    <cfif cgi.https eq 'off'>
      <link rel="canonical" href="http://#cgi.server_name#/#settings.booking.dir#/all-properties.cfm">
    <cfelse>
      <link rel="canonical" href="https://#cgi.server_name#/#settings.booking.dir#/all-properties.cfm">
    </cfif>
  
  <!--- Long term rentals detail page --->
  <cfelseif cgi.script_name eq '/layouts/long-term-rental.cfm' and isdefined('getLongTermRental') and getLongTermRental.recordcount gt 0>   
      
      <title>#getLongTermRental.metaTitle#</title>
      <meta name="description" content="#stripHTML(getLongTermRental.metaDescription)#">
      <cfif cgi.https eq 'off'>
      <link rel="canonical" href="http://#cgi.server_name#/long-term-rental/#getLongTermRental.slug#">
    <cfelse>
      <link rel="canonical" href="https://#cgi.server_name#/long-term-rental/#getLongTermRental.slug#">
    </cfif>
      
  <!--- resort detail page --->
  <cfelseif cgi.script_name eq '/layouts/resort.cfm' and isdefined('getResort') and getResort.recordcount gt 0>   
      
      <title>#getResort.metaTitle#</title>      
      <meta name="description" content="#stripHTML(getResort.metaDescription)#">
      <cfif cgi.https eq 'off'>
      <link rel="canonical" href="http://#cgi.server_name#/resort/#getResort.slug#">
    <cfelse>
      <link rel="canonical" href="https://#cgi.server_name#/resort/#getResort.slug#">
    </cfif>
      
  <!--- things to do for one category page --->
  <cfelseif cgi.script_name eq '/layouts/thingstodo-categories.cfm' and isdefined('getCategory') and getCategory.recordcount gt 0> 
      
      <cfif len(getCategory.meta_title)>
        <title>#getCategory.meta_title#</title>
      <cfelse>
        <title>#getCategory.title#</title>
      </cfif>
      <meta name="description" content="#getCategory.meta_description#"> 
      <cfif cgi.https eq 'off'>
      <link rel="canonical" href="http://#cgi.server_name#/thingstodo/#getCategory.slug#">
    <cfelse>
      <link rel="canonical" href="https://#cgi.server_name#/thingstodo/#getCategory.slug#">
    </cfif>
      
  <!--- special detail page --->
  <cfelseif cgi.script_name eq '/layouts/special.cfm' and isdefined('getSpecial') and getSpecial.recordcount gt 0>
      
      <title>#getSpecial.title#</title>   
      <meta name="description" content="#stripHTML(getSpecial.description)#"> 
      <cfif cgi.https eq 'off'>
      <link rel="canonical" href="http://#cgi.server_name#/special/#getSpecial.slug#">
    <cfelse>
      <link rel="canonical" href="https://#cgi.server_name#/special/#getSpecial.slug#">
    </cfif>
      
  <!--- staff detail page --->    
  <cfelseif cgi.script_name eq '/layouts/staff.cfm' and isdefined('getStaff') and getStaff.recordcount gt 0>
      
      <title>#getStaff.name# - #getStaff.title# | #settings.company#</title>  
      <cfif len(getStaff.description)>
        <cfset shortDesc = stripHTML(getStaff.description)>
        <cfset shortDesc = mid(shortDesc,1,300)>
        <meta name="description" content="#shortDesc#">
      <cfelse>
        <meta name="description" content="Learn About #getStaff.name#, #getStaff.title# at #settings.company#">
      </cfif>  
      <cfif cgi.https eq 'off'>
      <link rel="canonical" href="http://#cgi.server_name#/staff/#getStaff.slug#">
    <cfelse>
      <link rel="canonical" href="https://#cgi.server_name#/staff/#getStaff.slug#">
    </cfif>
  
  <!--- event detail page --->          
  <cfelseif cgi.script_name eq '/layouts/event.cfm' and isdefined('getEvent') and getEvent.recordcount gt 0>
      
      <title>#getEvent.event_title#</title>   
      <meta name="description" content="#stripHTML(getEvent.details_long)#">
    <cfset cleanTitle = replace(getEvent.event_title,' ','-','all')>
    <cfset cleanTitle = replace(cleanTitle,":","","all")/>
    <cfset cleanTitle = replace(cleanTitle,"(","","all")/>
    <cfset cleanTitle = replace(cleanTitle,")","","all")/>
    <cfset cleanTitle = replace(cleanTitle,"'","","all")/>
    <cfset cleanTitle = replace(cleanTitle,"&","","all")/>
      <cfif cgi.https eq 'off'>
      <link rel="canonical" href="http://#cgi.server_name#/event/#cleanTitle#/#getEvent.id#">
    <cfelse>
      <link rel="canonical" href="https://#cgi.server_name#/event/#cleanTitle#/#getEvent.id#">
    </cfif> 
      
  <!--- event calendar, event detail page --->    
  <cfelseif cgi.script_name eq '/event-calendar/eventshow.cfm'>
      
      <title>Event: #appshow.event_title# - #appshow.event_location# - #Dateformat(appshow.start_date,'mmm. dd, yyyy')# at #appshow.time_start#</title>   
      <cfset shortDesc = stripHTML(appshow.details_long)>
      <cfset shortDesc = mid(shortDesc,1,300)>
      <meta name="description" content="#shortDesc#"> 
  
  <!--- event calendar, show all events for one day --->    
  <cfelseif cgi.script_name eq '/event-calendar/allday.cfm'>
  
      <cfset today = Createdate(url.ye, url.mo, url.da)>
      <cfset today = DateFormat(today,'mmm. dd, yyyy')>
      <title>Area Events on #today# | #settings.company#</title>
      <meta name="description" content="Calendar of events for #today#">
  
  <!--- MLS property detail page --->   
  <cfelseif cgi.script_name eq '/mls/property.cfm'>
      
      <title>#property.street_number# #property.street_name#, #property.city#,#property.state# | MLS## #mlsnumber# | #Settings.company#</title>
      <cfset shortDescription = mid(property.remarks,1,300)>
      <meta name="description" content="#shortDescription#">
      <!---
    <cfif cgi.https eq 'off'>
        <link rel="canonical" href="http://#cgi.server_name#/mls/#url.mlsnumber#-#url.wsid#-#url.mlsid#/#seoFriendlyURL#">
      <cfelse>
          <link rel="canonical" href="https://#cgi.server_name#/mls/#url.mlsnumber#-#url.wsid#-#url.mlsid#/#seoFriendlyURL#">
    </cfif>
    --->
  
  <!--- all other virtual pages found in the cms_pages table --->   
  <cfelse>
  
    <cfif isdefined('page.metatitle') and len(page.metatitle)>
      <title>#page.metatitle#</title>
    <cfelseif isdefined('page.name') and len(page.name)>
      <title>#page.name# - #settings.company#</title>
    </cfif>
    <cfif isdefined('page.metadescription') and len(page.metadescription)>
      <meta name="description" content="#page.metadescription#">
    <cfelseif isdefined('page.body') and len(page.body)>
      <cfset tempBody = striphtml(mid(page.body,1,155))>
      <meta name="description" content="#tempBody#">
    </cfif>
    <cfif isdefined('page.googleIndex') and page.googleIndex eq 'yes'>
      <meta name="robots" content="noindex,follow">
    </cfif>
    
    <cfif isdefined('page.slug') and len(page.slug) and page.slug eq 'index'>
     <cfif cgi.https eq 'off'>
      <link rel="canonical" href="http://#cgi.server_name#">
      <cfelse>
      <link rel="canonical" href="https://#cgi.server_name#">
      </cfif>
    <cfelseif isdefined('page.slug') and len(page.slug)>
        <cfif cgi.https eq 'off'>
      <link rel="canonical" href="http://#cgi.server_name#/#page.slug#">
      <cfelse>
      <link rel="canonical" href="https://#cgi.server_name#/#page.slug#">
      </cfif>
   </cfif>
    
  </cfif>
</cfoutput>
<meta name="referrer" content="unsafe-url">