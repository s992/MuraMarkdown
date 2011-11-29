<cfcomponent name="pluginEventHandler" extends="mura.plugin.pluginGenericEventHandler">

	<cfset variables.pluginConfig = application.pluginManager.getConfig( 'MuraMarkdown' ) />

	<cffunction name="onContentEdit" access="public" output="true">
		<cfargument name="$" required="true" hint="mura scope">

		<cfset var headerCode = '' />
		<cfset var path = "#$.globalConfig('context')#/plugins/#variables.pluginConfig.getDirectory()#/assets" />

		<cfsavecontent variable="headerCode"><cfoutput>
			<link rel="stylesheet" href="#path#/js/wmd.css" />
			<script type="text/javascript" src="#path#/js/showdown.js"></script>
		</cfoutput></cfsavecontent>

		<cfhtmlhead text="#headerCode#" />

		<cfoutput>
			<script type="text/javascript">
				CKEDITOR.on('instanceCreated', function(e){
					e.editor.destroy();
				});
				jQuery('##summary').after('<div id="summary-preview"></div>');
				jQuery('##body').after('<div id="body-preview"></div>');
			</script>
			<script type="text/javascript" src="#path#/js/wmd.js"></script>
		</cfoutput>

	</cffunction>
	
	<cffunction name="onBeforeContentSave" access="public" output="false">
		<cfargument name="$" required="true" hint="mura scope">
		
	</cffunction>

	<cffunction name="onRenderStart" access="public" output="true">
		<cfargument name="$" required="true" hint="mura scope">

		<cfset var headerCode = '' />
		<cfset var path = "#$.globalConfig('context')#/plugins/#variables.pluginConfig.getDirectory()#/assets" />

	</cffunction>

</cfcomponent>