#!/bin/bash
#Please run it as `sudo bash ps_brief`, sudo required to read a lot processes
#You may edit $f, $ext, and $skip_f to your desired output filename, extension(to get pretty syntax highlight), and log.
#1st part: For every package name related to the valid process files, the next line will shows its man, if any.
#2nd part: --- process filename and the next line will shows its man, if any
#3rd part: The last part will be package's description, home page, and maintainer contact.
f=~/Downloads/mybin_ps_jan_22_2018;
ext='.c'
now="$(date '+%Y_%m_%d_%H:%M:%S')"
#keep in mind since sudo and non-sudo may run this, so once you output to root file, you can't output to the same root file as non-root, so I use datetime to make the file unique.
f="$f"_"$now""$ext"
skip_f='/tmp/skip_processes_'"$now"'.log'
if [ -f "$f" ]; then rm "$f"; fi
if [ -f "$skip_f" ]; then rm "$f"; fi
echo 'Start calculating total, please to be patient...';
#total=0; while IFS='' read -r fn; do  fn="$(dpkg -S "$fn" 2>> "$skip_f")"; if [ -z "$fn" ]; then continue; fi; ((total++)); done < <(readlink -f /proc/*/exe 2>>"$skip_f" | sort | uniq)
arr=()
arri=()
#better use pgrep since keep arry with sort+uniq+pid more complicated #while IFS='' read -r r; do readlink -f "/proc/$r/exe" && echo $r; done < <(find /proc/ -maxdepth 1 -type d -iregex '/proc/[0-9]+$' -exec basename {} \;)
#readlink nid -v to report permission denied OR No such file or directory
total=0; ti=0; while IFS='' read -r fn; do fn="$(dpkg -S "$fn" 2>> "$skip_f")"; ((ti++)); echo "[$ti] Checking... $fn"; if [ -z "$fn" ]; then continue; fi; arr+=("$fn"); ((total++)); done < <(readlink -v -f /proc/*/exe 2>>"$skip_f" | sort | uniq)
total=${#arr[@]}
fn='';
pkgn='';
n=0;
gn=0;
contains_space=" ";

#dpkg -S produces such special cases output line(s)
#... , only case #2 supported, the rest will ignore and shows 'multi-packages not supported...':
#Special case 1(,): libgl1-mesa-dri:i386, libgl1-mesa-dri:amd64: /etc/drirc
#Special case 2(:): libmagic1:amd64: /etc/magic
#Special case 3: diversion by parallel from: /usr/bin/parallel
#Special case 4: diversion by parallel to: /usr/bin/parallel.moreutils
#Special case 5: parallel, moreutils: /usr/bin/parallel


#while IFS='' read -r f; do echo ----- "$f" -----; dpkg-query -W -f='${Description}\n\n${Homepage}\nMaintainer: ${Maintainer}\n\n' "$(basename "$(dirname "$f")")"; done < <(readlink -f /proc/*/exe)

#find "$d" -maxdepth 1 -name '*parallel*' -type f -exec dpkg -S {} + 2> /dev/null | sort | #if want test custom name #2
#find "$d" -maxdepth 1 -type f -exec dpkg -S {} + 2> /dev/null | sort |
#readlink -f /proc/*/exe 2>/dev/null | sort | uniq | 
	#while IFS='' read -r fn; do
    for i in ${!arr[@]}; do
        fn="${arr[i]}";
        orig_f="$fn";
        if [ -z "$fn" ]; then continue; fi;
		((pgn=gn+1));
		echo "[$pgn/$total] Parsing... $fn";
        ((gn++));
        pkgbp="$(echo -n $fn | cut -f2- -d' ' | awk '{$1=$1}1')"; #awk to strip leading path spaces
        
        if [[ "$(echo $fn | cut -d':' -f1)" =~ $contains_space ]]; then
            echo 'multi-packages not supported.';
        elif [[ "$pkgbp" =~ $contains_space ]]; then
            echo 'multi-packages or path contains space not supported.';
        else 
            pkgp="$pkgn";
            pkgn="$(echo $fn | cut -f1 -d' ')";
            pkgn="$(echo ${pkgn%:})"; #trim trailing :
            pkgn="$(echo ${pkgn%,})"; #trim trailing ,
            pkgb="$(basename $pkgbp)"
            if [ "$pkgp" == "$pkgn" ]; then
                echo -en "\n--- $pkgb" >> "$f";
                ft="$(file -n -b -e elf $pkgbp)";
                if [ "${ft#a }" != "${ft}" ]; then #some files return something like 'a /usr/bin/python script', nid split by ',' for this case.
                    ft="$(echo "$ft" | cut -d',' -f1)"
                else #to reduce noise, all split by space and shows 1st word only.
                    ft="$(echo "$ft" | cut -d' ' -f1)"
                fi;
                echo -e "\t\t($ft)" >> "$f";
                man -f "$pkgb" 2>/dev/null >> "$f";
                #must combine both -f + fullpath AND -f + basename, otherwise some processes not able to pgrep
                { pgrep -f "$pkgbp"; pgrep -f "$pkgb"; } | uniq | sort -n | while IFS='' read -r pi; do echo -n "$pi " >> "$f"; cat "/proc/$pi/cmdline" | tr '\0' ' ' >> "$f"; echo >> "$f"; done
                if [ "$total" == "$gn" ]; then
                    echo -en '\n\n\t\t\t\t' >> "$f";
                    dpkg-query -W -f='${Description}\n\n${Homepage}\nMaintainer: ${Maintainer}\n\n' "$pkgp" >>"$f";
                    echo >> "$f";
                fi;
                continue;
            fi;
            if [ "$n" != 0 ]; then
                echo -en '\n\n\t\t\t\t' >> "$f";
                dpkg-query -W -f='${Description}\n\n${Homepage}\nMaintainer: ${Maintainer}\n\n' "$pkgp" >>"$f";
                echo >> "$f";
            fi;
            ((n++));
            echo -n "[$n] " >> "$f";
            echo "$pkgn" >> "$f";
            man -f "$pkgn" 2>/dev/null >> "$f";
            echo -en "\n--- $pkgb" >> "$f";
            ft="$(file -n -b -e elf $pkgbp)";
            if [ "${ft#a }" != "${ft}" ]; then
                ft="$(echo "$ft" | cut -d',' -f1)"
            else
                ft="$(echo "$ft" | cut -d' ' -f1)"
            fi;
            echo -e "\t\t($ft)" >> "$f";
            man -f "$pkgb" 2>/dev/null >> "$f";
            { pgrep -f "$pkgbp"; pgrep -f "$pkgb"; } | uniq | sort -n | while IFS='' read -r pi; do echo -n "$pi " >> "$f"; cat "/proc/$pi/cmdline" | tr '\0' ' ' >> "$f"; echo >> "$f"; done
            if [ "$total" == "$gn" ]; then
                echo -en '\n\n\t\t\t\t' >> "$f";
                dpkg-query -W -f='${Description}\n\n${Homepage}\nMaintainer: ${Maintainer}\n\n' "$pkgn" >>"$f";
                echo >> "$f";
            fi;
        fi;
	done;
echo "Skipped Log:"
cat "$skip_f" 2>/dev/null
if [ ! -f "$f" ]; then
	echo "Sorry, no file has brief";
else echo "Done ... Please check your file $f";
fi

