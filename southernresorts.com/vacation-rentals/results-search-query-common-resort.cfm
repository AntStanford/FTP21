<cfoutput>
		
	<cfif isdefined('session.booking.resort.town') and session.booking.resort.town neq ''>
		<!---
		<cfif session.booking.resort.town EQ '30A'>
			and track_properties.locality IN ('Seagrove Beach','Seagrove','Seacrest Beach','Santa Rosa Beach','Grayton Beach','Blue Mountain Beach')
		<cfelseif listFind(session.booking.resort.town,'30A')>
			and track_properties.locality IN (<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#session.booking.resort.town#,Seagrove Beach,Seagrove,Seacrest Beach,Santa Rosa Beach,Grayton Beach,Blue Mountain Beach" list="true">)
		<cfelse>
		and track_properties.locality IN (<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#session.booking.resort.town#" list="true">)
			</cfif>
		--->	
			
			
		
		AND
		((nds.typeid = 3 AND nds.name = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#session.booking.resort.town#">) 
		OR
		(nds2.typeid = 3 AND nds2.name = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#session.booking.resort.town#">) 
		OR
		(nds3.typeid = 3 AND nds3.name = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#session.booking.resort.town#">) 
		
		OR track_properties.locality IN (<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#session.booking.resort.town#" list="true">)
		)

		
		
	</cfif>
	<!---
	<cfif isdefined('session.booking.resort.neighborhoods') and session.booking.resort.neighborhoods neq '' and IsValid('integer',session.booking.resort.neighborhoods) and session.booking.resort.neighborhoods gt 0>
		and track_properties.nodeid = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#session.booking.resort.neighborhoods#">
		
  </cfif>

--->
	<cfif isdefined('session.booking.resort.specialID') and session.booking.resort.specialID neq '' and IsValid('integer',session.booking.resort.specialID) and session.booking.resort.specialID gt 0>
		<cfquery datasource="#settings.dsn#" name="getSpecialUnits">
			SELECT * FROM cms_specials_properties WHERE specialid = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#session.booking.resort.specialID#"> AND active = 'Yes'
		</cfquery>
		
			<cfif getSpecialUnits.recordcount>
		and track_properties.id IN (<cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#valuelist(getSpecialUnits.unitcode)#" list="true">)
		<cfelse>
			and track_properties.id = 0
				</cfif>
		
  </cfif>	
	<cfif isdefined('request.resortID') and request.resortID neq '' and IsValid('integer',request.resortID) and request.resortID gt 0>
		and track_properties.nodeid = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#request.resortID#">
	
  </cfif>
	
	<cfif isdefined('session.booking.resort.buildingComplex') and session.booking.resort.buildingComplex neq ''>
		and track_properties.nodeId IN (<cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#session.booking.resort.buildingComplex#" list="yes">)
	</cfif>
	
	
	<!--- Guests filter on search results --->
	<cfif isdefined('session.booking.resort.sleeps') and isvalid("integer",session.booking.resort.sleeps) and session.booking.resort.sleeps gt 0>
  		and track_properties.maxoccupancy >= <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#session.booking.resort.sleeps#">
	</cfif>

	<!--- Bedrooms filter on quick search and search results --->
	<cfif isdefined('session.booking.resort.bedrooms') and session.booking.resort.bedrooms neq ''>
	  <cfif session.booking.resort.bedrooms contains ','> <!--- refine search --->
	    <cfset theMinBed = ListFirst(session.booking.resort.bedrooms)>
	    <cfset theMaxBed = ListLast(session.booking.resort.bedrooms)>
	    and track_properties.bedrooms between <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#theMinBed#"> and <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#theMaxBed#">
	  <cfelseif session.booking.resort.bedrooms gt 0> <!--- quick search --->
	    <cfset theMinBed = session.booking.resort.bedrooms>
	    <cfset theMaxBed = settings.booking.maxBed>
	    and track_properties.bedrooms between <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#theMinBed#"> and <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#theMaxBed#">
	 <!--- 
	 <cfelseif session.booking.resort.bedrooms eq 0>
	  	and track_properties.bedrooms = 0
--->
	  </cfif>
	</cfif>
			
	<cfif isdefined('session.booking.resort.dest') and Len(session.booking.resort.dest)>
		and 
		(
		1 = 0
		<cfloop list="#session.booking.resort.dest#" index="d">OR
		(nds.parentid IN  (select id from track_nodes where parentid = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#d#">)
		OR nds.parentid = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#d#">
		
		
		)
			</cfloop>
		)
	</cfif>

	<!--- Must Have - quick search --->
	<cfif isdefined('session.booking.resort.must_haves') and ListLen(session.booking.resort.must_haves)>

		<cfif ListFind(session.booking.resort.must_haves,'Pet Short Walk to Ski Lifts')>
			and track_properties.id IN (select distinct propertyid from track_properties_amenities where amenityId = 106)
		</cfif>

		<cfif ListFind(session.booking.resort.must_haves,'Mountain View')>
			and track_properties.id IN (select distinct propertyid from track_properties_amenities where amenityId = 87)
		</cfif>
		
		<cfif ListFind(session.booking.resort.must_haves,'Hot Tub - Private')>
			and track_properties.id IN (select distinct propertyid from track_properties_amenities where amenityId = 31)
		</cfif>
		
		<cfif ListFind(session.booking.resort.must_haves,'Hot Tub - Shared')>
			and track_properties.id IN (select distinct propertyid from track_properties_amenities where amenityId = 32)
		</cfif>
		
		<cfif ListFind(session.booking.resort.must_haves,'King Bed')>
			and track_properties.id IN (select distinct propertyid from track_properties_amenities where amenityId = 44)
		</cfif>
		
		<cfif ListFind(session.booking.resort.must_haves,'Indoor Pool (Onsite Access)')>
			and track_properties.id IN (select distinct propertyid from track_properties_amenities where amenityId = 35)
		</cfif>
		
		<cfif ListFind(session.booking.resort.must_haves,'Outdoor Pool (Onsite Access)')>
			and track_properties.id IN (select distinct propertyid from track_properties_amenities where amenityId = 37)
		</cfif>
		
		<cfif ListFind(session.booking.resort.must_haves,'Pet Friendly')>
			and track_properties.petsFriendly = 'Yes'
		</cfif>

	</cfif>
	<!--- More Filters->View filter on search results --->
	<cfif isdefined('session.booking.resort.area') and ListLen(session.booking.resort.area)>
		and track_properties.id IN (
			select propertyid from cms_reunions_retreats where areaid in (
				Select id from cms_reunions_retreats_locations where name in (<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#session.booking.resort.area#" list="Yes">)
				)
			)
	</cfif>
	<!--- Amenities - Refine Search --->
	<cfif isdefined('session.booking.resort.amenities') and ListLen(session.booking.resort.amenities)>
		
		<cfloop list="#session.booking.resort.amenities#" index="i">
			 and track_properties.id IN (select distinct propertyid from track_properties_amenities where amenityName = '<cfoutput>#i#</cfoutput>')			
		</cfloop>
		
		<!---
		and track_properties.id IN (select distinct propertyid from track_properties_amenities where
		<cfset tempcounter = 1>
		<cfloop list="#session.booking.resort.amenities#" index="i">
			 amenityName = '<cfoutput>#i#</cfoutput>'<cfif tempcounter lt listlen(session.booking.resort.amenities)> AND</cfif>
			 <cfset tempcounter += 1>
		</cfloop>
		)
--->

	</cfif>

	<!--- More Filters->Unit Type filter on search results --->
	<cfif isdefined('session.booking.resort.type') and ListLen(session.booking.resort.type)>
		and track_properties.lodgingTypeName IN (<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#session.booking.resort.type#" list="Yes">)
	</cfif>


	<cfif isdefined('session.booking.resort.location') and ListLen(session.booking.resort.location)>
		and track_properties.locality = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#session.booking.resort.location#" list="Yes">
	</cfif>

	<!--- More Filters->View filter on search results 
	<cfif isdefined('session.booking.resort.view') and ListLen(session.booking.resort.view)>
		and escapia_properties.unitcode IN
			(
			select distinct unitcode from escapia_amenities where category = 'LOCATION_TYPE' and categoryvalue IN (<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#session.booking.resort.view#" list="Yes">)
			)
	</cfif>--->
	<cfif isDefined("session.booking.resort.weddingproperties") AND session.booking.resort.weddingproperties eq 1>
		 AND cpe.showOnWedding = 1
	</cfif>
</cfoutput>