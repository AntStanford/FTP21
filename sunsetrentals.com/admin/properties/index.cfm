<style>
  label {height:100%;width:100%;text-align: center;}
</style>

<cfset page.title ="Property Enhancement">
<cfinclude template="/admin/components/header.cfm">  

<cfif settings.booking.pms eq 'Homeaway'>
   
   <cfquery name="getinfo" dataSource="#settings.booking.dsn#">
     select 
     strpropid as property_id,
     strname as property_name
     from pp_propertyinfo
     order by strname
   </cfquery>

<cfelseif settings.booking.pms eq 'Barefoot'>
   
   <cfquery name="getinfo" dataSource="#settings.booking.dsn#">
     select 
     propertyid as property_id,
     name as property_name 
     from bf_properties
     order by name
   </cfquery>
   
<cfelseif settings.booking.pms eq 'Escapia'>
   
   <cfquery name="getinfo" dataSource="#settings.booking.dsn#">
     select 
     unitcode as property_id,
     unitshortname as property_name
     from escapia_properties
     order by unitshortname
   </cfquery>
      
<cfelseif settings.booking.pms eq 'Track'>
   
   <cfquery name="getinfo" dataSource="#settings.booking.dsn#">
     select 
     id as property_id,
     shortName as property_name
     from track_properties
     order by shortName
   </cfquery>
      
</cfif>  

     
<cfif isdefined('message') and len(message)>
  <div class="alert alert-success">
    <button class="close" data-dismiss="alert">x</button>
    <strong><cfoutput>#message#</cfoutput></strong>
  </div>
</cfif>

<div class="widget-box">
  <div class="widget-title">
    <span class="icon">
      <i class="icon-th"></i>
    </span>  
  	<h5>Properties</h5>
  </div>
  <div class="widget-content nopadding">
    <table class="table table-bordered table-striped table-hover">
    
    <cfoutput query="getinfo">
      
      <form method="post" action="form.cfm" id="theForm">          
         <cfif currentrow eq 1>
         <tr>
            <th>No.</th>
            <th>Unit</th>                         
            <th></th>
         </tr>        
         </cfif>         
         <tr>
            <td><a name="#property_id#"></a>#currentrow#.</td>
            <td>#property_name#</td>                    
            <td colspan="9" style="text-align:right"><a href="form.cfm?id=#property_id#&name=#property_name#" class="btn btn-success">Edit</a></td>            
         </tr>        
       </form> 
    </cfoutput>
    
</table>

<cfinclude template="/admin/components/footer.cfm">