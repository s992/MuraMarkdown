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
		<eventHandler event="onContentEdit" component="pluginEventHandler" persist="false" />
		<eventHandler event="onBeforeContentSave" component="pluginEventHandler" persist="false" />
		<eventHandler event="onRenderStart" component="pluginEventHandler" persist="false" />
	</eventHandlers>
	<displayObjects />
</plugin>
</cfoutput>