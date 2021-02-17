  
   
 <!---   <cfquery dataSource="#settings.dsn#" name="GetSurveys">
     select * from surveysimported
   </cfquery>
   
   
   <cfloop query="GetSurveys">
   
    <cfquery dataSource="#settings.dsn#" name="GetTrackProperty">
     select * from track_properties where name = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#property#">
   </cfquery>
   
   <cfoutput>
	   #Property# = #GetTrackProperty.name# <cfif Property is "#GetTrackProperty.name#">YES<cfelse>NO</cfif><br>
   </cfoutput>
   
   <cfquery dataSource="#settings.dsn#">
    update surveysimported set
    MatchedInTrack = <cfif #Property# is "#GetTrackProperty.name#">'YES'<cfelse>'NO'</cfif>
    where SurveyID = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#SurveyID#">
  </cfquery>
   
   </cfloop> --->