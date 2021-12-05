 ______________________________________________________________________________
|                                                                              |
|   Named Folders Lite v1.03        (c) 2014-16 Pepak, https://www.pepak.net   |
|______________________________________________________________________________|

Samples of some of the more advanced Named Folder's Lite settings in the
XML format. If you want to try them out, copy (F5) the files into the
plugin's panel.

Available files:

  * cd_systemdrive.nfl

    Shows how to execute a command line command from Named Folders Lite.
    The trick here is to use the LuaMacro plugin to first type a command
    into command line and then send an Enter key to FAR Manager to execute
    that command line. However, note that sending of keys is rather fragile
    as it depends on the actual context of FAR Manager. It is quite possible
    that in some situations this code won't work, e.g. if the plugin is
    called from a menu (which can happen if a third-party plugin initiates
    a call to Named Folders Lite to go to a named folder).

  * lua_msgbox.nfl

    Shows how to use the LUAMacro plugin to show a messagebox from Named
    Folders Lite.

  * plug_hostfile.nfl

    This is what a named folder looks like for ArcLite displaying an archive.

  * temporary_fix_for_locate_netbox_folder.nfl

    For some reason, it is not possible to create bookmarks to the connection
    list of NetBox. Until I can figure out what's going on, this demonstrates
    opening of the NetBox panel and going to a chosen directory in it.

  * temporary_fix_for_locate_nfl_folder.nfl

    Much the same thing as temporary_fix_for_locate_netbox_folder.nfl, but
    for Named Folders Lite itself.

  * view_output_of_command.nfl

    Shows how to call a third-party plugin's command line. Here we use the
    standard plugin FarCmds and specifically its "view" function to show
    the output of an application in FAR's internal Viewer. The application
    in this case is Windows' "mountvol" and the output is the identification
    of the system volume (which demonstrates the filename substitution
    feature of my plugin - you need to enable Substitutions and specifically
    the DOS Environment substitution for this example to work).

