<cfoutput>
	<!--- we are using town to hold locations  --->
	<cfif isdefined('session.booking.town') and session.booking.town neq ''>
		AND nodeID IN (SELECT id
						FROM track_nodes
					   WHERE parentId IN (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#session.booking.town#">) 
					      OR id IN (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#session.booking.town#">)
                          <!---AND `typeName` = 'Area'--->
					 	)
	</cfif>

	<cfif isdefined('session.booking.location') and len( session.booking.location ) gt 0>
		and track_properties.id in(
			select tp.id
			from track_nodes tn
			join track_properties tp on tp.nodeId = tn.id
			where tn.name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.booking.location#" />
		)
	</cfif>

	<cfif isdefined('session.booking.neighborhoods') and session.booking.neighborhoods neq '' and IsValid('integer',session.booking.neighborhoods) and session.booking.neighborhoods gt 0>
		and track_properties.id IN (
			select prp.id
			from track_properties prp
			inner join track_nodes nds on prp.nodeid = nds.id 
			where nds.id = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.booking.neighborhoods#"> 
			or nds.parentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.booking.neighborhoods#">
		)
  	</cfif>
	
	<cfif isdefined('session.booking.complex') and session.booking.complex neq ''>
		and track_properties.nodeId IN (<cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#session.booking.complex#" list="yes">)
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
	    <cfset theMaxBed = session.booking.bedrooms>
	    and track_properties.bedrooms between <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#theMinBed#"> and <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#theMaxBed#">
	  <cfelseif session.booking.bedrooms eq 0>
	  	<!--- and track_properties.bedrooms = 0 --->
	  </cfif>
	</cfif>

	<!--- Must Have - quick search --->
	<cfif isdefined('session.booking.must_haves') and ListLen(session.booking.must_haves)>
		
		AND nodeID IN (SELECT id
						FROM track_nodes
					   WHERE parentId IN (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#session.booking.must_haves#">) 
					      OR id IN (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#session.booking.must_haves#">)
					 	)
						


		<!--- <cfif ListFind(session.booking.must_haves,'Pet Short Walk to Ski Lifts')>
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
		
		<cfif ListFind(session.booking.must_haves,'Pool')>
			and track_properties.id IN (select distinct propertyid from track_properties_amenities where amenityName rlike 'pool' and amenityGroupName = 'Pool & Spa')
			<!---and track_properties.id IN (select distinct propertyid from track_properties_amenities where amenityName like '%pool%' and amenityName != 'Pool Table')--->
		</cfif>
				
		<cfif ListFind(session.booking.must_haves,'Pet Friendly')>
			and track_properties.petsFriendly = 'Yes'
		</cfif> --->

	</cfif>

	<!--- Amenities - Refine Search --->
	<cfif isdefined('session.booking.amenities') and ListLen(session.booking.amenities)>

		<cfloop list="#session.booking.amenities#" index="i">
			 and track_properties.id IN (select distinct propertyid from track_properties_amenities where amenityName = '<cfoutput>#i#</cfoutput>')			
		</cfloop>

	</cfif>

	<!--- More Filters->Unit Type filter on search results --->
	<cfif isdefined('session.booking.type') and ListLen(session.booking.type)>
		and track_properties.lodgingTypeName IN (<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#session.booking.type#" list="Yes">)
	</cfif>

	<!--- More Filters->View filter on search results 
	<cfif isdefined('session.booking.view') and ListLen(session.booking.view)>
		and escapia_properties.unitcode IN
			(
			select distinct unitcode from escapia_amenities where category = 'LOCATION_TYPE' and categoryvalue IN (<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#session.booking.view#" list="Yes">)
			)
	</cfif>--->

	<!--- Specials search results page --->
	<cfif isdefined('session.booking.specialid') and session.booking.specialid gt 0>

		<cfquery name="getProperties" dataSource="#settings.dsn#">
			select unitcode from cms_specials_properties where specialID = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#session.booking.specialid#">
			and active = 'yes'
		</cfquery>

		<cfif getProperties.recordcount gt 0>
			and track_properties.id IN (<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#ValueList(getProperties.unitcode)#" list="Yes">)
		<cfelse>
    	AND 1 = 0
    </cfif>

	</cfif>

</cfoutput>