<cfcomponent name="pluginEventHandler" extends="mura.plugin.pluginGenericEventHandler">

	<cfset variables.pluginConfig = application.pluginManager.getConfig( 'MuraMarkdown' ) />

	<!---
		All the client side previewing is handled here.
	--->
	<cffunction name="onContentEdit" access="public" output="false">
		<cfargument name="$" required="true" hint="mura scope">

		<cfset var headerCode = '' />
		<cfset var path = "#$.globalConfig('context')#/plugins/#variables.pluginConfig.getDirectory()#" />
		<cfset var customCSS = "#$.siteConfig('themeAssetPath')#/css/markdown.css" />

		<!--- Include the necessary JS/CSS in the header --->
		<cfsavecontent variable="headerCode"><cfoutput>

			<!--- This stylesheet contains the necessary styles for the WMD button bar --->
			<link rel="stylesheet" href="#path#/assets/css/wmd.css" />

			<!--- If the user wishes to include their own styling for anything here, they can. --->
			<cfif fileExists( expandPath( customCSS ) )>
				<link rel="stylesheet" href="#customCSS#">
			</cfif>

			<!--- Showdown is used to convert Markdown to HTML for the preview section --->
			<script type="text/javascript" src="#path#/assets/js/showdown.js"></script>

			<!--- To-markdown is used to convert HTML to Markdown for the editing section --->
			<script type="text/javascript" src="#path#/assets/js/to-markdown.js"></script>

			<!--- WMD handles all the button bars --->
			<script type="text/javascript" src="#path#/assets/js/wmd.js"></script>

			<!--- 
				This script initializes all the scripts above along with destroying
				CK Editor instances for Body and Summary
			--->
			<script type="text/javascript" src="#path#/assets/js/muraMarkdown.min.js"></script>
		</cfoutput></cfsavecontent>

		<cfhtmlhead text="#headerCode#" />
		
	</cffunction>

	<!---
		The content is saved as plain HTML for maximum compatibility with any
		WYSIWYG editor. Prior to saving, we'll convert the markdown into HTML.
	--->
	<cffunction name="onBeforeContentSave" access="public" output="false">
		<cfargument name="$" required="true" hint="mura scope">

		<cfset var summary = $.content().getSummary() />
		<cfset var body = $.content().getBody() />
		
		<!--- We save the content as plain old HTML --->
		<cfset $.content().setSummary( processMarkdown( $, summary) ) />
		<cfset $.content().setBody( processMarkdown( $, body) ) />

	</cffunction>

	<cffunction name="processMarkdown" access="private" returntype="string" output="false">
		<cfargument name="$" required="true" hint="mura scope">
		<cfargument name="html" required="true" type="string">

		<cfset var path = "#$.globalConfig('context')#/plugins/#variables.pluginConfig.getDirectory()#" />
		<cfset var mkdownPath = [ expandPath( "#path#/markdown/markdownj.jar" ) ] />
		<cfset var javaLoader = createObject( 'component', 'javaloader.JavaLoader' ).init( mkdownPath, true ) />
		<cfset var markdownProcessor = javaLoader.create( "com.petebevin.markdown.MarkdownProcessor" ).init() />
		<cfset var returnHTML = '' />

		<!--- Process the markdown --->
		<cfset returnHTML = markdownProcessor.markdown( arguments.html ) />

		<!--- MarkdownJ loves to covert our HTML entities over and over for some reason. --->
		<cfset returnHTML = reReplace( returnHTML, '[&amp;]+lt;', '&lt;', 'all' ) />
		<cfset returnHTML = reReplace( returnHTML, '[&amp;]+gt;', '&gt;', 'all' ) />
		<cfset returnHTML = reReplace( returnHTML, '[&amp;]+amp;', '&amp;', 'all' ) />
		<cfset returnHTML = reReplace( returnHTML, '[&amp;]+quot;', '&quot;', 'all' ) />

		<cfreturn returnHTML />
	</cffunction>

</cfcomponent>