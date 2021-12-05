 ______________________________________________________________________________
|                                                                              |
|   NewName3 v1.01                     (c) 2014+ Pepak, https://www.pepak.net  |
|______________________________________________________________________________|

This is a file rename plugin, based on the Ivan Sintyurin's NewName plugin
(https://plugring.farmanager.com/plugin.php?pid=83). It has been, however,
completely re-implemented and updated to work with modern versions of FAR.
Where it seemed useful, I also added some new functionality.



USAGE
-----

In a panel, select the files you wish to rename and invoke the plugin from
the Plugins Menu (F11). You can then specify the pattern for new filenames,
where you can use the following special symbols:

  %# .... The sequential number of the file. The sequence begins with the
          number specified with the option "<--- Start from this number"
          and is incremented for each processed file. Optional leading 
          zeroes serve to specify the minimal length of the number (e.g.
          if you start with "1", the files will be renamed to "file1",
          "file2" etc., while starting with "0008" gets you "file0008",
          "file0009" etc.).
  %h .... Similar to %#, but the sequential number is in hex (lower-case).
  %H .... Similar to %#, but the sequential number is in hex (upper-case).
  %t .... The total number of files to be replaced. The length of the
          number is determined the same way as with %#.
  %f .... The original file name and extension.
  %n .... The original file name without extension.
  %e .... The original file extension.
  %% .... The percent symbol ("%").

When you click OK, the files will get renamed. If some of the files fail
to rename, their list will be shown in FAR's editor.



LICENSE
-------

The plugin is released under the Modified (3-clause) BSD License. See
license.txt for details.



BUILDING THE PLUGIN
-------------------

You will need Delphi version at least XE2. Older versions are not supported.
Newer versions should work fine.

Make sure the chosen Delphi's BIN directory is in the PATH, go into the
SOURCE directory and run BUILD. You should get a new NewName3.dll in the BIN
directory.

You can use several command-line options with BUILD. The most important are:

    FAR2 ........ Build the FAR2 version of the plugin.
    FAR3 ........ Build the FAR3 version of the plugin (default).
    X86 ......... Build the 32-bit version of the plugin (default).
    X64 ......... Build the 64-bit version of the plugin.



CONTACT
-------

If you have any questions or want to suggest a new feature, you can do so
either at FAR Manager's forums in my FRename3 thread ( https://forum.farmanager.com/viewtopic.php?f=39&t=9720 ),
my own forums ( https://forum.pepak.net ).
