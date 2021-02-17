<cfoutput>
<div class="control-group">
	<label class="control-label">Tell Google Not to Index This Page?</label>
	<div class="controls">
		<cfif parameterexists(id)>
			<label class="radio">
				<input type="radio" name="googleIndex" value="No" <cfif getinfo.googleIndex eq 'No'>checked</cfif>>No
			</label>
			<label class="radio">
				<input type="radio" name="googleIndex" value="Yes" <cfif getinfo.googleIndex eq 'Yes'>checked</cfif>>Yes
			</label>
		<cfelse>
			<label class="radio">
				<input type="radio" name="googleIndex" value="No" checked>No
			</label>
			<label class="radio">
				<input type="radio" name="googleIndex" value="Yes">Yes
			</label>
		</cfif>
	</div>
</div>

<div class="control-group">
	<label class="control-label">Canonical URL</label>
	<div class="controls">
		<input maxlength="255" name="canonicalLink" type="text" <cfif parameterexists(id)>value="#getinfo.canonicalLink#"</cfif>>
	</div>
</div>

<div class="control-group">
	<label class="control-label">H1 Tag</label>
	<div class="controls">
		<input maxlength="255" name="h1" type="text" <cfif parameterexists(id)>value="#getinfo.h1#"</cfif>>
	</div>
</div>

<div class="control-group">
	<label class="control-label">Meta Title</label>
	<div class="controls">
		<input maxlength="255" name="metatitle" size="70" type="text" <cfif parameterexists(id)>value="#getinfo.metatitle#"</cfif>>
		<div class="input-prepend">
			<button class="btn btn-info" type="button" onClick="countit3(this)">Calculate Characters</button>
			<input type="text" name="displaycount3" class="input-small" style="width:10%"  id="prependedInputButton">
		</div>
	</div>
</div>

<div class="control-group">
	<label class="control-label">Meta Description</label>
	<div class="controls">
		<textarea name="metadescription" class="mceNoEditor"><cfif parameterexists(id)>#getinfo.metadescription#</cfif></textarea>
		<div class="input-prepend">
			<button class="btn btn-info" type="button" onClick="countit2(this)">Calculate Characters</button>
			<input type="text" name="displaycount2" class="input-small" style="width:10%"  id="prependedInputButton">
		</div>
	</div>
</div>
</cfoutput>