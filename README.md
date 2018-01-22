# ps_brief
Understand all running non-kernel processes with manual and package brief.  

This script dump all running processes with dpkg description, process name, process id, filetype, manual brief, then saved into a single file. 

Processes in the same package will group together.   

You should run it as root in bash, i.e. sudo. Support only for dpkg-based systems.  

Note that "No such file or directory" for a lot of processes is normal because those are kernel threads.  

Also my script don't have to worry about bash dependency which causes exe produses shell path instead of executing fd path, since I noticed there are no single system process except custom process running depends on parent bash. And I also noticed all of this is ELF only.  

## Demonstration video (Click image to play at YouTube): ##

[![watch in youtube](https://i.ytimg.com/vi/dU1iM8Wu6OA/hqdefault.jpg)](https://www.youtube.com/watch?v=dU1iM8Wu6OA "ps brief")

