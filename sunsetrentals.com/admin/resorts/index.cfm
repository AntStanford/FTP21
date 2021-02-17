<cfset page.title ="Resorts">

<cfquery name="getinfo" dataSource="#application.dsn#">
  select * from cms_resorts order by name
</cfquery>

<cfinclude template="/admin/components/header.cfm"> 

<cfif isdefined('url.success')>
  <div class="alert alert-success">
    <button class="close" data-dismiss="alert">&times;</button>
    <strong>Record deleted!</strong>
  </div>
</cfif>

<cfif isdefined('url.status')>
  <div class="alert alert-success">
    <button class="close" data-dismiss="alert">&times;</button>
    <strong>Status Updated!</strong>
  </div>
</cfif>

<p><a href="form.cfm" class="btn btn-success"><i class="icon-plus icon-white"></i> Add New</a></p>

<div class="widget-box">
  <div class="widget-title">
    <span class="icon">
      <i class="icon-th"></i>
    </span>
    <h5>Properties</h5>
  </div>
  <div class="widget-content nopadding">
    <table class="table table-bordered table-striped table-hover">
    <tr>
      <th>No.</th>
      <th>Name</th>
      <th></th>          
      <th></th>
      <th></th> 
      <th></th>     
    </tr>
    <cfoutput query="getinfo">  				    	
      <tr>
        <td width="45">#currentrow#.</td>
        <td>#name#</td>       
        <td width="58"><a href="/resort/#slug#" target="_blank" class="btn btn-mini btn-info"><i class="icon-search icon-white"></i> View</a></td>
        <td width="68"><a href="multi-upload-gallery/index.cfm?id=#id#" class="btn btn-mini btn-warning"><i class="icon-search icon-white"></i> Photos</a></td>
        <td width="50"><a href="form.cfm?id=#id#" class="btn btn-mini btn-primary"><i class="icon-pencil icon-white"></i> Edit</a></td>
        <td width="70"><a href="submit.cfm?id=#id#&delete" class="btn btn-mini btn-danger" data-confirm="Are you sure you want to delete this resort?"><i class="icon-trash icon-white"></i> Delete</a></td>              
      </tr>
    </cfoutput>
    </table>
  </div>
</div>

<cfinclude template="/admin/components/footer.cfm">