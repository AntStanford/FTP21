<!---START: REMIND ME TO BOOK LATER--->
<cfif isdefined('url.reminderset') and isdefined('url.ReminderHours')>
  <div class="alert alert-success" role="alert">
    <strong>Success</strong>.  You will receive a reminder via email in approximately <cfoutput>#ReminderHours#</cfoutput> hour<cfif ReminderHours gt 1>s</cfif>.
  </div>
<cfelse>
  <a href="javascript:;" class="btn btn-block site-color-3-bg site-color-2-bg-hover text-white btn-remind" data-toggle="modal" data-target="#remindBookLater"><!--- Remind me to book this later --->On your mobile device? Too busy to book now?</a>
</cfif>
<cf_htmlfoot>
<style>
.btn-remind { white-space: normal; }
</style>
<div id="remindBookLater" class="modal fade" role="dialog">
  <div class="modal-dialog">
    <div class="modal-content">
      <form id="reminderForm" action="_submit.cfm" method="post">
        <div class="modal-header">
          <button type="button" class="close" data-dismiss="modal" style="color:#000!important;">&times;</button>
          <h4 class="modal-title">On your mobile device?  Too busy to book now?</h4>
        </div>
        <div class="modal-body">
          <p>Set your reminder time below and provide us your email and we will send you a notice to return and book this property.</p>
          <cfinclude template="/cfformprotect/cffp.cfm">
          <div class="row">
            <div class="col-md-6">
              <p><b>Remind me to book in</b></p>
              <select name="ReminderHours" class="form-control" required>
                <option value="" select="selected">Select Hours</option>
                <cfloop index="i" from="1" to="24" step="1">
                  <cfoutput><option value="#i#">#i# hour<cfif i gt 1>s</cfif></option></cfoutput>
                </cfloop>
              </select>
            </div>
            <div class="col-md-6">
              <p><b>My email address is</b></p>
              <input class="form-control" type="email" name="ReminderEmail" placeholder="Enter email address" required>
            </div>
          </div>
          <cfoutput>
            <cfif isdefined('url.propertyid')>
              <input type="hidden" name="ReminderURL" value="<cfif https is 'off'>http<cfelse>https</cfif>://#http_host##http_url#&reminderset=success">
              <input type="hidden" name="propertyId" value="#url.propertyid#">
              <input type="hidden" name="BookingValue" id="BookingValue" value="1000.52">
              <input type="hidden" name="propertyName" value="#property.name#">
              <input type="hidden" name="strCheckin" value="#url.strCheckin#">
              <input type="hidden" name="strCheckout" value="#url.strCheckout#">
              <input type="hidden" name="CameFrom" value="CheckOut">
            <cfelse>
              <input type="hidden" name="ReminderURL" value="<cfif https is 'off'>http<cfelse>https</cfif>://#http_host##script_name#?#query_string#&reminderset=success">
              <input type="hidden" name="CameFrom" value="PDP">
              <input type="hidden" name="propertyName" value="#property.name#">
              <input type="hidden" name="propertyId" value="#property.propertyid#">
            </cfif>
          </cfoutput>
        </div>
        <div class="modal-footer">
          <input class="btn btn-info" type="submit" value="Set My Reminder" name="ReturnAndBookReminder">
        </div>
      </form>
    </div>
  </div>
</div>
</cf_htmlfoot>