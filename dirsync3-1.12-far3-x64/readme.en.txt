 ______________________________________________________________________________
|                                                                              |
|   DirSync3 v1.11                     (c) 2014+ Pepak, https://www.pepak.net  |
|______________________________________________________________________________|

This is a directory synchronization plugin. It was originally based on plugin
Advanced Compare from FAR 1.xx, which I updated with progressbar display and
some basic synchronization features. Later, Igor Yudincev added FAR2 (Unicode)
support, then the development was picked up by Maximus5. Eventually, I found
myself in need of several additional features, including support for FAR3,
and decided to rewrite the plugin from C into Delphi as a part of the process.



USAGE
-----

Open the two directories which you want synchronized in both FAR's panels,
then run the plugin from the Plugins Menu (F11). A dialog will be shown,
where you can select several file comparison options: whether subdirectories
should be synchronized, too, on which criteria the comparison should be based
(filenames are always checked, but additionally you can compare modification
timestamps, file sizes or file contents, with an option to ignore some types
of differences). You can also decide whether the differences will be selected
on both panels or only on the panel which contains the newer version of the
file (default).

When you OK the dialog, directory scanning and comparison will start. You
will see a progress bar for individual files, though no total progress
indicator is used.

When the comparison completes, a new editor will be opened with the results.
It will start with the plugin name and the names of both directories, followed
by a brief description of the file (which can be disabled in the plugin's
configuration dialog). Changes to these sections will have no effect 
whatsoever.

Then the list of difference follows. One line is used for every difference,
with the following structure:

  1. The type of the difference:

     <<==   File is missing on the left. The file from the right will be
            copied here.
     ==>>   File is missing on the right. The file from the left will be
            copied here.
     <!--   File on the left is not readable (wholly or partially). It will
            be overwritten with the file on the right.
     --!>   File on the right is not readable (wholly or partially). It will
            be overwritten with the file on the left.
     <---   File on the left is older than the file on the right. It will
            be overwritten with the file on the right.
     --->   File on the right is older than the file on the left. It will
            be overwritten with the file on the left.
     <!!>   Both the left and the right file are not readable.
     <-->   The files on the left and right are different, but their date
            of modification is the same, so it's impossible to decide which
            one to keep and which one to overwrite. You will be asked.

  2. [Optionally] The cause for that difference:

     F      Filename mismatch (file with a matching name was not found or
            there was a mismatch while comparing names case sensitively).
     T      Timestamp mismatch (one of the files is older than the other).
     S      Size mismatch (one of the files is longer than the other).
     C      Content mismatch (the files have different content).

  3. One TAB character.

  4. The filename, relative to the left/right directory. If the filename
     ends with "\*", then the filename represents a directory which is
     completely missing on the left (or right).

You can edit this section, but you should keep the structure. It makes little
sense to edit the filenames. The most useful changes are either to the type
of the difference (e.g. you decide that you want to keep the older file and
overwrite the newer one with it), or you may delete a line if you don't want
to synchronize the file on it.

To facilitate the editation, you can use the plugin's menu to quickly change
the difference type, invoke a visual editor (provided that you selected one
in the plugin's options), open one of the files in the editor, show basic
information about both left and right files, or locate the next difference
of a given kind (either the next <<==, <---, <--> difference, or the next
==>>, --->, <--> difference).

Note that the change of the difference type will work on all files in a block,
if a block is active in the editor, except for differences due to errors
(<!--, --!>, <!!>); these are only supported if no block is active, to reduce
the danger of overwriting a readable file with an unreadable one.

You can also use hotkeys for the editor's menu (doesn't work in FAR2):
- ALT+F1/F2 (overwrite file on the left/right), 
- ALT+F3 (invoke visual compare),
- ALT+F5/F6 (locate the next difference),
- CTRL+F1/F2 (edit file on the left/right),
- CTRL+F3 (show file information),
- CTRL+F5/F6 (jump to the left/right file in the panels).
These hotkeys can be disabled in the plugin's options. Then you can resort
to the available plugin commands to re-define them to your liking.

When you are satisfied with the results, save the results file and close the 
editor. The synchronization menu will appear, where you can choose which 
synchronization tasks will be performed. The main options are:

  - Copy from right to left (i.e. process the "<<==", "<---" and "<!--"
    differences), with an option to skip confirmations.
  - Copy from left to right (i.e. process the "==>>", "--->" and "--!>"
    differences), with an option to skip confirmations.
  - Set the default action for "<-->" difference.
  - Change the meaning of "<<==" and "==>>" from "a missing file which
    should be added from the other directory" to "a file which was deleted
    in one directory and should be deleted in the other, too".
  - Silent mode: When enabled, the plugin postpones all confirmations until 
    after all synchronization items are processed. You can set the default
    value for silent mode in the plugin's options.
  - Global remember: When checked, the "Remember" checkbox will apply to
    all actions of the same kind (e.g. all deletions of files). When unchecked
    (default), you can specify a path to which the action applies (e.g.
    deletions will be remembered for that directory or its subdirectories).
    Note than while the "Remember" checkbox is focused and checked, you
    can use hotkeys BACKSPACE (delete the last subdirectory from the 
    "remember" path, i.e. remember for the parent directory of the current
    selection), DELETE (remember for all paths), F5 (reset the "remember"
    path to its original state).

By pressing the OK button you start the actual synchronization. You can
also return to the editor (to perhaps change some more synchronization items)
or cancel the synchronization altogether.

PluginCall support is available for all editor tasks. All of currently
supported functionality can be found in DirSync3.lua, along with a
demonstration of how the calls can be used. You can modify the macro at the
end of the file or add extra macros with other functions, as needed.



LICENSE
-------

The plugin is released under the Modified (3-clause) BSD License. See
license.txt for details.



BUILDING THE PLUGIN
-------------------

You will need Delphi version at least XE2. Older versions are not supported.
Newer versions should work fine.

Make sure the chosen Delphi's BIN directory is in the PATH, go into the
SOURCE directory and run BUILD. You should get a new DirSync3.dll in the BIN
directory.

You can use several command-line options with BUILD. The most important are:

    FAR2 ........ Build the FAR2 version of the plugin.
    FAR3 ........ Build the FAR3 version of the plugin (default).
    X86 ......... Build the 32-bit version of the plugin (default).
    X64 ......... Build the 64-bit version of the plugin.



CONTACT
-------

If you have any questions or want to suggest a new feature, you can do so
either at FAR Manager's forums in my DirSync3 thread ( https://forum.farmanager.com/viewtopic.php?f=39&t=4479 ),
my own forums ( https://forum.pepak.net ) or comment in the plugin's webpage
( https://www.pepak.net/software/far-manager-synchronize-directory/ ).
