# ps_brief
Understand all running non-kernel processes with manual and package brief.  

This script dump all running processes with dpkg description, process name, process id, filetype, manual brief, then saved into a single file. 

Processes in the same package will group together.   

You should run it as root in bash, i.e. sudo. Support only for dpkg-based systems.  

Note that "No such file or directory" for a lot of processes is normal because those are kernel threads.  

Also my script don't have to worry about bash dependency which causes exe produces shell path instead of executing fd path, since I noticed there are no single system process except custom process running depends on parent bash. And I also noticed all of this is ELF only.

## Format: ##

[1] package name  
package manual(if exist)  
  
--- process executable  (file type)  
process manual 1(section) - manual brief  
process manual 2/3/...(section) - manual brief (if exist)  
prcoess id AND process full command  
  
--- prcoess name 2 (file type) (if exist)  
...cont.  
  
package description  
  
package link (if exist)  
package contact  
  
[2] package name 2  
...cont.  
  

## Demonstration video (Click image to play at YouTube): ##

[![watch in youtube](https://i.ytimg.com/vi/dU1iM8Wu6OA/hqdefault.jpg)](https://www.youtube.com/watch?v=dU1iM8Wu6OA "ps brief")

