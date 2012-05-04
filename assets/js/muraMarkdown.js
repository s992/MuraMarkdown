jQuery(function($){

	var MuraMarkdown = {
		init: function() {
			this.cacheElements();
			this.bindEvents();
			this.render();
		},
		cacheElements: function() {
			this.$textareas = $('textarea');
			this.$pluginTab = $('a[href=#tabsysMuramarkdown]').parent();
		},
		bindEvents: function() {
			this.$textareas.live( 'instanceReady.ckeditor', this.removeEditor );
		},
		render: function() {
			this.$pluginTab.hide();
		},
		removeEditor: function( e, i ) {
			var ele = $( '#' + i.name );

			i.destroy();
			MuraMarkdown.setupMarkdown( ele );
		},
		setupMarkdown: function( ele ) {
			var eleID = ele.attr('id'),
				buttonBar,
				preview,
				previewToggle,
				ev;

			buttonBar = $('<div></div>', {
				'id': eleID + '-button-bar',
				'class': 'wmd-button-bar'
			});

			preview = $('<div></div>', {
				'id': eleID + '-preview',
				'class': 'wmd-preview',
				'css': { 'display': 'none' }
			});

			previewToggle = $('<div></div>', {
				'id': eleID + '-preview-toggle',
				'class': 'wmd-preview-toggle',
				'html': '<p>Show Preview</p>'
			});

			ele
				.before( buttonBar )
				.after( preview )
				.after( previewToggle )
				.addClass( 'wmd-input' );

			setup_wmd({
				'input': eleID,
				'button_bar': eleID + '-button-bar',
				'preview': eleID + '-preview'
			});

			MuraMarkdown.replaceHTML( ele );
			MuraMarkdown.setupPreviewLinks( ele );
		},
		replaceHTML: function( ele ) {
			var newHTML = ele.siblings('.wmd-preview').html(),
				mkdown = toMarkdown( newHTML );

			ele.html( mkdown );
			ele.val( mkdown );
		},
		setupPreviewLinks: function( ele ) {
			ele.siblings('.wmd-preview-toggle').on('click', MuraMarkdown.togglePreview);
		},
		togglePreview: function( event ) {
			var $this = $(this),
				msg = $this.find('p'),
				preview = $this.siblings('.wmd-preview');

			preview.slideToggle();
			msg.text() === 'Show Preview' ? msg.text('Hide Preview') : msg.text('Show Preview');
		}
	};

	return MuraMarkdown.init();
});