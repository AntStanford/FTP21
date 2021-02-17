<cfoutput>
		
	<cfif isdefined('session.booking.town') and session.booking.town neq ''>
		<!---
		<cfif session.booking.town EQ '30A'>
			and track_properties.locality IN ('Seagrove Beach','Seagrove','Seacrest Beach','Santa Rosa Beach','Grayton Beach','Blue Mountain Beach')
		<cfelseif listFind(session.booking.town,'30A')>
			and track_properties.locality IN (<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#session.booking.town#,Seagrove Beach,Seagrove,Seacrest Beach,Santa Rosa Beach,Grayton Beach,Blue Mountain Beach" list="true">)
		<cfelse>
		and track_properties.locality IN (<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#session.booking.town#" list="true">)
			</cfif>
		--->	
			
			
		
		AND
		((nds.typeid = 3 AND nds.name = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#session.booking.town#">) 
		OR
		(nds2.typeid = 3 AND nds2.name = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#session.booking.town#">) 
		OR
		(nds3.typeid = 3 AND nds3.name = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#session.booking.town#">) 
		
		OR track_properties.locality IN (<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#session.booking.town#" list="true">)
		)

		
		
	</cfif>
	<!---
	<cfif isdefined('session.booking.neighborhoods') and session.booking.neighborhoods neq '' and IsValid('integer',session.booking.neighborhoods) and session.booking.neighborhoods gt 0>
		and track_properties.nodeid = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#session.booking.neighborhoods#">
		
  </cfif>

--->
	<cfif isdefined('session.booking.specialID') and session.booking.specialID neq '' and IsValid('integer',session.booking.specialID) and session.booking.specialID gt 0>
		<cfquery datasource="#settings.dsn#" name="getSpecialUnits">
			SELECT * FROM cms_specials_properties WHERE specialid = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#session.booking.specialID#"> AND active = 'Yes'
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

		<cfif isDefined('resortfilterList') and listLen(resortfilterList)>
			and track_properties.nodeId in (<cfqueryparam value="#resortfilterList#" list="true" cfsqltype="cf_sql_integer">) 
		</cfif>
		
		<cfif isdefined('session.booking.buildingComplex') and session.booking.buildingComplex neq ''>
			and track_properties.nodeId IN (<cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#session.booking.buildingComplex#" list="yes">)
		</cfif>
	
	<!--- Guests filter on search results --->
	<cfif isdefined('session.booking.sleeps') and isvalid("integer",session.booking.sleeps) and session.booking.sleeps gt 0>
  		and track_properties.maxoccupancy >= <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#session.booking.sleeps#">
	</cfif>

	<!--- Bedrooms filter on quick search and search results --->
	<cfif isdefined('session.booking.bedrooms') and session.booking.bedrooms neq ''>
	  <cfif session.booking.bedrooms contains ','> <!--- refine search --->
	    <cfset theMinBed = ListFirst(session.booking.bedrooms)>
	    <cfset theMaxBed = ListLast(session.booking.bedrooms)>
	    and track_properties.bedrooms between <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#theMinBed#"> and <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#theMaxBed#">
	  <cfelseif session.booking.bedrooms gt 0> <!--- quick search --->
	    <cfset theMinBed = session.booking.bedrooms>
	    <cfset theMaxBed = settings.booking.maxBed>
	    and track_properties.bedrooms between <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#theMinBed#"> and <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#theMaxBed#">
	 <!--- 
	 <cfelseif session.booking.bedrooms eq 0>
	  	and track_properties.bedrooms = 0
--->
	  </cfif>
	</cfif>
			
	<cfif isdefined('session.booking.dest') and Len(session.booking.dest)>
		and 
		(
		  1 = 0
			<cfloop list="#session.booking.dest#" index="d">
				OR
				(
					nds.parentid IN  (select id from track_nodes where parentid = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#d#">)
					OR 
					nds.parentid = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#d#">
					<!---added 4.8.20 MCrouch --->
					OR 
					track_properties.nodeID = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#d#">
					<!---added 4.27.20 MCrouch --->
					OR 
					nds2.id = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#d#">
					OR 
					nds3.id = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#d#">
				)
			</cfloop>
		)
	</cfif>

	<!--- Must Have - quick search --->
	<cfif isdefined('session.booking.must_haves') and ListLen(session.booking.must_haves)>

		<cfif ListFind(session.booking.must_haves,'Pet Short Walk to Ski Lifts')>
			and track_properties.id IN (select distinct propertyid from track_properties_amenities where amenityId = 106)
		</cfif>

		<cfif ListFind(session.booking.must_haves,'Mountain View')>
			and track_properties.id IN (select distinct propertyid from track_properties_amenities where amenityId = 87)
		</cfif>
		
		<cfif ListFind(session.booking.must_haves,'Hot Tub - Private')>
			and track_properties.id IN (select distinct propertyid from track_properties_amenities where amenityId = 31)
		</cfif>
		
		<cfif ListFind(session.booking.must_haves,'Hot Tub - Shared')>
			and track_properties.id IN (select distinct propertyid from track_properties_amenities where amenityId = 32)
		</cfif>
		
		<cfif ListFind(session.booking.must_haves,'King Bed')>
			and track_properties.id IN (select distinct propertyid from track_properties_amenities where amenityId = 44)
		</cfif>
		
		<cfif ListFind(session.booking.must_haves,'Indoor Pool (Onsite Access)')>
			and track_properties.id IN (select distinct propertyid from track_properties_amenities where amenityId = 35)
		</cfif>
		
		<cfif ListFind(session.booking.must_haves,'Outdoor Pool (Onsite Access)')>
			and track_properties.id IN (select distinct propertyid from track_properties_amenities where amenityId = 37)
		</cfif>
		
		<cfif ListFind(session.booking.must_haves,'Pet Friendly')>
			and track_properties.petsFriendly = 'Yes'
		</cfif>

	</cfif>
	<!--- More Filters->View filter on search results --->
	<cfif isdefined('session.booking.area') and ListLen(session.booking.area)>
		and track_properties.id IN (
			select propertyid from cms_reunions_retreats where areaid in (
				Select id from cms_reunions_retreats_locations where name in (<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#session.booking.area#" list="Yes">)
				)
			)
	</cfif>
	<!--- Amenities - Refine Search --->
	<cfif isdefined('session.booking.amenities') and ListLen(session.booking.amenities)>
		
		<cfloop list="#session.booking.amenities#" index="i">
			 and track_properties.id IN (select distinct propertyid from track_properties_amenities where amenityName = '<cfoutput>#i#</cfoutput>')			
		</cfloop>
		
		<!---
		and track_properties.id IN (select distinct propertyid from track_properties_amenities where
		<cfset tempcounter = 1>
		<cfloop list="#session.booking.amenities#" index="i">
			 amenityName = '<cfoutput>#i#</cfoutput>'<cfif tempcounter lt listlen(session.booking.amenities)> AND</cfif>
			 <cfset tempcounter += 1>
		</cfloop>
		)
--->

	</cfif>

	<cfif isdefined('session.booking.PROPERTYIDS') and ListLen(session.booking.PROPERTYIDS)>
		and track_properties.id IN (<cfqueryparam list="true" value="#session.booking.PROPERTYIDS#" cfsqltype="cf_sql_integer">)			
	</cfif>

	<!--- More Filters->Unit Type filter on search results --->
	<cfif isdefined('session.booking.type') and ListLen(session.booking.type)>
		and track_properties.lodgingTypeName IN (<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#session.booking.type#" list="Yes">)
	</cfif>


	<cfif isdefined('session.booking.location') and ListLen(session.booking.location)>
		and track_properties.locality = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#session.booking.location#" list="Yes">
	</cfif>

	<!--- More Filters->View filter on search results 
	<cfif isdefined('session.booking.view') and ListLen(session.booking.view)>
		and escapia_properties.unitcode IN
			(
			select distinct unitcode from escapia_amenities where category = 'LOCATION_TYPE' and categoryvalue IN (<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#session.booking.view#" list="Yes">)
			)
	</cfif>--->
	<cfif isDefined("session.booking.weddingproperties") AND session.booking.weddingproperties eq 1>
		 AND cpe.showOnWedding = 1
	</cfif>
</cfoutput>