# ps_brief

> Ever felt overwhelmed by the countless processes running on your system?  
> Wondering what those cryptic processes are doing?  
> Fear not—this script is here to save the day!

Understand all running non-kernel processes with manual and package brief.  

This script lists all running processes along with their dpkg descriptions, process names, process IDs, file types, and manual summaries, and saves the output into a single file. The output file has a .c extension for improved readability, as it highlights syntax in color. The output filepath will be shown at the end of the result.

Processes belonging to the same package are grouped together for better organization.

This script should be run as root in a bash shell and supports only dpkg-based systems.

Note: The message "No such file or directory" for many processes is normal, as these refer to kernel threads.

## How to Run: ##
```bash
sudo bash ps_brief.sh
```

## Output Format: ##

[1] package name  
package manual(if exist)  
  
--- process executable  (file type)  
process manual 1(section) - manual brief  
process manual 2/3/...(section) - manual brief (if exist)  
prcoess id AND process full command  
  
--- process executable 2 (file type) (if exist)  
...cont.  
  
package description  
  
package link (if exist)  
package contact  
  
[2] package name 2  
...cont.  
  

## Demonstration video (Click image to play at YouTube): ##

[![watch in youtube](https://i.ytimg.com/vi/SBKv3_F8VwU/hqdefault.jpg)](https://www.youtube.com/watch?v=SBKv3_F8VwU "ps brief")

