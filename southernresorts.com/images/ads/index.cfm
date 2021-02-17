<cfset page.title="Events">

<cfquery name="getinfo" dataSource="#application.dsn#">
select * from ads 
order by name
</cfquery>

<cfif isdefined('RunReport')>
	<cfset StartDate = "#form.startdate#">
	<cfset EndDate = "#form.enddate#">
<cfelse>
	<cfset StartDate = "#dateformat(now(),'mm')#/01/#dateformat(now(),'yyyy')#">
	<cfset EndDate = "#dateformat(now(),'mm/dd/yyyy')#">
</cfif>

<cfquery name="GetImpressions" dataSource="#application.dsn#">
select * from ads_impressions
where createdat between <cfqueryparam value="#StartDate#" cfsqltype="CF_SQL_TimeStamp"> and  <cfqueryparam CFSQLType="CF_SQL_TimeStamp" value="#EndDate# 23:59:59">
</cfquery>

<cfquery name="GetClicks" dataSource="#application.dsn#">
select * from ads_clicks
where createdat between <cfqueryparam value="#StartDate#" cfsqltype="CF_SQL_TimeStamp"> and  <cfqueryparam CFSQLType="CF_SQL_TimeStamp" value="#EndDate# 23:59:59">
</cfquery>


<cfinclude template="/admin/components/header.cfm">


<form action="index.cfm" method="post">
<cfoutput>
<table>
<tr>
<td>Start Date:</td><td><input type="text" class="datepicker" name="StartDate" value="#startdate#"></td>
<td>End Date:</td><td><input type="text" class="datepicker" name="EndDate" value="#EndDate#"></td>
<td><input type="submit" class="btn btn-success" name="RunReport" value="Run Report"></td><td><a href="index.cfm" class="btn btn-warning">Reset</a></td>
</tr>
</table>
</cfoutput>
</form>


<cfif isdefined('url.success')>
<div class="alert alert-success">
<button class="close" data-dismiss="alert">×</button>
<strong>Record deleted!</strong>
</div>
</cfif>

<p>
<a href="form.cfm" class="btn btn-success"><i class="icon-plus icon-white"></i>Add New</a>
</p>

<cfif getinfo.recordcount gt 0>
<div class="widget-box">
	
	<div class="widget-content nopadding">
	
	<table class="table table-bordered table-striped">
	<tr>
<th width="30">No.</th>
<th>Name</th>
<th>Start Date</th>
<th>End Date</th>
<th>Impressions</th>
<th>Clicks</th>
<th>Click Through Rate</th>
<th></th>
<th></th>
</tr>

<cfoutput query="getinfo">

<cfquery name="GetImpression" dbtype="query">
select * from GetImpressions
where adid = '#id#'
</cfquery>

<cfquery name="GetClick" dbtype="query">
select * from GetClicks
where adid = '#id#'
</cfquery>

<tr>
<td>#currentrow#.</td>
<td>#name#</td>
<td>#DateFormat(time_start,'mm/dd/yyyy')#</td>
<td>#DateFormat(time_end,'mm/dd/yyyy')#</td>
<td>#GetImpression.recordcount#</td>
<td>#GetClick.recordcount#</td>
<td><cfif GetImpression.recordcount gt 0>#numberformat(evaluate((GetClick.recordcount/GetImpression.recordcount) * 100),'__.__')#%<cfelse>N/A</cfif></td>
<td width="50"><a href="form.cfm?id=#id#" class="btn btn-mini btn-primary"><i class="icon-pencil icon-white"></i> Edit</a></td>
<td width="65"><a href="submit.cfm?id=#id#&delete" class="btn btn-mini btn-danger" data-confirm="Are you sure you want to delete this ad?"><i class="icon-remove icon-white"></i> Delete</a></td> 
</tr>
</cfoutput>

</table>

	</div>

</div>
</cfif>



<cfinclude template="/admin/components/footer.cfm">

<scriptsrc="/admin/javascripts/_plugins/blog/jquery.blog.js"></script> 

