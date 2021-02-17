<cfquery name="getinfo" dataSource="#settings.dsn#">
    SELECT * FROM cms_reunions_retreats_locations ORDER BY name
</cfquery>

<cfif getinfo.recordcount gt 0>
	<!---<div class="panel-group" id="accordion" role="tablist" aria-multiselectable="true">--->
    <cfoutput query="getinfo">
        <div class="panel panel-info">
            <div class="panel-heading">
                <h4 class="panel-title text-center"><b><a href="/partials/area-results.cfm?area=#slug#">#name#</a></b></h4>
            </div>
            <div class="panel-body">
            	<div class="row">
                    <cfquery name="getProperties" dataSource="#settings.dsn#">
                        SELECT name,maxoccupancy,seoPropertyName,id
                        FROM track_properties
                        WHERE id IN(SELECT propertyID FROM cms_reunions_retreats WHERE AreaID = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#getinfo.id#">)
                        ORDER BY name
                    </cfquery>
                    <cfloop query="getProperties">
                    	<div class="col-lg-6 col-md-4 col-sm-12">
                            <div class="row">
                                <div class="col-sm-6 col-xs-6"><b><a href="/vacation-rentals/#seoPropertyName#" target="_blank">#getProperties.name#</a></b></div>
                                <div class="col-sm-6 col-xs-6"><i>SLEEPS</i> : #getProperties.maxoccupancy#</div>
                            </div>
                        </div>
    	            </cfloop>
				</div>
            </div>
        </div>
    </cfoutput>
    <!---</div>--->
</cfif>
