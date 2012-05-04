# MuraMarkdown

This plugin replaces all instances of CK Editor in your Mura installation with a markdown editor. All content is still saved as HTML, so you *should* be able to switch back to CK Editor with no issues. That being said, I take no responsibility for any adverse effects this plugin has on your content. Use at your own risk!

## Stuff That Will Probably Break
1. Mura tags. Markdown loves its square brackets, so you will probably see some conflicts between your existing Mura tags and the markdown processing.
2. Images with inline height/width attributes. Markdown does not currently have any syntax for defining height and width attributes for images, so just make your images the proper size before linking to them.

If you spot anything else that breaks, please open an issue on the project at [https://github.com/s992/MuraMarkdown](https://github.com/s992/MuraMarkdown)

## Thanks!
MuraMarkdown wouldn't be possible without the following libraries:

 - WMD, which I *think* I found at [https://github.com/openlibrary/wmd](https://github.com/openlibrary/wmd)
 - [Showdown](https://github.com/coreyti/showdown)
 - [To-Markdown](https://github.com/domchristie/to-markdown)
 - [MarkdownJ](https://github.com/myabc/markdownj)