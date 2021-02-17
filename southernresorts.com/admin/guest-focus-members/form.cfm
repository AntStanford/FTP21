<cfif isdefined('url.id')>
  <cfquery name="getinfo" dataSource="#application.dsn#">
    select * from guest_focus_users where id = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#url.id#">
  </cfquery>
</cfif>

<cfset page.title ="Guest Focus Users">
<cfset module = 'user'>
<cfinclude template="/admin/components/header.cfm">

<cfoutput>

  <cfif isdefined('url.success') and isdefined('url.id')>
    <div class="alert alert-success">
      <button class="close" data-dismiss="alert">×</button>
      <strong>Update successful!</strong> Continue editing this #module# or <a href="index.cfm">go back.</a>
    </div>
  <cfelseif isdefined('url.success')>
    <div class="alert alert-success">
      <button class="close" data-dismiss="alert">×</button>
      <strong>Insert successful!</strong> Add another #module# or <a href="index.cfm">go back.</a>
    </div>
  </cfif>
  
  <div class="widget-box">
    <div class="widget-title">
      <span class="icon">
        <i class="icon-th"></i>
      </span>
      <h5>Add / Edit Form</h5>
    </div>
    <div class="widget-content nopadding">
  
      <form action="submit.cfm" method="post" class="form-horizontal">
        <div class="control-group">
					<label class="control-label">First Name</label>
					<div class="controls">
						<input maxlength="255" name="firstname" type="text" <cfif parameterexists(id)>value="#getinfo.firstname#"</cfif>>
					</div>
				</div>
        <div class="control-group">
					<label class="control-label">Last Name</label>
					<div class="controls">
						<input maxlength="255" name="lastname" type="text" <cfif parameterexists(id)>value="#getinfo.lastname#"</cfif>>
					</div>
				</div>
        <div class="control-group">
					<label class="control-label">Email</label>
					<div class="controls">
						<input maxlength="255" name="email" type="text" <cfif parameterexists(id)>value="#getinfo.email#"</cfif>>
					</div>
				</div>
        <div class="control-group">
					<label class="control-label">Phone</label>
					<div class="controls">
						<input maxlength="255" name="phone" type="text" <cfif parameterexists(id)>value="#getinfo.phone#"</cfif>>
					</div>
				</div>
				<div class="control-group">
					<label class="control-label">Address</label>
					<div class="controls">
						<input maxlength="255" name="Address" type="text" <cfif parameterexists(id)>value="#getinfo.Address#"</cfif>>
					</div>
				</div>
				<div class="control-group">
					<label class="control-label">City</label>
					<div class="controls">
						<input maxlength="255" name="City" type="text" <cfif parameterexists(id)>value="#getinfo.City#"</cfif>>
					</div>
				</div>
				
				<div class="control-group">
					<label class="control-label">State</label>
					<div class="controls">
						<select name="state" style="width:200px;">
										<cfif parameterexists(id)><option value="#getinfo.state#">#getinfo.state#</option></cfif>
											<option value=""> - Select State - </option>
											<option value="AK">AK - ALASKA</option>
											<option value="AL">AL - ALABAMA</option>
											<option value="AR">AR - ARKANSAS</option>
											<option value="AZ">AZ - ARIZONA</option>
											<option value="CA">CA - CALIFORNIA</option>
											<option value="CO">CO - COLORADO</option>
											<option value="CT">CT - CONNECTICUT</option>
											<option value="DC">DC - DISTRICT OF COLUMBIA</option>
											<option value="DE">DE - DELAWARE</option>
											<option value="FL">FL - FLORIDA</option>
											<option value="GA">GA - GEORGIA</option>
											<option value="GU">GU - GUAM</option>
											<option value="HI">HI - HAWAII</option>
											<option value="IA">IA - IOWA</option>
											<option value="ID">ID - IDAHO</option>
											<option value="IL">IL - ILLINOIS</option>
											<option value="IN">IN - INDIANA</option>
											<option value="KS">KS - KANSAS</option>
											<option value="KY">KY - KENTUCKY</option>
											<option value="LA">LA - LOUISIANA</option>
											<option value="MA">MA - MASSACHUSETTS</option>
											<option value="MD">MD - MARYLAND</option>
											<option value="ME">ME - MAINE</option>
											<option value="MI">MI - MICHIGAN</option>
											<option value="MN">MN - MINNESOTA</option>
											<option value="MO">MO - MISSOURI</option>
											<option value="MS">MS - MISSISSIPPI</option>
											<option value="MT">MT - MONTANA</option>
											<option value="NC">NC - NORTH CAROLINA</option>
											<option value="ND">ND - NORTH DAKOTA</option>
											<option value="NE">NE - NEBRASKA</option>
											<option value="NH">NH - NEW HAMPSHIRE</option>
											<option value="NJ">NJ - NEW JERSEY</option>
											<option value="NM">NM - NEW MEXICO</option>
											<option value="NV">NV - NEVADA</option>
											<option value="NY">NY - NEW YORK</option>
											<option value="OH">OH - OHIO</option>
											<option value="OK">OK - OKLAHOMA</option>
											<option value="OR">OR - OREGON</option>
											<option value="PA">PA - PENNSYLVANIA</option>
											<option value="PR">PR - PUERTO RICO</option>
											<option value="RI">RI - RHODE ISLAND</option>
											<option value="SC">SC - SOUTH CAROLINA</option>
											<option value="SD">SD - SOUTH DAKOTA</option>
											<option value="TN">TN - TENNESSEE</option>
											<option value="TX">TX - TEXAS</option>
											<option value="UT">UT - UTAH</option>
											<option value="VA">VA - VIRGINIA</option>
											<option value="VI">VI - VIRGIN ISLANDS</option>
											<option value="VT">VT - VERMONT</option>
											<option value="WA">WA - WASHINGTON</option>
											<option value="WI">WI - WISCONSIN</option>
											<option value="WV">WV - WEST VIRGINIA</option>
											<option value="WY">WY - WYOMING</option>
										</select>
					</div>
				</div>
				
				<div class="control-group">
					<label class="control-label">Zip</label>
					<div class="controls">
						<input maxlength="255" name="Zip" type="text" <cfif parameterexists(id)>value="#getinfo.Zip#"</cfif>>
					</div>
				</div>
				
				<cfset defaultPwd = generatePassword(8)>
				
				<div class="control-group">
					<label class="control-label">Password</label>
					<div class="controls">
						<input maxlength="255" name="Password" type="password" <cfif parameterexists(id)>value="#getinfo.Password#"<cfelse>value="#defaultPwd#"</cfif>>
					</div>
				</div>

				<div class="form-actions">
				  <input type="submit" value="Submit" class="btn btn-primary">
				  <cfif parameterexists(id)><input type="hidden" name="id" value="#url.id#"></cfif>
				</div>
  		</form> 

    </div>
  </div>
  
