component extends='mura.plugin.pluginGenericEventHandler' {

	variables.pluginConfig = application.pluginManager.getConfig( 'MuraMarkdown' );

	public void function onContentEdit( required $ ) {
		variables.pluginConfig.addToHTMLHeadQueue( 'headcode.cfm' );
	}

	public void function onBeforeContentSave( required $ ) {
		var summary = $.content('summary');
		var body = $.content('body');

		$.content( 'summary', processMarkdown( $, summary ) );
		$.content( 'body', processMarkdown( $, body ) );

		dealWithExtendedAttributes( $ );
	}

	private void function dealWithExtendedAttributes( required $ ) {
		var rsAttributes = $.content().getExtendedData().getAllValues().data;
		var attributeList = '';
		var qrySvc = '';

		if( rsAttributes.recordCount ) {
			attributeList = valueList( rsAttributes, 'attributeID' );
			qrySvc = new query()
							.setDatasource( $.globalConfig( 'datasource' ) )
							.setUsername( $.globalConfig( 'dbUsername' ) )
							.setPassword( $.globalConfig( 'dbPassword' ) );

			qrySvc.setSQL("
				SELECT
					name
					, attributeID
				FROM
					tclassextendattributes
				WHERE
					attributeID IN ( :attributeList )
				AND
					type = 'HTMLEditor'
			");

			qrySvc.addParam( name = 'attributeList', value = attributeList, cfsqltype = 'CF_SQL_VARCHAR', list = true );
			rsAttributes = qrySvc.executeQuery().getResults();

			for( var i = 1; i LTE rsAttributes.recordCount; i++ ) {
				$.content( rsAttributes.name, processMarkdown( $, rsAttributes.name ) );
			}
		}

	}

	private string function processMarkdown( required $, required string html ) {
		var pluginPath = $.globalConfig('context') & '/plugins/' & variables.pluginConfig.getDirectory();
		var jarPath = [ expandPath( pluginPath & '/markdown/markdownj.jar' ) ];
		var javaLoader = new javaloader.JavaLoader( jarPath, true );
		var processor = javaLoader.create( 'com.petebevin.markdown.MarkdownProcessor' ).init();

		return processor.markdown( arguments.html );
	}

}