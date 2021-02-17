<cfif isdefined('url.id')>
  <cfquery name="getinfo" dataSource="#settings.dsn#">
    select * from be_questions_and_answers_properties where id = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#url.id#">
  </cfquery>
</cfif>

<cfif settings.booking.pms eq 'Homeaway'>
   
   <cfquery name="getProperties" dataSource="#dsn#">
      select 
      	strpropid as propertyid,
      	strname as name 
      from 
      	pp_propertyinfo 
      order by 
      	strname
   </cfquery>

<cfelseif settings.booking.pms eq 'Barefoot'>
   
   <cfquery name="getProperties" dataSource="#dsn#">
      select 
      	propertyid,
      	name 
      from 
      	bf_properties 
      order by 
      	name
   </cfquery>

<cfelseif settings.booking.pms eq 'Escapia'>
   
   <cfquery name="getProperties" dataSource="#settings.booking.dsn#">
      select 
      	unitcode as propertyid,
      	unitshortname as name 
      from 
      		escapia_properties 
      order by 
      	unitshortname
   </cfquery>

</cfif>

<cfset page.title ="Property Q & A">
<cfset module = 'property faq'>
<cfinclude template="/admin/components/header.cfm">

<cfoutput>

  <cfif isdefined('url.success') and isdefined('url.id')>
    <div class="alert alert-success">
      <button class="close" data-dismiss="alert">×</button>
      <strong>Update successful!</strong> Continue editing this #module# or <a href="index.cfm">go back.</a>
    </div>
  <cfelseif isdefined('url.success')>
    <div class="alert alert-success">
      <button class="close" data-dismiss="alert">×</button>
      <strong>Success!</strong> Add another #module# or <a href="index.cfm">go back.</a>
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
			<cfif parameterexists(id)>
			               
            <cfif settings.booking.pms eq 'Homeaway'>
            
               <cfquery name="getPropertyInfo" dataSource="#settings.booking.dsn#">
                  select strname as name from pp_propertyinfo where strpropid = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#getinfo.propertyid#">
               </cfquery>
            
            <cfelseif settings.booking.pms eq 'Barefoot'>
               
               <cfquery name="getPropertyInfo" dataSource="#settings.booking.dsn#">
                  select name from bf_properties where propertyid = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#getinfo.propertyid#">
               </cfquery>
            
            <cfelseif settings.booking.pms eq 'Escapia'>
           
               <cfquery name="getPropertyInfo" dataSource="#settings.booking.dsn#">
                  select unitshortname as name from escapia_properties where unitcode = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#getinfo.propertyid#">
               </cfquery>
               
            </cfif>
            
            #getPropertyInfo.name#
            
            <input type="hidden" name="property_name" value="#getPropertyInfo.name#">
      
			<cfelse>
              <select name="propertyid" style="width:250px">
      			  <cfloop query="GetProperties">      			   
      			      <option value="#propertyid#">#name#</option>      			   
      			  </cfloop>
             </select>
			</cfif>
            </div>
          </div>
	  
	  	<cfif parameterexists(id)>
	   <div class="control-group">
					<label class="control-label">Asked By</label>
					<div class="controls">
						<a href="mailto:#getinfo.email#">#getinfo.firstname# #getinfo.lastname#</a>  on #dateformat(getinfo.createdat,'mm/dd/yyyy')#
					</div>
				</div>
			<input type="hidden" name="email" value="#getinfo.email#">
			<input type="hidden" name="propertyid" value="#getinfo.propertyid#">
			
		</cfif>
	  
        <div class="control-group">
					<label class="control-label">Question</label>
					<div class="controls">
						<input maxlength="255" name="question" type="text" <cfif parameterexists(id)>value="#getinfo.question#"</cfif>>
					</div>
				</div>
        <div class="control-group">
					<label class="control-label">Answer</label>
					<div class="controls">
						
            <textarea name="answer" rows="4" cols="30"><cfif parameterexists(id)>#getinfo.answer#</cfif></textarea>
            
					</div>
				</div>
				
			<div class="control-group">
            <label class="control-label">Approved</label>
            <div class="controls">
              <select name="Approved" style="width:100px">
               <option <cfif parameterexists(id) and getinfo.Approved eq 'No'>selected="selected"</cfif>>No</option>
               <option <cfif parameterexists(id) and getinfo.Approved eq 'Yes'>selected="selected"</cfif>>Yes</option>
              </select>
            </div>
          </div>
		  
		  <cfif parameterexists(id)>
		  
		  <div class="control-group">
            <label class="control-label">Notify who asked?</label>
            <div class="controls">
              <select name="Notify" style="width:100px">
               <option>No</option>
               <option>Yes</option>
              </select>
            </div>
          </div>
		 
		 </cfif>
				
				
				<div class="form-actions">
					<input type="submit" value="Submit" class="btn btn-primary">
          <cfif parameterexists(id)><input type="hidden" name="id" value="#url.id#"></cfif><br>
				</div>
      </form>
    
    </div>
  </div>
  
</cfoutput>

<cfinclude template="/admin/components/footer.cfm">