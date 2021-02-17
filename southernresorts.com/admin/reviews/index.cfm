<cfset page.title ="Property Reviews">

<cfquery name="getinfo" dataSource="#settings.dsn#">
  select * from be_reviews order by createdAt desc
</cfquery>

<cfinclude template="/admin/components/header.cfm">  

<cfif isdefined('url.success')>
  <div class="alert alert-success">
    <button class="close" data-dismiss="alert">×</button>
    <strong>Review approved</strong>
  </div>
</cfif>

<cfif isdefined('url.delete')>
  <div class="alert alert-success">
    <button class="close" data-dismiss="alert">×</button>
    <strong>Review deleted</strong>
  </div>
</cfif>

<p><a href="form.cfm" class="btn btn-success"><i class="icon-plus icon-white"></i> Add New</a></p>

<div class="widget-box">
  <div class="widget-title">
    <span class="icon">
      <i class="icon-th"></i>
    </span>  
  	<h5><cfoutput>#page.title#</cfoutput></h5>
  </div>
  <div class="widget-content nopadding">
    <table class="table table-bordered table-striped">
    <tr>
      <th>No.</th>
      <th>Name</th>         
      <th>Property ID</th> 
      <th></th>  
      <th></th>
      <th></th>
      <th></th>
    </tr>        
    <cfoutput query="getinfo">
      <tr>
        <td width="45">#currentrow#.</td>
        <td>#firstname# #lastname#</td> 
        <td width="80">#unitcode#</td>           
        <td width="75">
          <cfif approved eq 'No'>
            <a href="submit.cfm?id=#id#&approve" class="btn btn-mini btn-primary"><i class="icon-thumbs-up icon-white"></i> Approve</a>
          <cfelse>
            Approved
          </cfif>
        </td>  
        <td width="65"><a href="submit.cfm?id=#id#&delete" class="btn btn-mini btn-danger" data-confirm="Are you sure you want to delete this review?"><i class="icon-remove icon-white"></i> Delete</a></td>         
        <td width="75"><a href="respond.cfm?id=#id#" class="btn btn-mini btn-info"><i class="icon-comment icon-white"></i> Respond</a></td>
        <td width="85"><a href="view.cfm?id=#id#" class="btn btn-mini btn-primary"><i class="icon-search icon-white"></i> View More</a></td>         
      </tr>
      <tr>
        <td colspan="7">#review#</td>
      </tr>
      <tr>
        <td colspan="7">&nbsp;</td>
      </tr>
    </cfoutput>
    </table>
  </div>
</div>

<cfinclude template="/admin/components/footer.cfm">