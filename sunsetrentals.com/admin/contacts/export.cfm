<cfif cgi.script_name is not '/admin/login.cfm' AND NOT checkLoggedInUserSecurity()>
    <cflocation addToken="no" url="/admin/login.cfm?logout">
</cfif>

<cfcontent type="text/csv">
<cfheader name="Content-Disposition" value="filename=expor3.csv">

<cfquery name="getinfo" dataSource="#application.dsn#">
  select * from cms_contacts order by firstname
</cfquery>

<cfset crlf = "#Chr(13)##Chr(10)#">

<cfsavecontent variable="newCSV">
First Name,Last Name,Email,Address,Address 2,City,State,Zip,Phone,Date,Came From
<cfloop query="GetInfo">
<cfoutput>#firstname#,#lastname#,<cfif len(email)>#decrypt(email, application.contactInfoEncryptKey, 'AES')#</cfif>,#address1#,#address2#,#city#,#state#,#zip#,<cfif len(phone)>#decrypt(phone, application.contactInfoEncryptKey, 'AES')#</cfif>,#createdat#,#camefrom##crlf#</cfoutput>
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