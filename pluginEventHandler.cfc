<cfcomponent name="pluginEventHandler" extends="mura.plugin.pluginGenericEventHandler">

	<cfset variables.pluginConfig = application.pluginManager.getConfig( 'MuraMarkdown' ) />

	<cffunction name="onApplicationLoad" access="public" output="false">
		<cfargument name="$" required="true" hint="mura scope">

		<cfset application.configBean.setValue("htmlEditorType","none") />

	</cffunction>

	<cffunction name="onContentEdit" access="public" output="true">
		<cfargument name="$" required="true" hint="mura scope">

		<cfset var headerCode = '' />
		<cfset var path = "#$.globalConfig('context')#/plugins/#variables.pluginConfig.getDirectory()#" />

		<!--- Include the necessary JS/CSS in the header --->
		<cfsavecontent variable="headerCode"><cfoutput>
			<link rel="stylesheet" href="#path#/assets/css/wmd.css" />
			<script type="text/javascript" src="#path#/assets/js/showdown.js"></script>
		</cfoutput></cfsavecontent>

		<cfhtmlhead text="#headerCode#" />

		<!--- This will allow us to preview our markdown --->
		<cfoutput>
			<script type="text/javascript" src="#path#/assets/js/wmd.js"></script>
			<script type="text/javascript">
			jQuery(document).ready(function(){
				jQuery('##summary')
					.before('<div id="summary-button-bar"></div>')
					.after('<div id="summary-preview"></div>');

				jQuery('##body')
					.before('<div id="body-button-bar"></div>')
					.after('<div id="body-preview"></div>');
			
				setup_wmd({
					input: "summary",
					button_bar: "summary-button-bar",
					preview: "summary-preview",
					helpLink: "#path#/markdownhelp.html"
				});

				setup_wmd({
					input: "body",
					button_bar: "body-button-bar",
					preview: "body-preview",
					helpLink: "#path#/markdownhelp.html"
				});
			});
			</script>
		</cfoutput>

	</cffunction>
	
	<cffunction name="onBeforeContentSave" access="public" output="false">
		<cfargument name="$" required="true" hint="mura scope">
		
	</cffunction>

	<cffunction name="onRenderStart" access="public" output="true">
		<cfargument name="$" required="true" hint="mura scope">

		<cfset var headerCode = '' />
		<cfset var path = "#$.globalConfig('context')#/plugins/#variables.pluginConfig.getDirectory()#/assets" />

		<cfset $.content().setBody('you suck.') />

	</cffunction>

</cfcomponent>