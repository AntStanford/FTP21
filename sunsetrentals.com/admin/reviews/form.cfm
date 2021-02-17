<cfset page.title ="View Property Review">
<cfset module = 'review'>
<cfinclude template="/admin/components/header.cfm">

<cfif settings.booking.pms eq 'Homeaway'>

   <cfquery name="getProperties" dataSource="#settings.booking.dsn#">
      select strpropid,strname from pp_propertyinfo order by strname
   </cfquery>

<cfelseif settings.booking.pms eq 'Barefoot'>

   <cfquery name="getProperties" dataSource="#settings.booking.dsn#">
      select propertyid,name from bf_properties order by name
   </cfquery>

<cfelseif settings.booking.pms eq 'Escapia'>

   <cfquery name="getProperties" dataSource="#settings.booking.dsn#">
      select unitcode,unitshortname from escapia_properties order by unitshortname
   </cfquery>

<cfelseif settings.booking.pms eq 'Track'>

   <cfquery name="getProperties" dataSource="#settings.booking.dsn#">
      select id,shortName from track_properties order by shortName
   </cfquery>

</cfif>
<cfoutput>

  <p><a href="index.cfm" class="btn btn-success"><i class="icon-chevron-left icon-white"></i> Back</a></p>

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
                        <cfif settings.booking.pms eq 'Homeaway'>
                         #getProperties.strname#
                        <cfelseif settings.booking.pms eq 'Barefoot'>
                         #getProperties.name#
                        <cfelseif settings.booking.pms eq 'Escapia'>
                         <!--- #getProperties.unitshortname# --->
                         <select id="propertyid" name="propertyid" class="input-xlarge">
                          <option value="0" >-- Select --</option>
                          <cfloop query="#getProperties#">
                          <option value="#getProperties.unitcode#">#getProperties.unitshortname#</option>
                         </cfloop>
                        </select>
                        <cfelseif settings.booking.pms eq 'Track'>
                         <!--- #getProperties.unitshortname# --->
                         <select id="propertyid" name="propertyid" class="input-xlarge">
                          <option value="0" >-- Select --</option>
                          <cfloop query="#getProperties#">
                          <option value="#getProperties.id#">#getProperties.shortName#</option>
                         </cfloop>
                        </select>
                        </cfif>
                    </div>
                </div>

            <div class="control-group">
                    <label class="control-label">First Name</label>
                    <div class="controls">
                        <input maxlength="255" name="firstname" type="text">
                    </div>
                </div>

                <div class="control-group">
                    <label class="control-label">Last Name</label>
                    <div class="controls">
                        <input maxlength="255" name="lastname" type="text">
                    </div>
                </div>

                <div class="control-group">
                    <label class="control-label">Home Town</label>
                    <div class="controls">
                        <input maxlength="255" name="hometown" type="text">
                    </div>
                </div>

                <div class="control-group">
                    <label class="control-label">Email</label>
                    <div class="controls">
                        <input maxlength="255" name="email" type="text">
                    </div>
                </div>

                <div class="control-group">
                    <label class="control-label">Check-In Date</label>
                    <div class="controls">
                        <input maxlength="255" readonly="readonly" class="datepicker" name="checkInDate" type="text">
                    </div>
                </div>

                <div class="control-group">
                    <label class="control-label">Check-Out Date</label>
                    <div class="controls">
                         <input maxlength="255" readonly="readonly" class="datepicker" name="checkOutDate" type="text">
                    </div>
                </div>


           <div class="control-group">
              <label class="control-label" for="rating">Rating</label>
              <div class="controls">
                    <select id="rating" name="rating" class="input-xlarge">
                  <option value="1" >1 star</option>
                  <option value="2">2 stars</option>
                  <option value="3">3 stars</option>
                  <option value="4">4 stars</option>
                  <option value="5" selected="selected">5 stars</option>
                </select>
              </div>
            </div>

                <div class="control-group">
                    <label class="control-label">Title</label>
                    <div class="controls">
                        <input maxlength="255" name="title" type="text">
                    </div>
                </div>

            <div class="control-group">
                    <label class="control-label">Review</label>
                    <div class="controls">
                        <textarea name="review" id="txtContent" rows="4" cols="30"></textarea>
                    </div>
               </div>

             <div class="control-group">
                    <div class="controls">
                    <input type="submit" value="Submit" class="btn btn-primary">
                    </div>
               </div>

      </form>

    </div>
  </div>

</cfoutput>

<cfinclude template="/admin/components/footer.cfm">