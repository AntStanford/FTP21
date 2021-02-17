<cfset page.title ="Things To Do">
<cfif isDefined("form.destination_id") AND form.destination_id NEQ 0>
	<cfset session.destination_id = form.destination_id>

</cfif>
<cfif isDefined("form.catid") AND form.catid NEQ 0>
	<cfset session.catid = form.catid>	
</cfif>

<cfparam name="form.destination_id" default="0">
<cfparam name="form.catID" default="0">

<cfquery name="getinfo" dataSource="#application.dsn#">
  select * from cms_thingstodo 
  WHERE 1 = 1
  <cfif form.destination_id gt 0 OR (isDefined("session.destination_id") AND session.destination_id GT 0)>
    and destination_id like <cfif isDefined("session.destination_ID")>'%-#session.destination_id#-%'<cfelse>'%-#form.destination_id#-%'</cfif>
        
  </cfif>
  <cfif form.catID gt 0 OR isDefined("session.catid")>
	  AND catID = <cfif isDefined("session.catID")>#session.catID#<cfelse>#form.catID#</cfif>
  </cfif>
   order by title
</cfquery> 
<cfquery name="getDestinations" dataSource="#application.dsn#">
   select * from track_nodes  where typeId = 3
</cfquery>
<cfquery name="getCategories" dataSource="#application.dsn#">
   select * from cms_thingstodo_categories  
</cfquery>
<cfinclude template="/admin/components/header.cfm">  

<cfif isdefined('url.success')>
  <div class="alert alert-success">
    <button class="close" data-dismiss="alert">×</button>
    <strong>Record deleted!</strong>
  </div>
</cfif>
<form action="index.cfm" method="post">
<p>
<a href="categories-index.cfm" class="btn btn-warning"><i class="icon-cog icon-white"></i> Manage Categories</a>
<a href="form.cfm" class="btn btn-success"><i class="icon-plus icon-white"></i> Add New</a>
  <select name="destination_ID" style="width: 300px;" onchange="this.form.submit()">
    <option value="-1">Choose a Destination</option>
    
    <cfoutput query="getDestinations">
      <option value="#getDestinations.id#" <cfif getDestinations.id eq form.destination_id>selected</cfif> <cfif isDefined("session.destination_id") AND getDestinations.id eq session.destination_id>selected</cfif>>#getDestinations.name#</option>
    </cfoutput>
  </select>
  <select name="catID" style="width: 300px;" onchange="this.form.submit()">
    <option value="0">Choose a Category</option> 
    <cfoutput query="getCategories">
      <option value="#getCategories.id#" <cfif getCategories.id eq form.catID>selected</cfif> <cfif isDefined("session.catid") AND getCategories.id eq session.catid>selected</cfif>>#getCategories.title#</option>
    </cfoutput>
  </select>
</p>
</form>
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