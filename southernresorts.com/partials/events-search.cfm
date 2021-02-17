<cfquery name="geteventsdates" datasource="#settings.dsn#">
  select id,start_date,end_date
  from cms_eventcal
  where end_date >= now()
  group by start_date
  order by start_date asc
</cfquery>

<div class="alert events-header site-color-2-bg text-white">
  <div class="events-heading"><strong>Events You Don't Want To Miss</strong></div>

  <div class="events-header-btns">
    <a href="/event-calendar/index.cfm" class="btn site-color-3-bg site-color-1-bg-hover text-white"><i class="fa fa-calendar-o"></i> Calendar</a>
  </div>
</div><!-- END events-header -->

<div class="events-content">
  <div class="row">
    <div class="col-xs-12 col-sm-12 col-md-3">
      <div class="events-sidebar">
        <h4>Narrow Your Search</h4>
        <form id="dateform" class="events-form">
          <strong>Search by Date</strong>
          <div class="form-group">
            <label for="eventStartDate" class="hidden">Start Date</label>
            <div class="events-input-wrap">
              <input type="text" id="eventStartDate" name="startDate" class="form-control datepicker" placeholder="Start Date" readonly value="">
              <i class="fa fa-calendar"></i>
            </div>
          </div>
          <div class="form-group">
            <label for="eventEndDate" class="hidden">End Date</label>
            <div class="events-input-wrap">
              <input type="text" id="eventEndDate" name="endDate" class="form-control datepicker" placeholder="End Date" readonly value="">
              <i class="fa fa-calendar"></i>
            </div>
          </div>
        </form>
      </div>
    </div>

    <div class="col-xs-12 col-sm-12 col-md-9">
      <div class="events-list" id="APIresponse">
        <cfoutput query="geteventsdates">
          <cfquery name="getevents" datasource="#settings.dsn#">
            select *
            from cms_eventcal
            where start_date = <cfqueryparam cfsqltype="cf_sql_date" value="#start_date#" />
          </cfquery>

          <cfloop query="getevents">
            <cfset cleanTitle = replace(event_title,' ','-','all')>
            <cfset cleanTitle = replace(cleanTitle,":","","all")/>
            <cfset cleanTitle = replace(cleanTitle,"(","","all")/>
            <cfset cleanTitle = replace(cleanTitle,")","","all")/>
            <cfset cleanTitle = replace(cleanTitle,"'","","all")/>
            <cfset cleanTitle = replace(cleanTitle,"&","","all")/>
            <cfset cleanTitle = replace(cleanTitle,".","","all")/>
            <div class="media">
              <cfset link = cleanTitle />

              <div class="media-left">
                <!--- #getevents.externallink# --->
                <a href="/event/#lcase( link )#/#id#" class="media-img-link <cfif isDefined("getevents.photo") and getevents.photo eq "">no-photo</cfif>" >
                  <cfif len(getevents.photo)>
                    <div class="event-img-wrap"><div class="lazy" data-src="/images/events/#getevents.photo#"></div></div>
                  </cfif>
                  <span class="date">
                    <span class="date-wrap">
                      <span class="start-date">
                        #DateFormat(start_date,"mmm")#
                        <em>#DateFormat(start_date,"dd")#</em>
                      </span>
                      <cfif len(end_date) and end_date is not start_date>
                        <span class="end-date"><b>-</b>
                          #DateFormat(end_date,"mmm")#
                          <em>#DateFormat(end_date,"dd")#</em>
                        </span>
                      </cfif>
                    </span>
                  </span>
                </a>
              </div><!-- media-left -->

              <div class="media-body">
                <h2 class="media-heading">
                  <cfif isdefined('getevents.externallink') and len(getevents.externallink) gt 0 and 1 eq 0>
                    <a href="#getevents.externallink#" class="site-color-3 site-color-2-hover">#getevents.event_title#</a>
                  <cfelse>
                    <a href="/event/#lcase( link )#/#id#" class="site-color-3 site-color-2-hover">#getevents.event_title#</a>
                  </cfif>
                </h2>

                <p class="lead event-info">
                  <cfif getevents.time_start is not ''>
                    Starts: #getevents.time_start# <cfif getevents.time_end is not ''>| </cfif>
                  </cfif>
                  <cfif time_end is not ''>
                    Ends: #getevents.time_end#
                  </cfif>
                </p>
                #getevents.details_long#
              </div><!-- END media-body -->

            </div><!-- END media -->
          </cfloop>
        </cfoutput>
      </div><!-- END events-list -->
    </div>

  </div>
</div><!-- END events-content -->

<cf_htmlfoot>
<script type="text/javascript">
$(document).ready(function(){
  var bookingFolder = '/vacation-rentals';
  // EVENTS DATEPICKER
  if ($('#eventStartDate').length) {
    // DISABLE END DATE - PREVENT USER FROM SELECTING THIS BEFORE THE START DATE
    $('#eventEndDate').attr('disabled', 'disable');
    $('#eventStartDate').datepicker({
      minDate: '0d',
      onSelect: function( selectedDate ) {
        // MAKE THE END DATE SELECTABLE
        $('#eventEndDate').removeAttr('disabled');
        setTimeout(function(){
          $('#eventEndDate').datepicker('show');
        }, 16);
      }
    });
    $('#eventEndDate').datepicker({
      minDate: '0d',
      onSelect: function(selectedDate){
        $.ajax({
          type: "POST",
          url: bookingFolder+'/ajax/get-events.cfm',
          data: $('#dateform').serialize(),
          success: function(data) {
            var response = $.trim(data);
            $('#APIresponse').html(data).show();
          }
        });
      }
    });
  }
});
</script>
</cf_htmlfoot>