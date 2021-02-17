<cfset table = 'cms_property_enhancements'>
<cfparam name="form.showOnwedding" default="0">
<cfif isdefined('form.id')> <!--- update statement --->

				
	<cfquery dataSource="#application.dsn#" result="updateQry">
		update #table# 
		set
		virtualTour = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.virtualTour#">,
			videoLink = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.videolink#">,
			
			seotitle = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.seotitle#">,
			metadescription = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.metadescription#">,
			h1 = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.h1#">,
			longdescription = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.longdescription#">,
			
			gatecode = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.gatecode#">,
			bedtypes = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.bedtypes#">,
			notfoundurl = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.notfoundurl#">
		
		where strpropid = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#url.id#">
		
	</cfquery>



	<cfif updateQry.recordcount eq 0>
		<cfquery dataSource="#application.dsn#">
			Insert Into #table# (virtualTour,videoLink,seotitle,metadescription,h1,longdescription,gatecode,bedtypes,notfoundurl,strpropid) 
			Values(
				<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.virtualTour#">,
				<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.videolink#">,
				<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.seotitle#">,
				<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.metadescription#">,
				<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.h1#">,
				<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.longdescription#">,
				<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.gatecode#">,
				<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.bedtypes#">,
				<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.notfoundurl#">,
				<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#url.id#">
			)
		</cfquery>
	</cfif>


	<cflocation addToken="no" url="form.cfm?id=#url.id#&name=#form.pagename#&success">

</cfif>

































