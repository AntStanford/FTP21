<cfcache key="cms_eventcal" action="cache" timespan="#settings.globalTimeSpan#" usequerystring="true" useCache="true" directory="e:/inetpub/wwwroot/domains/#tinymce_domain#/temp_files">

<cfquery name="getinfo" dataSource="#settings.dsn#">
  SELECT * FROM cms_eventcal 
  WHERE DATE(end_date) >= DATE(NOW())
  ORDER BY start_date
</cfquery>

<div class="cms-events-option-1">
  <ul>
    <cfoutput query="getinfo">
      <li>
        <div class="media">
          <div class="media-left">
            <cfset cleanTitle = replace(event_title,' ','-','all')>
            <cfset cleanTitle = replace(cleanTitle,":","","all")/>
            <cfset cleanTitle = replace(cleanTitle,"(","","all")/>
            <cfset cleanTitle = replace(cleanTitle,")","","all")/>
            <cfset cleanTitle = replace(cleanTitle,"'","","all")/>
            <cfset cleanTitle = replace(cleanTitle,"&","","all")/>
            <cfset cleanTitle = replace(cleanTitle,".","","all")/>
            <a href="/event/#cleanTitle#/#id#" class="media-img-link <cfif isDefined("getinfo.photo") and getinfo.photo eq "">no-photo</cfif>">
              <cfif isDefined("getinfo.photo") and getinfo.photo neq "">
                <div class="event-img-wrap"><div style="background:url('/images/events/#photo#') no-repeat;"></div></div>
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
          </div>
          <div class="media-body">
            <h2 class="media-heading"><a href="/event/#cleanTitle#/#id#" class="site-color-1 site-color-1-lighten-hover">#event_title#</a></h2>
            <p class="lead event-info">
              <cfif event_location is not ''>
                #event_location# <cfif time_start is not '' OR time_end is not ''>| </cfif>
              </cfif>
              <cfif time_start is not ''>
                Starts: #time_start# <cfif time_end is not ''>| </cfif>
              </cfif>
              <cfif time_end is not ''>
                Ends: #time_end#
              </cfif>
            </p>
            <cfif len(details_long) gt 250>
              #left(details_long,250)#...
            <cfelse>
              #details_long#
            </cfif>
          </div>
        </div>
      </li>
    </cfoutput>
  </ul>
</div>
</cfcache>