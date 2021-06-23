#!/bin/bash

# Determine my current dir (src: https://stackoverflow.com/a/246128/13519872).
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"


# Load config.
. $DIR/.config/series-letters.cfg

echo "paths: ${series_dirs[@]}"

for dir in ${series_dirs[@]}
do
    # Alphabetically sorted names.
    names=$(ls $dir | sort -h)

    # Loop through until you hit the first directory, in case of files.
    dirs=()
    for item in ${names[@]}
    do
        if [[ -d "$item" ]]; then
            # Append the directory (not path) to array.
            echo "dirs+=$item"
            dirs+=$(echo $item | rev | cut -d '/' -f 1 | rev)
        fi
    done

    # Verify that directory list is not empty.
    if [[ ${#dirs[@]} -eq 0 ]]; then
        echo "ERROR: No valid dirs in $dir, SKIPPING!"
        return
    fi
    # Verify that we actually got a valid directory.
    # if [[ -z ${item+x} ]]; then
    #     echo "ERROR: No valid dirs in $dir, SKIPPING!"
    #     return
    # fi

    echo -e "Directories:\n${dirs[@]}"
    
    # Get the first letter:
    first_name=${dirs[0]}
    echo "first name: $first_name"
    first_letter=${first_name:0:1}
    echo "first letter: $first_letter"
    echo -e "dir: $dir:\t"
done


