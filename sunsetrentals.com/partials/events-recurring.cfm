<cfset showMonths = "11"> <!--- number of months to show after current month --->
<cfset current_date = now()>
<cfset current_days = DaysInMonth(current_date)>
<cfset current_firstDay = CreateDate(year(current_date), month(current_date), '01')>
<cfset current_lastDay = CreateDate(year(current_date), month(current_date), current_days)>

<cfoutput>
  <div class="month-tabs">
    <cfloop from="0" to="0" index="i">
      <cfset future_date = DateAdd("m", i, now())>
      <p class="lead">#dateformat(future_date, 'yyyy')#</p>
    </cfloop>
    <ul class="nav nav-tabs">
      <cfloop from="0" to="#showMonths#" index="i">
        <cfset future_date = DateAdd("m", i, now())>
        <li class="nav-item"><a class="nav-link" id="tab_#i#" data-month="#dateformat(future_date, 'mm')#" data-year="#dateformat(future_date, 'yyyy')#">#dateformat(future_date, 'mmmm')#</a></li>
      </cfloop>
    </ul>
  </div>
  <!--- Layout for display of events in /components/event-results.cfm --->
  <div id="showEvents"></div>
</cfoutput>

<cf_htmlfoot>
<script type="text/javascript">
$(document).ready(function() {
  var postMonth = $('#tab_0').attr("data-month")
  var postYear = $('#tab_0').attr("data-year")
  var postData = postMonth + '/01/' + postYear
  $.ajax({
    url : "/partials/event-results.cfm",
    type: "Get",
    data : postData,
    success: function(data){
      $("#showEvents").html(data)
    },
    error: function(errorThrown){
      //if fails
    }
  });
  $('.month-tabs ul li:first').addClass('active');
  $('[id^=tab_]').click(function(e){
    var postMonth = $(this).attr("data-month")
    var postYear = $(this).attr("data-year")
    var postData = postMonth + '/01/' + postYear
    $('.month-tabs ul li').removeClass('active');
    $(this).parent().addClass('active');
    $.ajax({
      url : "/partials/event-results.cfm",
      type: "Get",
      data : postData,
      success: function(data){
        $("#showEvents").html(data)
      },
      error: function(errorThrown){
        //if fails
      }
    });
  });
});
</script>
</cf_htmlfoot>