</cfoutput>

<cfinclude template="/admin/components/footer.cfm">


<cfscript>
/**
 * Generates a password the length you specify.
 * v2 by James Moberg.
 * 
 * @param numberOfCharacters 	 Lengh for the generated password. Defaults to 8. (Optional)
 * @param characterFilter 	 Characters filtered from result. Defaults to O,o,0,i,l,1,I,5,S (Optional)
 * @return Returns a string. 
 * @author Tony Blackmon (&#102;&#108;&#117;&#105;&#100;&#64;&#115;&#99;&#46;&#114;&#114;&#46;&#99;&#111;&#109;) 
 * @version 2, February 8, 2010 
 */
function generatePassword() {
var placeCharacter = "";
var currentPlace=0;
var group=0;
var subGroup=0;
var numberofCharacters = 8;
var characterFilter = 'O,o,0,i,l,1,I,5,S';
var characterReplace = repeatString(",", listlen(characterFilter)-1);
if(arrayLen(arguments) gte 1) numberofCharacters = val(arguments[1]);
if(arrayLen(arguments) gte 2) {
characterFilter = listsort(rereplace(arguments[2], "([[:alnum:]])", "\1,", "all"),"textnocase");
characterReplace = repeatString(",", listlen(characterFilter)-1);
}
while (len(placeCharacter) LT numberofCharacters) {
group = randRange(1,4, 'SHA1PRNG');
switch(group) {
case "1":
subGroup = rand();
    switch(subGroup) {
case "0":
placeCharacter = placeCharacter & chr(randRange(33,46, 'SHA1PRNG'));
break;
case "1":
placeCharacter = placeCharacter & chr(randRange(58,64, 'SHA1PRNG'));
break;
}
case "2":
placeCharacter = placeCharacter & chr(randRange(97,122, 'SHA1PRNG'));
break;
case "3":
placeCharacter = placeCharacter & chr(randRange(65,90, 'SHA1PRNG'));
break;
case "4":
placeCharacter = placeCharacter & chr(randRange(48,57, 'SHA1PRNG'));
break;
}
if (listLen(characterFilter)) {
placeCharacter = replacelist(placeCharacter, characterFilter, characterReplace);
}
}
return placeCharacter;
}
</cfscript>