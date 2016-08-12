# Xcode

Xcode is the primary IDE used for almost all iOS development and understanding how to use it effectively is critical to being a productive developer.


## Documentation

* [Xcode Overview](https://developer.apple.com/library/prerelease/content/documentation/ToolsLanguages/Conceptual/Xcode_Overview/index.html)
* [What's New in Xcode](https://developer.apple.com/xcode/) - updated with new Xcode releases


## Tips and tricks


### Useful keyboard shortcuts

| Keyboard shortcut | Action |
|-------------------|--------|
| <kbd>command</kbd>+<kbd>control</kbd>+<kbd>↓</kbd> | Toggle between .h/.m file   |
| <kbd>command</kbd>+<kbd>shift</kbd>+<kbd>O</kbd>   | Open Quickly (fuzzy find)   |
| <kbd>command</kbd>+<kbd>shift</kbd>+<kbd>J</kbd>   | Reveal in Project Navigator |
| <kbd>command</kbd>+<kbd>/</kbd>                    | Comment Selection           |


### Plugins

Xcode has a primitive and unsupported (by Apple) plugin system. Nevertheless, developers have taken advantage of it and created a growing ecosystem of plugins that extend Xcode with useful features or fix annoying bugs.


#### Alcatraz

[Alcatraz](http://alcatraz.io/) is an Xcode plugin manager, written as a plugin itself. Alcatraz adds a new menu item to Xcode and provides you with an interface for browsing and installing plugins created by others.

All Xcode plugins are open-source, and most developers submit them for inclusion in Alcatraz. Plugin developers are generally very open to contributions and will gladly accept changes to their plugin repositories, which then get propagated all Alcatraz users.

Some useful plugins:
  * [AdjustFontSize](https://github.com/zats/AdjustFontSize-Xcode-Plugin)
  * [Aviator](https://github.com/marksands/Aviator)
  * [GitDiff](https://github.com/johnno1962/GitDiff/)
  * [JKBlockCommenter](https://github.com/Johnykutty/JKBlockCommenter)
  * [KSImageNamed](https://github.com/ksuther/KSImageNamed-Xcode)
  * [Lin](https://github.com/questbeat/Lin-Xcode5)
  * [Peckham](https://github.com/markohlebar/Peckham)
  * [RevealPlugin](https://github.com/shjborage/Reveal-Plugin-for-Xcode)
  * [VVDocumenter-Xcode](https://github.com/onevcat/VVDocumenter-Xcode)
  * [Xcode_copy_line](https://github.com/mthiesen/Xcode_copy_line)
  * [XcodeBoost](https://github.com/fortinmike/XcodeBoost)
  * [XVim](https://github.com/XVimProject/XVim)


##### Caveats

Because of their unsupported nature, plugin development isn't very straightforward. Method swizzling and runtime introspection are commonly used. As such, proceed with caution. Plugins can be unstable and lead to Xcode crashes. However, I<sup>†</sup> have a dozen or so installed and don't experience any significant problems.

Plugins are loaded when Xcode launches and are required to have a valid `DVTPlugInCompatibilityUUID`. Each Xcode version will have a different UUID, so plugins may fail to load when updating Xcode. Developers tend to update their plugins regularly so this isn't a problem. See [this shell function](https://github.com/allewun/dotfiles/blob/7919f4237db593a031a11cc9766dc6e99d7b0e3b/functions.sh#L488-L501) for an immediate fix if the UUIDs aren't added to the plugins upstream.


### Snippets

Xcode has an often overlooked snippet manager. Snippets can be mapped to a completion shortcut. See the [unofficial source of Xcode Snippets](https://github.com/Xcode-Snippets).


---
<sup>†</sup> [Allen](mailto:allen.wu@originate.com)
