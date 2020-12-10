# autohotkey-script
___
Script `AutoClass` will close all existing Chrome processes and start a new one in debug mode.
It manipulates this process via chrome-driver to simulate user interaction.

It takes inputs from files `join.txt`, `leave.txt` and `mute.txt`:
 - Writing to `leave.txt` will cause the script to leave the current meeting
 - Writing 1 to `mute.txt` will mute, and 0 will unmute the microphone on the current meeting
 - Writing `<platform> <url>` to `join.txt` will cause the script to open the URL and initiate the joining process for the platform
Upon reading the files, the script wipes their contents.

The supported platforms are:
 - `discord` (Note: only a specificly names voice channel will be joined)
 - `meet`
 - `teams`
 