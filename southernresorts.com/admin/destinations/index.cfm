<cfset page.title ="Destinations">

<cfquery name="getinfo" dataSource="#application.dsn#">
  SELECT tn.name, tn.id as nodeid, d.bannerimage, d.hideOnSite, d.canonicallink, d.description, d.h1, ifnull(d.id,0) as id, d.metadescription, d.sort, d.title FROM southernresorts.track_nodes tn left join cms_destinations d on d.nodeid = tn.id  where tn.typeid = 3
</cfquery>

<cfinclude template="/admin/components/header.cfm">  

<cfif isdefined('url.success')>
  <div class="alert alert-success">
    <button class="close" data-dismiss="alert">×</button>
    <strong>Record deleted!</strong>
  </div>
</cfif>




<p>
  <a href="form.cfm" class="btn btn-success"><i class="icon-plus icon-white"></i> Add New</a>
</p>

<cfif getinfo.recordcount gt 0>
<div class="widget-box">
  
  <div class="widget-content nopadding">
    
    <table class="table table-bordered table-striped">
    <tr>
      <th width="30">No.</th>
      <th>Destination ID</th>
      <th>Title</th>       
      <th>Hide On Site?</th>
      <th></th>  
    </tr>  
      
    <cfoutput query="getinfo">
      <tr>
        <td>#currentrow#.</td>
        <td width="100">#nodeid#</td>
        <td>#Name#</td>
		    <td width="100">#hideOnSite#</td>  
        <td width="50"><a href="form.cfm?nodeid=#nodeid#&id=#id#" class="btn btn-mini btn-primary"><i class="icon-pencil icon-white"></i> Edit</a></td>
      </tr>
    </cfoutput>
  
    </table>
    
  </div>

</div>
</cfif>



<cfinclude template="/admin/components/footer.cfm">

<script src="/admin/javascripts/_plugins/blog/jquery.blog.js"></script>