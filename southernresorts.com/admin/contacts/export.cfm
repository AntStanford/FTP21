<cfif cgi.script_name is not '/admin/login.cfm' AND (NOT isdefined('cookie.LoggedInID') or NOT isdefined('cookie.LoggedInName') or NOT isdefined('cookie.LoggedInRole'))>
  <cflocation addToken="no" url="/admin/login.cfm">
</cfif>

<cfcontent type="text/csv">
<cfheader name="Content-Disposition" value="filename=southern_resorts_contacts.csv">

<cfquery name="getinfo" dataSource="#application.dsn#">
  select * from cms_contacts   order by createdat desc
</cfquery>

<cfsavecontent variable="newCSV">
First Name,Last Name,Email,Address,Address 2,City,State,Zip,Email,Phone,Date,Came From,comments
<cfloop query="GetInfo">
<cfoutput>#firstname#,#lastname#,<cfif len(email)>#decrypt(email, application.contactInfoEncryptKey, 'AES')#</cfif>,#address1#,#address2#,#city#,#state#,#zip#,<cfif len(email)>#decrypt(email, application.contactInfoEncryptKey, 'AES')#</cfif>,<cfif len(phone)>#decrypt(phone, application.contactInfoEncryptKey, 'AES')#</cfif>,#DateFormat(createdat,'mmmm d  yyyy')#,#camefrom#,#REReplace(comments,"[^0-9A-Za-z ]","","all")##chr(13)##chr(10)#</cfoutput>
</cfloop>
</cfsavecontent>

<cfoutput>#newCSV#</cfoutput>

<cfscript>
function csvToQuery(csvString){
	var rowDelim = chr(10);
	var colDelim = ",";
	var numCols = 1;
	var newQuery = QueryNew("");
	var arrayCol = ArrayNew(1);
	var i = 1;
	var j = 1;

	csvString = trim(csvString);

	if(arrayLen(arguments) GE 2) rowDelim = arguments[2];
	if(arrayLen(arguments) GE 3) colDelim = arguments[3];

	arrayCol = listToArray(listFirst(csvString,rowDelim),colDelim);

	for(i=1; i le arrayLen(arrayCol); i=i+1) queryAddColumn(newQuery, arrayCol[i], ArrayNew(1));

	for(i=2; i le listLen(csvString,rowDelim); i=i+1) {
		queryAddRow(newQuery);
		for(j=1; j le arrayLen(arrayCol); j=j+1) {
			if(listLen(listGetAt(csvString,i,rowDelim),colDelim) ge j) {
				querySetCell(newQuery, arrayCol[j],listGetAt(listGetAt(csvString,i,rowDelim),j,colDelim), i-1);
			}
		}
	}
	return newQuery;
}
</cfscript>
