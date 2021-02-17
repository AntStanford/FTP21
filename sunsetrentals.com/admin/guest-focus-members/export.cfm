<cfquery name="getinfo" dataSource="#application.dsn#">
  select * from guest_focus_users order by createdat
</cfquery>

<cfcontent type="application/vnd.ms-excel">
<cfheader name="Content-Disposition" value="filename=MemberExport.xls">

<cfoutput>
<table border="1">

<tr>
<td>First Name</td><td>Last Name</td><td>Address</td><td>City</td><td>State</td><td>Zip</td><td>Email</td><td>Phone</td><td>Date</td>
</tr>

<cfloop query="GetInfo">
<tr>
  <td>#firstname#</td><td>#lastname#</td><td>#address#</td><td>#city#</td><td>#state#</td><td>#zip#</td><td>#email#</td><td>#phone#</td><td>#dateformat(createdat,'mm/dd/yy')# #timeformat(createdat,'hh:mm tt')#</td>
</tr>
</cfloop>

</table>
</cfoutput>