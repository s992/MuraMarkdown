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

	<cffunction name="onRenderStart" access="public" output="true">
		<cfargument name="$" required="true" hint="mura scope">

		<cfset var headerCode = '' />
		<cfset var path = "#$.globalConfig('context')#/plugins/#variables.pluginConfig.getDirectory()#" />

		<!--- Bring out the syntax highlighter! --->
		<cfsavecontent variable="headerCode"><cfoutput>
		<script type="text/javascript" src="#path#/assets/js/jquery.syntaxhighlighter.min.js"></script>
		<script type="text/javascript" src="#path#/assets/js/shInit.js"></script>
		</cfoutput></cfsavecontent>

		<cfhtmlhead text="#headerCode#" />

	</cffunction>

	<cffunction name="onPageBodyRender" access="public" output="true">
		<cfargument name="$" required="true" hint="mura scope">

		<cfset var body = $.content().getBody() />
		<cfset var summary = $.content().getSummary() />

		<cfset body =  processMarkdown( $, body ) />
		<cfset $.content().setSummary( processMarkdown( $, summary ) ) />
		
		<cfoutput>#body#</cfoutput>

	</cffunction>

	<cffunction name="processMarkdown" access="private" returntype="string" output="false">
		<cfargument name="$" required="true" hint="mura scope">
		<cfargument name="html" required="true" type="string">

		<cfset var path = "#$.globalConfig('context')#/plugins/#variables.pluginConfig.getDirectory()#" />
		<cfset var mkdownPath = [ expandPath( "#path#/markdown/markdownj.jar" ) ] />
		<cfset var javaLoader = new javaloader.JavaLoader( mkdownPath, true ) />
		<cfset var markdownProcessor = javaLoader.create( "com.petebevin.markdown.MarkdownProcessor" ).init() />
		<cfset var returnHTML = '' />

		<!--- First, process the markdown --->
		<cfset returnHTML = markdownProcessor.markdown( arguments.html ) />

		<!--- Then manipulate it a little bit to get our syntax highlighting working --->
		<cfset returnHTML = 
				reReplaceNoCase(
					returnHTML,
					'<pre><code>(.+?)</code></pre>',
					'<pre class="highlight">\1</pre>',
					'all'
				) />

		<cfreturn returnHTML />
	</cffunction>

<!--- will fix these later
	<cffunction name="getMarkdownProcessor" access="private" returntype="any" output="false">
		<cfargument name="$" required="true" hint="mura scope">

		<cfset var path = "#$.globalConfig('context')#/plugins/#variables.pluginConfig.getDirectory()#" />
		<cfset var mkdownPath = [ expandPath( "#path#/markdown/markdownj.jar" ) ] />
		<cfset var javaLoader = new javaloader.JavaLoader( mkdownPath, true ) />
		<cfset var markdownProcessor = javaLoader.create( "com.petebevin.markdown.MarkdownProcessor" ).init() />

		<cfreturn markdownProcessor />

	</cffunction>

	<cffunction name="getJsoup" access="private" returntype="any" output="false">
		<cfargument name="$" required="true" hint="mura scope">

		<cfset var path = "#$.globalConfig('context')#/plugins/#variables.pluginConfig.getDirectory()#" />
		<cfset var jsoupPath = [ expandPath( "#path#/jsoup/jsoup.jar" ) ] />
		<cfset var javaLoader = new javaloader.JavaLoader( jsoupPath, true ) />
		<cfset var jsoup = javaLoader.create( "org.jsoup.Jsoup" ) />

		<cfreturn jsoup />

	</cffunction>
--->
</cfcomponent>