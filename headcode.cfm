<cfscript>
local = {};
local.$ = application.serviceFactory.getBean('muraScope').init( session.siteID );
local.pluginConfig = application.pluginManager.getConfig( 'MuraMarkdown' );
local.pluginAssetPath = local.$.globalConfig('context') & '/plugins/' & local.pluginConfig.getDirectory() & '/assets';
local.customCSS = local.$.siteConfig('themeAssetPath') & '/css/markdown.css';

// WMD Button Bar Styles
writeOutput( '<link rel="stylesheet" href="#local.pluginAssetPath#/css/wmd.css" />' );

// If there's any custom styles, include them
if( fileExists( expandPath( local.customCSS ) ) ) {
	writeOutput( '<link rel="stylesheet" href="#local.customCSS#" />' );
}

// Showdown is used to convert Markdown to HTML for the preview section
writeOutput( '<script type="text/javascript" src="#local.pluginAssetPath#/js/showdown.js"></script>' );

// To-markdown is used to convert HTML to Markdown for the editing section
writeOutput( '<script type="text/javascript" src="#local.pluginAssetPath#/js/to-markdown.js"></script>' );

// WMD handles all the button bars
writeOutput( '<script type="text/javascript" src="#local.pluginAssetPath#/js/wmd.js"></script>' );

// The main script for the plugin, this initializes the above scripts and makes
// the magic happen.
writeOutput( '<script type="text/javascript" src="#local.pluginAssetPath#/js/muraMarkdown.js"></script>' );
</cfscript>