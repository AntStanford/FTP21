<cfset page.title ="Not Found Frequency">

<cfif isdefined('url.flush')>
   
   <cfquery dataSource="#dsn#">
     DELETE FROM notfound
   </cfquery>
   
</cfif>

<cfif isdefined('MarkAsFixed')>

	<CFQUERY NAME="UpdateQuery" DATASOURCE="#dsn#">
		UPDATE notfound
		SET 
		Fixed = 'Yes'
		where thepage = <cfqueryparam CFSQLType="CF_SQL_LONGVARCHAR" value="#MarkAsFixed#">
	</cfquery>

</cfif>

 
  <cfquery name="GetFrequency" dataSource="#application.dsn#">
  	select 
  	count(thepage) as countTP,  thepage, id, notes, max(thedate) as maxdate,thereferer
	from notfound 
	  WHERE `thepage` NOT LIKE '%.css%' 	  
	  AND `thepage` NOT LIKE '%.jpg%'	  
	  AND `thepage` NOT LIKE '%.png%' 
	  AND `thepage` NOT LIKE '%.js%' 
	  and remoteip not like '216.99.119.254' 
	  and thedate > '2015-12-10' 
	  and Fixed is NULL
	group by thepage 
	order by countTP desc
	limit 1000
  </cfquery>
 

<cfinclude template="/admin/components/header.cfm">

<cfif isdefined('url.success')>
 <div class="alert alert-success">
   <button class="close" data-dismiss="alert">×</button>
   <strong>Note Added Successfully!</strong>
 </div>
</cfif>

<cfif isdefined('url.flush')>
 <div class="alert alert-success">
   <button class="close" data-dismiss="alert">×</button>
   <strong>The 404 table has been flushed.</strong>
 </div>
</cfif>


<div>
   <a href="notfound-frequency.cfm?flush" class="btn btn-info">Flush 404 table</a>
</div>

<cfif GetFrequency.recordcount gt 0>



<div class="widget-box">
  <div class="widget-content nopadding">
    <table class="table table-bordered table-striped">
    <tr>
		<th>No.</th>
		<th>Last Hit</th>
		<th>Page</th>
		<th>Referer</th>
		<th>Notes</th>
		<th>Add Note</th>
		<th></th>  
    </tr>        
    <cfoutput query="GetFrequency">
      <tr>
			<td width="45">#countTP#.</td>
			<td>#dateformat(maxdate,'mm/dd/yyyy')#</td>
			<td><a href="http://#settings.website#/#thepage#">#thepage#</a></td>  
			<td>#thereferer#</td> 
			<td><cfif notes is not "">Has Notes</cfif></td>
			<td width="65"><a href="notfound-frequency-form.cfm?id=#id#" class="btn btn-mini btn-primary"><i class="icon-pencil icon-white"></i> Edit</a></td>
			<td width="65"><a href="notfound-frequency.cfm?MarkAsFixed=#thepage#" class="btn btn-mini btn-success" data-confirm="Are you sure you want to mark this as fixed?"><i class="icon-ok icon-white"></i> Fixed</a></td>         
      </tr>
    </cfoutput>
    </table>
  </div>
</div>
</cfif>

<cfinclude template="/admin/components/footer.cfm">