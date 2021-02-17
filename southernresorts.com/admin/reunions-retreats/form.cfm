<cfset page.title = "Reunions & Retreats">

<cfquery name="getprop" dataSource="#application.dsn#">
    select * from track_properties order by name asc
</cfquery>

<cfquery name="getname" dataSource="#application.dsn#">
	select name, slug from cms_reunions_retreats_locations where id = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#url.id#">
</cfquery>

<cfif isdefined('url.id')>
   	<cfquery name="getPageProperties" dataSource="#dsn#">
    	select propertyID from cms_reunions_retreats where AreaID = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#url.id#">
   	</cfquery>
   	<cfset propertyList = ValueList(getPageProperties.propertyID)>
</cfif>


<cfinclude template="/admin/components/header.cfm">


<!--- THIS IS FOR THE FEATURED PROPERTIES --->
<cfparam name="message" default="" >

<cfif isdefined('url.success')>
  <div class="alert alert-success">
    <strong>Properties Added</strong>
  </div>
</cfif>
<cfif len(message)>
	<div class='alert alert-success'>
		<button class="close" data-dimiss="alert">&times;</button>
		<strong><cfoutput>#message#</cfoutput></strong>
	</div>
</cfif>
<!---<cfif getinfo.recordcount gt 0>--->


<form action="submit.cfm" method="post">

	<div>
      <div>
        <table>
            <tr>
            	<td>
            		<div class="control-group">
                        <div class="controls">
                            <cfoutput>
                                Name <input class="sluggable" maxlength="255" name="name" id="name" type="text" <cfif parameterexists(id)>value="#getname.name#"</cfif>>
                            </cfoutput>
                        </div>
					</div>
            	</td>
                <td >
            		<div class="control-group">
                        <div class="controls">
                            <cfoutput>
                                Slug <input name="areaslug" id="areaslug" type="text" <cfif parameterexists(id)>value="#getname.slug#"</cfif>>
                            </cfoutput>
                        </div>
					</div>
            	</td>
            </tr>
        </table>
        <table class="table table-bordered">
            <tr>
                <th>Select</th>
                <th colspan="3">Property</th>
				<!---<th>Address</th>--->
                <!---<th>Enhanced</th>--->
                <!---<th>Rates</th>--->
                <!---<th>Photos</th>--->
                <!---<th>Enhanced</th>--->
                <!---<th>Manage</th>--->
                <!---<th>Featured</th>--->
            </tr>
			<cfoutput query="getprop">
                <tr>
                	<td>
						<cfif isdefined('url.id')>
                            <cfif isdefined('propertyList') and ListLen(propertyList) gt 0 and ListFind(propertylist,getprop.id)>
                                <input type="checkbox" class="props" name="properties" value="#id#" checked="checked">
         					<cfelse>
                                <input type="checkbox" class="props" name="properties" value="#id#">
                            </cfif>
                        <cfelse>
                            <input type="checkbox" class="props" name="properties" value="#id#">
                        </cfif>
                    </td>
                    <td>#id#</td><td>#name#</td><td>#streetaddress#</td>
                </tr>
            </cfoutput>
        </table>
      </div>
    </div>

    <div class="form-actions">
        <input type="submit" value="Submit" id="btnSave" class="btn btn-primary" />
        <cfoutput> <cfif parameterexists(id)><input type="hidden" name="id" value="#url.id#"></cfif></cfoutput>
    </div>

</form>

<script type="text/javascript">
	$(document).ready(function() {
		$("#name").on('blur', function (){	$("#areaslug").val(convertToSlug($(this).val()));	});
	});
	function convertToSlug(Text){
		return Text.toLowerCase().replace(/[^\w ]+/g,'').replace(/ +/g,'-');
	}
</script>
<cfinclude template="/admin/components/footer.cfm">
