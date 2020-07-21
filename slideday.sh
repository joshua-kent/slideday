#!/bin/bash

# -----------------------
# --- Slideday v1.0.0 ---
# -----------------------
#
# This chooses a new wallpaper every day (but never the same one twice in a row!).


outputDir="/tmp/slideday" # stdout gets dumped in this temporary file
currDay=$(expr `date +%s` / 86400) # days since Unix Epoch (1 January 1970)
currDir=`dirname "$0"` # current directory of script (not current working directory)
cacheDir="$currDir/cache" # cache directory
backgroundsDir="$currDir/backgrounds" # backgrounds directory
bckgCache="$cacheDir/bckg.cache" # background cache file
gencache="$currDir/src/gencache.sh" # generate cache file bash script

echo "`date +%x` at `date +%T` | Starting..." >> $outputDir



# --- Get the last background (from bckg.cache) if it exists and its date ---
# --- If the bckg.cache file does not exist, then create it with gencache.sh ---
# --- (bckg.cache stores the last background used, and the day it was last changed) --

sh $gencache > $outputDir # update cache
backgroundLine=`sed -n 5p $bckgCache`
background=${backgroundLine:16} # truncate line 5 of bckg.cache (looks like: BACKGROUND     example.jpg)
background="$backgroundsDir/$background" # add the directory to background variable (it is not included in bckg.cache)



# --- Apply the wallpaper ---

echo "`date +%x` at `date +%T` | Applying background: $background" >> $outputDir
nitrogen --set-zoom-fill $background



# --- Check for new day every 60 seconds ---


# --- Make sure it will update at least 1 second after a new minute ---
if [ `date +%S` != "01" ] # at least one second offset (in case it is too quick for the time to update)
then
    restore_sync=$(expr 60 - `date +%S` + 1) # one second offset again

    echo "`date +%x` at `date +%T` | Waiting for $restore_sync seconds..." >> $outputDir
    sleep $restore_sync
    echo "`date +%x` at `date +%T` | Done." >> $outputDir
fi

while true
do
    realtimeDay=$(expr `date +%s` / 86400) # get current day (86400 seconds in a day)
    
    if [ $realtimeDay != $currDay ] # check if it is different to the day at the start of the script
    then
        echo "`date +%x` at `date +%T` | New day!" >> $outputDir
        nohup sh `dirname "$0"`/`basename "$0"` >> $outputDir & # re-run this script again
        exit
    fi

    echo "`date +%x` at `date +%T` | Waiting for 60 seconds..." >> $outputDir
    sleep 60
    echo "`date +%x` at `date +%T` | Cycling script..." >> $outputDir
done
