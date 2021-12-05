 ______________________________________________________________________________
|                                                                              |
|   Named Folders Lite v1.11          (c) 2014+ Pepak, https://www.pepak.net   |
|______________________________________________________________________________|

This plugin lets you assign names to any number of directories and use these
names to quickly access those directories. It is very much a copy of the
plugin Named Folders by Victor Derevyanko (http://code.google.com/p/namedfolders/),
but completely reimplemented: I decided to write it because the original version
exhibits serious database locking issues when used with FAR Manager 3 and it
seemed easier to rewrite the plugin than to fix it.



USAGE
-----

At the moment, only the following functionality is supported:

  * Command line control:

    cd::name ... Saves the current directory under the name "name".
    cd:name .... Jumps to the directory previously saved under the name "name".
    cd:- ....... Jump to the location which was active before the last cd:name.
    cd: ........ Opens the plugin's panel.

  * Item in the Disks menu lets you display defined named folders. From
    this panel, you can also use the following keyboard shortcuts:

    ENTER ......... Switch to the focused item's directory.
    SHIFT+ENTER ... Switch the passive panel to the focused item's directory.
    F3 ............ View focused item as XML.
    F4 ............ Edit focused item.
    SHIFT+F4 ...... Create a new item.
    F5, F6 ........ Copy/move selected items to a XML file or back.
    F8 ............ Delete selected items.

  * Fuzzy search: If you use "cd:x" from the command-line and no saved
    directory exists for "x", then the plugin will scan directories whose
    names start with "x". If more than one is present, you will be given
    a choice between them; if only one is present, it will be used instead
    of "x". Since version 1.03, this feature is only optional (but enabled
    by default in plugin's options).

    Another fuzzy search option involves search across directories: If it
    is enabled, command "cd:x" will also find named folders such as "a/x"
    or "bbb/x". Note that if "x" contains directories, i.e. "cd:x/a", then
    this functionality is disabled: "cd:x/a" will never find named folder
    "z/x/a". This is intentional - once a path is given, it should be matched.

    Note that an exact match will always take precedence over a fuzzy match.

  * If you edit saved directories manually (from the panel), you can
    optionally use variables within the paths. E.g., instead of writing the
    actual path to the start menu, you can use a variable which gets replaced
    with the actual start menu folder's location at runtime.

    Note that this functionality is disabled by default and needs to be
    enabled in Plugin Options. Also, only regular directory-based paths
    are scanned for variables, plugin paths are left as-is.

    The following types of variables are available (and can be individually
    turned on or off in Options if you so desire):

      - Known folders:   "$(DIR:STARTMENU)", "$(CSIDL_STARTMENU)"
        - Known Windows folders, as per Microsoft CSIDL constants:
          https://msdn.microsoft.com/en-us/library/windows/desktop/bb762494(v=vs.85).aspx
      - Environment:     "$(ENV:USERPROFILE)", "$(ENV:TEMP)"
        - Environment variables of the current process.
      - CMD environment: "%USERPROFILE%", "%TEMP%"
        - Same as above, but with a different syntax (like in CMD.EXE).
      - Registry:        "$(REG:HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run\SomeApp)"
        - The last element is the name of the value to be used.
        - Shortcut forms for the root key (e.g. "HKLM") are also supported.
        - Note: Only string values are supported.

  * Support for Plugin.Call functionality of FAR's macro language. The syntax
    is, generally:

      Plugin.Call("6073FF5D-703E-4C1E-8182-26400240073A", command, params)

    Where command is one of the following and params are specific to each
    command:

      "OPEN"
        - Open's the plugin's panel. No params necessary. Essentially the
          same functionality as opening the plugin's panel manually from
          the disk menu.
        - Optionally, you can provide a name of a directory which should
          open instead of the default directory (root or last, depending
          on settings).
        - Optionally, you can provide a name of a stored named folder.
          The panel will then open with the cursor on that item.
        - Example: Plugin.Call("...", "OPEN")
                   Plugin.Call("...", "OPEN", "\\devel")
                   Plugin.Call("...", "OPEN", "\\devel\\c")

      "GO" or "GOTO"
        - Sets current directory to the named folder identified by the first
          parameter. Essentially the same functionality as command-line's
          "cd:name".
        - Example: Plugin.Call("...", "GO", "WIN")
                   Plugin.Call("...", "GO", "WORK\\FAR")
                   Plugin.Call("...", "GO", "-")
          (Examples assume that "WIN" and "WORK\FAR" are existing named folder
          identifiers, either filesystem or plugin based.)

      "EXISTS"
        - Checks whether a named folder identified by the first parameter is
          defined. The result is given as a boolean value at the function's
          exit.
        - Example: Plugin.Call("...", "EXISTS", "WIN")

      "SETCURRENT"
        - Creates a new named folder (identified by the first parameter)
          targeting the current location in the active panel. Basically the
          same functionality as command-line's "cd::name"
        - Example: Plugin.Call("...", "SETCURRENT", "NAME")

      "SET"
        - Creates a new named folder (identified by the first parameter)
          targeting a destination identified by further parameters:
          - 2nd parameter: target directory (required)
          - 3rd parameter: description
          - 4th parameter: plugin's GUID (for plugin-based targets)
          - 5th parameter: plugin's parameters
          - 6th parameter: plugin's host file
          All arguments starting with the 3rd are optional.
        - Example: Plugin.Call("...", "SET", "WIN", "C:\\Windows")
                   Plugin.Call("...", "SET", "WIN", "C:\\Windows", "Windows")

      "GET"
        - Returns information about named folder identified by the first
          parameter. The result is returned as five string values:
          - 1st value: target directory
          - 2nd value: description
          - 3rd value: plugin's GUID (for plugin-based targets)
          - 4th value: plugin's parameters
          - 5th value: plugin's host file
        - Example: dir,desc,guid,param,host = Plugin.Call("...", "GET", "WIN")

      "DELETE"
        - Deletes a named folder identified by the first parameter.
        - Example: Plugin.Call("...", "DELETE", "WIN")

    If no command is provided, "OPEN" is used as default.

  * It is possible to directly enter a subdirectory of a named folder with
    "cd:a/b\c\d". Here "a/b" is the name of the named folder and "\c\d" is
    a subdirectory to go to, determined as everything starting from the
    first backslash ("\"). E.g., assume that "a/b" points to "C:\WINDOWS".
    Then "cd:a/b\system32" opens "C:\WINDOWS\System32".
    This feature is disabled by default. If you want to use it, go to the
    plugin's options and activate the "Allow path suffix" option.

  * The plugin may be used to create shortcuts to non-panel functionalities
    of various plugins if you enable the "Allow plugin calls" option and then
    enter plugin command-line as a directory: "edit:<far /?". Be wary of
    creating loops as these are not being detected and will eventually crash
    FAR Manager.


KNOWN LIMITATIONS
-----------------

Named folders to quite a few plugins' panels do not work.  That is not a
limitation of Named Folders Lite but of each plugin itself - in order for
the plugin to be supported, it must implement OPEN_SHORTCUT source when
opening the plugin. That is not required by FAR API itself so many plugins
do not implement it. I do not know how to overcome this issue.



LICENSE
-------

The plugin is released under the Modified (3-clause) BSD License. See
license.txt for details.



BUILDING THE PLUGIN
-------------------

You will need Delphi version at least XE2. Older versions are not supported.
Newer versions should work fine.

Make sure the chosen Delphi's BIN directory is in the PATH, go into the
SOURCE directory and run BUILD. You should get a new NamedFoldersLite.dll in the BIN
directory.

You can use several command-line options with BUILD. The most important are:

    FAR2 ........ Build the FAR2 version of the plugin.
    FAR3 ........ Build the FAR3 version of the plugin (default).
    X86 ......... Build the 32-bit version of the plugin (default).
    X64 ......... Build the 64-bit version of the plugin.



CONTACT
-------

If you have any questions or want to suggest a new feature, you can do so
either at FAR Manager's forums in my Named Folders Lite thread ( https://forum.farmanager.com/viewtopic.php?f=39&t=9721 ),
my own forums ( https://forum.pepak.net ).
