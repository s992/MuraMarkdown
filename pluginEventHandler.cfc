<cfcomponent name="pluginEventHandler" extends="mura.plugin.pluginGenericEventHandler">

	<cfset variables.pluginConfig = application.pluginManager.getConfig( 'MuraMarkdown' ) />

	<cffunction name="onApplicationLoad" access="public" output="false">
		<cfargument name="$" required="true" hint="mura scope">

		<cfset application.configBean.setValue( 'htmlEditorType', 'none' ) />

	</cffunction>

	<cffunction name="onContentEdit" access="public" output="false">
		<cfargument name="$" required="true" hint="mura scope">

		<cfset var headerCode = '' />
		<cfset var path = "#$.globalConfig('context')#/plugins/#variables.pluginConfig.getDirectory()#" />

		<!--- Include the necessary JS/CSS in the header --->
		<cfsavecontent variable="headerCode"><cfoutput>
			<link rel="stylesheet" href="#path#/assets/css/wmd.css" />
			<script type="text/javascript" src="#path#/assets/js/showdown.js"></script>
			<script type="text/javascript" src="#path#/assets/js/to-markdown.js"></script>
			<script type="text/javascript" src="#path#/assets/js/wmd.js"></script>
			<script type="text/javascript">
			jQuery(document).ready(function(){

				removeTab();
				setupMarkdown( 'body' );
				setupMarkdown( 'summary' );
				replaceHTML( 'body' );
				replaceHTML( 'summary' );

			});

			/**
			* Adds necessary divs for preview and button bar,
			* then starts up WMD for live markdown preview
			*/
			function setupMarkdown( id ) {
				var txtArea = jQuery( 'textarea##' + id )
					buttonBar = jQuery( '<div></div>' )
					preview = jQuery( '<div></div>' );

				buttonBar.attr( 'id', id + '-button-bar' )
						 .addClass( 'wmd-button-bar' );
				preview.attr( 'id', id + '-preview' )
					   .addClass( 'wmd-preview' );

				txtArea.before( buttonBar )
					   .after( preview )
					   .addClass( 'wmd-input' );
				
				setup_wmd({
					input: id,
					button_bar: id + '-button-bar',
					preview: id + '-preview'
				});
			}

			/**
			* We store the content as HTML converted from markdown,
			* so to edit it later we need to convert it back to
			* markdown.
			*/
			function replaceHTML( id ) {
				var html = jQuery( '##' + id + '-preview' ).html()
					txtArea = jQuery( 'textarea##' + id );

				txtArea.html( toMarkdown( html ) );
			}

			/**
			* This removes the tab that Mura automatically inserts
			* when we use the onContentEdit event.
			*/
			function removeTab() {
				jQuery( 'div.tabs ul li a span' ).each(function(){
					var thisTab = jQuery( this );

					if( thisTab.text() == '#variables.pluginConfig.getName()#' ){
						thisTab.parent().parent().hide();
					}
				});
			}
			</script>
		</cfoutput></cfsavecontent>

		<cfhtmlhead text="#headerCode#" />
		
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