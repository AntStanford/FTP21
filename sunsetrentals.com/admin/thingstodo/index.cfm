<cfset page.title ="Things To Do">

<cfquery name="getinfo" dataSource="#application.dsn#">
  select * from cms_thingstodo order by title
</cfquery>

<cfinclude template="/admin/components/header.cfm">  

<cfif isdefined('url.success')>
  <div class="alert alert-success">
    <button class="close" data-dismiss="alert">×</button>
    <strong>Record deleted!</strong>
  </div>
</cfif>

<p>
<a href="categories-index.cfm" class="btn btn-warning"><i class="icon-cog icon-white"></i> Manage Categories</a>
<a href="form.cfm" class="btn btn-success"><i class="icon-plus icon-white"></i> Add New</a>
</p>

<cfif getinfo.recordcount gt 0>
<div class="widget-box">
  <div class="widget-content nopadding">
    <table class="table table-bordered table-striped">
    <tr>
      <th>No.</th>
      <th>Title</th>
      <th>Category</th>
      <th></th> 
      <th></th>  
    </tr>        
    <cfoutput query="getinfo">
      <tr>
        <td width="45">#currentrow#.</td>
        <td>#title#</td>
        
        <cfquery name="getCategory" dataSource="#dsn#">
         select title from cms_thingstodo_categories where id = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#getinfo.catID#">
        </cfquery>
        
        <cfif getcategory.recordcount gt 0 and len(getCategory.title)>
            <td>#getcategory.title#</td>
        <cfelse>
            <td></td>
        </cfif>
        
        <td width="50"><a href="form.cfm?id=#id#" class="btn btn-mini btn-primary"><i class="icon-pencil icon-white"></i> Edit</a></td>
        <td width="65"><a href="submit.cfm?id=#id#&delete" class="btn btn-mini btn-danger" data-confirm="Are you sure you want to delete this thing to do?"><i class="icon-remove icon-white"></i> Delete</a></td>         
      </tr>
    </cfoutput>
    </table>
  </div>
</div>
</cfif>

<cfinclude template="/admin/components/footer.cfm">