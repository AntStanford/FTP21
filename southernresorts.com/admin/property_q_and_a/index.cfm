<cfset page.title ="Property FAQs">

<cfquery name="getinfo" dataSource="#settings.dsn#">
  select * from be_questions_and_answers_properties order by createdat desc
</cfquery>

<cfinclude template="/admin/components/header.cfm">

<cfif isdefined('url.success')>
  <div class="alert alert-success">
    <button class="close" data-dismiss="alert">×</button>
    <strong>Record deleted!</strong>
  </div>
</cfif>

<p><a href="form.cfm" class="btn btn-success"><i class="icon-plus icon-white"></i> Add New</a></p>

<cfif getinfo.recordcount gt 0>
<div class="widget-box">
  <div class="widget-content nopadding">
    <table class="table table-bordered table-striped">
    <tr>
      <th>No.</th>
	  <th>Property</th> 
      <th>Question</th>     
	  <th>Approved?</th> 
      <th></th> 
      <th></th>  
    </tr>        
    <cfoutput query="getinfo">
            
      <cfif settings.booking.pms eq 'Homeaway'>
         
         <cfquery name="getPropertyInfo" dataSource="#settings.booking.dsn#">
            select strname from pp_propertyinfo where strpropid = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#getinfo.propertyid#">
         </cfquery>
         
         <cfset propertyname = getPropertyInfo.strname>
      
      <cfelseif settings.booking.pms eq 'Barefoot'>
         
         <cfquery name="getPropertyInfo" dataSource="#settings.booking.dsn#">
            select name from bf_properties where propertyid = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#getinfo.propertyid#">
         </cfquery>
         
         <cfset propertyname = getPropertyInfo.name>
      
      <cfelseif settings.booking.pms eq 'Escapia'>
                  
         <cfquery name="getPropertyInfo" dataSource="#settings.booking.dsn#">
            select unitshortname from escapia_properties where unitcode = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#getinfo.propertyid#">
         </cfquery>
         
         <cfset propertyname = getPropertyInfo.unitshortname>
      
      </cfif>
      
      <tr>
         <td width="45">#currentrow#.</td>
         <td>#propertyname#</td>  
         <td>#question#</td>         
         <td width="50"><cfif approved is "No"><span style="color: red; font-weight: bold;">#approved#</span><cfelse><span style="color: green; font-weight: bold;">#approved#</span></cfif></td>         
         <td width="50"><a href="form.cfm?id=#id#" class="btn btn-mini btn-primary"><i class="icon-pencil icon-white"></i> Edit</a></td>
         <td width="65"><a href="submit.cfm?id=#id#&delete" class="btn btn-mini btn-danger" data-confirm="Are you sure you want to delete this Property FAQ?"><i class="icon-remove icon-white"></i> Delete</a></td>         
      </tr>
    </cfoutput>
    </table>
  </div>
</div>
</cfif>

<cfinclude template="/admin/components/footer.cfm">