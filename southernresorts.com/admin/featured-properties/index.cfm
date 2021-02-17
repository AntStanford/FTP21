<cfset page.title ="Featured Properties">
<cfinclude template="/admin/components/header.cfm">

<cfquery name="getFeaturedProperties" dataSource="#settings.dsn#">
   select strpropid from cms_featured_properties
</cfquery>

<cfset propList = ValueList(getFeaturedProperties.strpropid)>

<cfif settings.booking.pms eq 'Homeaway'>

   <cfquery name="getinfo" dataSource="#settings.booking.dsn#">
     select strpropid,strname,straddress2
     from pp_propertyinfo
     order by strname
   </cfquery>

<cfelseif settings.booking.pms eq 'Barefoot'>

   <cfquery name="getinfo" dataSource="#settings.booking.dsn#">
     select propertyid,name,propaddress
     from bf_properties
     order by name
   </cfquery>

<cfelseif settings.booking.pms eq 'Escapia'>

   <cfquery name="getinfo" dataSource="#settings.booking.dsn#">
     select unitcode,unitshortname,address
     from escapia_properties
     order by unitshortname
   </cfquery>

<cfelseif settings.booking.pms eq 'Track'>

   <cfquery name="getinfo" dataSource="#settings.booking.dsn#">
     select id,shortname,streetaddress
     from track_properties
     order by shortname
   </cfquery>


</cfif>

<cfif isdefined('message') and len(message)>
  <div class="alert alert-success">
    <button class="close" data-dismiss="alert">x</button>
    <strong><cfoutput>#message#</cfoutput></strong>
  </div>
</cfif>

<div class="alert">
Directions: You have two options with this module:<br /><br />
<ol>
   <li>The website will pick properties at random for your homepage featured properties module OR</li>
   <li>You can manually choose which properties you want to appear on your homepage</li>
</ol>
If you want the website to display properties at random, leave all the property options below set to 'OFF'; otherwise the website
will only display the properties you have chosen below that are set to 'ON'.
<br /><br />Selected properties will also appear in random order for each guest.
</div>

    <div id="console-event"></div>

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
            <th>Property ID</th>
            <th>Name</th>
            <th>Address</th>
            <th></th>
         </tr>
         </cfif>
         <cfif settings.booking.pms eq 'Homeaway'>
         <tr>
            <td><a name="#strpropid#"></a>#currentrow#.</td>
            <td>#strpropid#</td>
            <td>#strname#</td>
            <td>#straddress2#</td>
            <cfif ListFind(propList,strpropid)>
               <td colspan="9" style="text-align:right"><input checked="checked" type="checkbox" data-toggle="toggle" class="toggle-event" data-propertyid="#strpropid#"></td>
            <cfelse>
               <td colspan="9" style="text-align:right"><input type="checkbox" data-toggle="toggle" class="toggle-event" data-propertyid="#strpropid#"></td>
            </cfif>
         </tr>
         <cfelseif settings.booking.pms eq 'Barefoot'>
         <tr>
            <td><a name="#propertyid#"></a>#currentrow#.</td>
            <td>#propertyid#</td>
            <td>#name#</td>
            <td>#propAddress#</td>
            <cfif ListFind(propList,propertyid)>
               <td colspan="9" style="text-align:right"><input type="checkbox" checked="checked" data-toggle="toggle" class="toggle-event" data-propertyid="#propertyid#"></td>
            <cfelse>
               <td colspan="9" style="text-align:right"><input type="checkbox" data-toggle="toggle" class="toggle-event" data-propertyid="#propertyid#"></td>
            </cfif>
         </tr>
         <cfelseif settings.booking.pms eq 'Escapia'>
         <tr>
            <td><a name="#unitcode#"></a>#currentrow#.</td>
            <td>#unitcode#</td>
            <td>#unitshortname#</td>
            <td>#address#</td>
            <cfif ListFind(propList,unitcode)>
               <td colspan="9" style="text-align:right"><input type="checkbox" checked="checked" data-toggle="toggle" class="toggle-event" data-propertyid="#unitcode#"></td>
            <cfelse>
               <td colspan="9" style="text-align:right"><input type="checkbox" data-toggle="toggle" class="toggle-event" data-propertyid="#unitcode#"></td>
            </cfif>
         </tr>
         <cfelseif settings.booking.pms eq 'Track'>
         <tr>
            <td><a name="#id#"></a>#currentrow#.</td>
            <td>#id#</td>
            <td>#shortname#</td>
            <td>#streetaddress#</td>
            <cfif ListFind(propList,id)>
               <td colspan="9" style="text-align:right"><input type="checkbox" checked="checked" data-toggle="toggle" class="toggle-event" data-propertyid="#id#"></td>
            <cfelse>
               <td colspan="9" style="text-align:right"><input type="checkbox" data-toggle="toggle" class="toggle-event" data-propertyid="#id#"></td>
            </cfif>
         </tr>
         </cfif>
       </form>
    </cfoutput>

</table>

<script type="text/javascript">

	$(document).ready(function(){

		$('.toggle-event').change(function() {

         var propertyid = $(this).data('propertyid');

         $.ajax({
   			url: 'submit.cfm?propertyid='+propertyid,
   			success: function(data) {
   			   //do nuthin
   			}
         });


      });

	});

</script>

<cfinclude template="/admin/components/footer.cfm">
