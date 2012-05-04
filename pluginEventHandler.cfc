component extends='mura.plugin.pluginGenericEventHandler' {

	variables.pluginConfig = application.pluginManager.getConfig( 'MuraMarkdown' );

	public void function onContentEdit( required $ ) {
		variables.pluginConfig.addToHTMLHeadQueue( 'headcode.cfm' );
	}

	public void function onBeforeContentSave( required $ ) {
		var pluginPath = $.globalConfig('context') & '/plugins/' & variables.pluginConfig.getDirectory();
		var jarPath = [ expandPath( pluginPath & '/markdown/markdownj.jar' ) ];
		var processor = $.getBean('javaloader').init( jarPath ).create( 'com.petebevin.markdown.MarkdownProcessor' ).init();

		var summary = $.content('summary');
		var body = $.content('body');

		$.content( 'summary', processMarkdown( processor, summary ) );
		$.content( 'body', processMarkdown( processor, body ) );

		processExtendedAttributes( $, processor );
	}

	private void function processExtendedAttributes( required $, required processor ) {
		var rsAttributes = $.content().getExtendedData().getAllValues().data;
		var attributeList = '';
		var qrySvc = '';

		if( rsAttributes.recordCount ) {
			attributeList = valueList( rsAttributes.attributeID );
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
			rsAttributes = qrySvc.execute().getResult();

			for( var i = 1; i LTE rsAttributes.recordCount; i++ ) {
				var content = $.content( rsAttributes.name );
				$.content( rsAttributes.name, processMarkdown( arguments.processor, content ) );
			}
		}

	}

	private string function processMarkdown( required processor, required string content ) {
		return arguments.processor.markdown( arguments.content );
	}

}