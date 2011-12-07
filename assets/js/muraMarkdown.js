jQuery(document).ready(function(){
	var instances = [ 'body', 'summary' ];

	removeEditor( instances );
	removeTab();

	// We need to make sure the "edit summary" section goes back
	// to being hidden.
	toggleDisplay('editSummary','Expand','Close');

});

/**
* Removes CK Editor and then sets up markdown and textarea content.
*/
function removeEditor( names ) {
	jQuery.each( names, function(index, name){
		jQuery( '#' + name ).bind( 'instanceReady.ckeditor', function(e, i){
			i.destroy();
			setupMarkdown( i.name );
			replaceHTML( i.name );
			handlePreviewToggle( i.name ); 
			return false;
		});
	});
}

/**
* Adds necessary divs for preview and button bar,
* then starts up WMD for live markdown preview
*/
function setupMarkdown( id ) {
	var txtArea = jQuery( 'textarea#' + id )
		buttonBar = jQuery( '<div></div>' )
		preview = jQuery( '<div></div>' )
		previewToggle = jQuery( '<div></div>' );

	buttonBar.attr( 'id', id + '-button-bar' )
			 .addClass( 'wmd-button-bar' );

	preview.attr( 'id', id + '-preview' )
		   .css('display', 'none')
		   .addClass( 'wmd-preview' );

	previewToggle.attr( 'id', id + '-preview-toggle' )
				 .addClass( 'wmd-preview-toggle' )
				 .html( '<p>Show Preview</p>' );

	txtArea.before( buttonBar )
		   .after( preview )
		   .after( previewToggle )
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
	var html = jQuery( '#' + id + '-preview' ).html()
		txtArea = jQuery( 'textarea#' + id )
		mkdown = toMarkdown( html );

	txtArea.html('');
	txtArea.val('');
	txtArea.html( mkdown );
	txtArea.val( mkdown );
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

/**
* This allows us to turn the preview DIV on and off.
*/
function handlePreviewToggle( name ) {
	jQuery('#' + name + '-preview-toggle').click(function(){
		var msg = jQuery(this).find('p');
		jQuery('#' + name + '-preview').slideToggle('slow');
		msg.html() == 'Show Preview' ? msg.html('Hide Preview') : msg.html('Show Preview');
	});
}