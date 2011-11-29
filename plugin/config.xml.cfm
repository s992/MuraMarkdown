<cfoutput>
<plugin>
	<name>MuraMarkdown</name>
	<package>MuraMarkdown</package>
	<directoryFormat>packageOnly</directoryFormat>
	<loadPriority>5</loadPriority>
	<version>1.0</version>
	<provider>Sean Walsh</provider>
	<providerURL>http://thehatrack.net</providerURL>
	<category>Application</category>
	<settings>
	</settings>
	<eventHandlers>
		<eventHandler event="onApplicationLoad" component="pluginEventHandler" persist="false" />
		<eventHandler event="onContentEdit" component="pluginEventHandler" persist="false" />
		<eventHandler event="onRenderStart" component="pluginEventHandler" persist="false" />
		<eventHandler event="onPageBodyRender" component="pluginEventHandler" persist="false" />
	</eventHandlers>
	<displayObjects />
</plugin>
</cfoutput>