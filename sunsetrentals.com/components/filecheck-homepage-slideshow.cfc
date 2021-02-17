<cfcomponent displayname="fileCheck">
  <cffunction name="Init">
    <cfset variables.e="">
    <cfset variables.temp_photos_path="e:\inetpub\wwwroot\domains\#cgi.http_host#\temp_files">
    <cfif not DirectoryExists(temp_photos_path)> <cfdirectory action="create" directory="#temp_photos_path#"> </cfif>
    <cfreturn this>
  </cffunction>

  <cffunction name="Check">
    <cfargument name="filedestination">
    <cfargument name="picFieldName">

    <cfset fileDest=arguments.filedestination>
    <cfset FileField = arguments.picFieldName>
    <cffile action="upload" filefield="#FileField#" nameconflict="makeunique" destination="#temp_photos_path#">
    <cfset source_file = cffile.serverfile>

    <cfif cffile.filesize gt "307200">
      <cfset variables.e = variables.e & "<li>File size must be less than 300 kb; please reduce the file size and try again.">
    </cfif>

    <cfif variables.e is "">
      <cfif listFindNoCase("jpg,gif,png",cffile.serverfileext) is false>
        <cfset variables.e = variables.e & "<li>Invalid File Type - please upload a .jpg, .gif or .png file.">
      </cfif>
    </cfif>

    <cfset imgDest = #fileDest# & '\' & #source_file#>
    <cfif #FileExists(imgDest)# AND variables.e is ''>
      <cfset myRand = #CreateUUID()#>
      <cfset newFileName = #myRand#&#source_file#>
      <cffile action="rename" source="#variables.temp_photos_path#/#source_file#" destination="#variables.temp_photos_path#/#newFileName#">
      <cffile action="move" source="#variables.temp_photos_path#/#newFileName#" destination="#fileDest#">
      <cfset cffile.serverfile = #newFileName#>
      <cfreturn variables.e >
    </cfif>

    <cfif variables.e is "">
        <cftry>
            <cfset sourceFileWithPath = "#variables.temp_photos_path#/#source_file#">
            <CF_GraphicsMagick action="Commands" commands="convert -auto-orient -strip  #sourceFileWithPath# #sourceFileWithPath#">
        <cfcatch>
            <cfdump var="#cfcatch#">
        </cfcatch>
        </cftry>
          <cffile action="move" source="#variables.temp_photos_path#/#source_file#" destination="#fileDest#">
    <cfelse>
      <cffile action="delete" file="#variables.temp_photos_path#/#source_file#">
    </cfif>

    <cfreturn variables.e >
  </cffunction>
</cfcomponent>
