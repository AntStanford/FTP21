<cfquery name="getinfo" datasource="#settings.dsn#">
  select * from guest_focus_users where email in (<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#session.userList#" list="Yes">) order by firstname
</cfquery>

<cfcontent type="application/vnd.ms-excel">
<cfheader name="Content-Disposition" value="filename=export.xls">

<cfoutput>
<table border="1">

<tr>
<td>First Name</td><td>Last Name</td><td>Email</td>
</tr>

<cfloop query="GetInfo">
<tr>
  <td>#firstname#</td><td>#lastname#</td><td>#email#</td>
</tr>
</cfloop>

</table>
</cfoutput>