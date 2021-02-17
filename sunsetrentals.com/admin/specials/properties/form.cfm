<cfif isdefined('url.id')>
  <cfquery name="getinfo" dataSource="#application.dsn#">
    select * from cms_specials_properties where unitcode = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#url.id#"> and specialid = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#specialid#">
  </cfquery>
</cfif>

<cfquery name="getProperties" datasource="#settings.booking.dsn#">
   select unitcode,unitshortname
  from escapia_properties
  order by unitshortname
</cfquery>

<cfset page.title ="Property Specials">
<cfset module = 'Property Specials'>
<cfinclude template="/admin/components/header.cfm">

<cfoutput>

  <cfif isdefined('url.success') and isdefined('url.id')>
    <div class="alert alert-success">
      <button class="close" data-dismiss="alert">×</button>
      <strong>Update successful!</strong> Continue editing this #module# or <a href="index.cfm?specialid=#specialid#">go back.</a>
    </div>
  <cfelseif isdefined('url.success')>
    <div class="alert alert-success">
      <button class="close" data-dismiss="alert">×</button>
      <strong>Success!</strong> Add another #module# or <a href="index.cfm?specialid=#specialid#">go back.</a>
    </div>
  </cfif>

  <div class="widget-box">
    <div class="widget-title">
      <span class="icon">
        <i class="icon-th"></i>
      </span>
      <h5>Add / Edit Form</h5>
    </div>
    <div class="widget-content nopadding">

      <form action="submit.cfm" method="post" class="form-horizontal">

	  <div class="control-group">
					<label class="control-label">Property</label>
					<div class="controls">

						<select name="UnitCode" style="width:300px" <cfif parameterexists(id)>disabled="disabled"</cfif>>
						  <cfloop query="getProperties">
							<option value="#unitcode#" <cfif parameterexists(id) and getinfo.UnitCode is getProperties.unitcode>SELECTED</cfif>>#unitshortname#</option>
						  </cfloop>
						</select>
					</div>
				</div>


	   <div class="control-group">
					<label class="control-label">Active</label>
					<div class="controls">
						<select name="active">
							<option value="Yes" <cfif parameterexists(id) and getinfo.active is "Yes">SELECTED</cfif>>Yes</option>
							<option value="No" <cfif parameterexists(id) and getinfo.active is "No">SELECTED</cfif>>No</option>
						</select>
					</div>
				</div>


        <div class="control-group">
					<label class="control-label">Price Was</label>
					<div class="controls">
						<input maxlength="255" name="PriceWas" type="text" <cfif parameterexists(id)>value="#getinfo.PriceWas#"</cfif>>
					</div>
				</div>

            <div class="control-group">
					<label class="control-label">Price Reduced To</label>
					<div class="controls">
						<input maxlength="255" name="PriceReducedTo" type="text" <cfif parameterexists(id)>value="#getinfo.PriceReducedTo#"</cfif>>
					</div>
				</div>


				<input type="hidden" name="description">

       <!---
 <div class="control-group">
					<label class="control-label">Description of special for this proeprty.</label>
					<div class="controls">

            <textarea name="description" rows="4" cols="30" id="txtContent"><cfif parameterexists(id)>#getinfo.description#</cfif></textarea>

					</div>
				</div>
--->


				<div class="form-actions">
					<input type="submit" value="Submit" class="btn btn-primary">
          <cfif parameterexists(id)><input type="hidden" name="id" value="#url.id#"></cfif>
		  <cfif parameterexists(specialid)><input type="hidden" name="specialid" value="#url.specialid#"></cfif>

				</div>
      </form>

    </div>
  </div>

</cfoutput>

<cfinclude template="/admin/components/footer.cfm">