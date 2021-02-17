<cfset page.title ="Resorts">

<cfquery name="getAllProperties" dataSource="#application.dsn#">
  select * from track_nodes where typeid = 5 order by name
</cfquery>
<cfquery name="getResortProperties" dataSource="#settings.dsn#">
   select propertyid from cms_resorts
</cfquery>

<cfset propList = ValueList(getResortProperties.propertyid)>
<cfinclude template="/admin/components/header.cfm"> 

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
    </tr>
    <cfoutput query="getAllProperties">                
      <tr>
        <td width="45">#getAllProperties.currentrow#.</td>
        <td>#getAllProperties.name#</td>    
        <td colspan="9" style="text-align:right">
          <a href="form.cfm?id=#getAllProperties.id#" class="btn btn-success">Edit</a>
        </td>         
      </tr>
    </cfoutput>
    </table>
  </div>
</div> 
<cfinclude template="/admin/components/footer.cfm">