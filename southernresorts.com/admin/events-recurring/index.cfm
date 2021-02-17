<cftry>

<cfset page.title ="Events">

<cfquery name="getinfo" dataSource="#application.dsn#">
select * from cms_eventcal order by start_date
</cfquery>

<cfinclude template="/admin/components/header.cfm">

<cfif isdefined('url.success')>
  <div class="alert alert-success">
    <button class="close" data-dismiss="alert">×</button>
    <strong>Record deleted!</strong>
  </div>
</cfif>

<cfif isdefined('url.recurSuccess')>
  <div class="alert alert-success">
    <button class="close" data-dismiss="alert">×</button>
    <strong>Recurring event updated!</strong>
  </div>
</cfif>

<p><a href="form.cfm" class="btn btn-success"><i class="icon-plus icon-white"></i> Add New</a></p>

<cfif getinfo.recordcount gt 0>
<div class="widget-box">
  <div class="widget-content nopadding">
    <table class="table table-bordered table-striped">
    <tr>
      <th>No.</th>       
    <th>Title</th>   
    <th>Event Date(s)</th> 
      <th></th> 
      <th></th> 
    <th></th> 
    </tr>        
    <cfoutput query="getinfo">
      <tr>
        <td width="45">#currentrow#.</td>
    <td>#event_title#</td>
        <td>#dateformat(start_date,'mm/dd/yyyy')# <cfif len(end_date) and end_date is not start_date> - #dateformat(end_date,'mm/dd/yyyy')#</cfif></td>               
        <td width="50"><a href="form.cfm?id=#id#" class="btn btn-mini btn-primary"><i class="icon-pencil icon-white"></i> Edit</a></td>
        <td width="65"><a href="submit.cfm?id=#id#&delete" class="btn btn-mini btn-danger" data-confirm="Are you sure you want to delete this event?"><i class="icon-remove icon-white"></i> Delete</a></td>    
        <td width="100"><cfif reocurringEventID is not ""><a href="submit.cfm?reocurringEventID=#reocurringEventID#&deleteSeries" class="btn btn-mini btn-danger" data-confirm="Are you sure you want to delete this entire series?"><i class="icon-remove icon-white"></i> Delete Series</a></cfif></td>        
      </tr>
    </cfoutput>
    </table>
  </div>
</div>
</cfif>

<cfinclude template="/admin/components/footer.cfm">

<cfcatch>
  <cfdump var="#cfcatch#" abort="true" />
</cfcatch>

</cftry>