#!/bin/bash

# Slideday v1.0.0
# This chooses a new wallpaper every day.

outputDir="/tmp/slideday"
currDay=$(expr `date +%s` / 86400) # days since Unix Epoch (1 January 1970)
currDir=`dirname "$0"`
cacheDir="$currDir/cache"
backgroundsDir="$currDir/backgrounds"
bckgCache="$cacheDir/bckg.cache"
gencache="$currDir/src/gencache.sh"

echo "`date +%x` at `date +%T` | Starting..." >> $outputDir

if [ -f $bckgCache ]
then
    lupCache=`sed -n 7p $bckgCache`
    if [[ $lupCache =~ `date +%x` ]]
    then
        backgroundLine=`sed -n 5p $bckgCache`
        background=${backgroundLine:16}
    else
        sh $gencache
        nohup sh `dirname "$0"`/`basename "$0"` >> /tmp/slideday & # re-run this script again
        exit
    fi
else
    sh $gencache
    nohup sh `dirname "$0"`/`basename "$0"` >> /tmp/slideday & # re-run this script again
    exit
fi

background="$backgroundsDir/$background"
echo "`date +%x` at `date +%T` | Applying background: $background" >> $outputDir
nitrogen --set-zoom-fill $background

if [ `date +%S` != "01" ] # at least one second offset (in case it is too quick for the time to update)
then
    # this is to make sure that when it is a new day,
    # it should change almost exactly on that point (synchronises the time
    # it checks for a new day with the change in minute)

    restore_sync=$(expr 60 - `date +%S` + 1) # one second offset again
    echo "`date +%x` at `date +%T` | Waiting for $restore_sync seconds..." >> $outputDir
    sleep $restore_sync
    echo "`date +%x` at `date +%T` | Done." >> $outputDir
fi

while true
do
    newDay=$(expr `date +%s` / 86400)
    
    if [ $newDay != $currDay ]
    then
        echo "`date +%x` at `date +%T` | New day!" >> $outputDir
        nohup sh `dirname "$0"`/`basename "$0"` >> $outputDir & # re-run this script again
        exit
    fi

    echo "`date +%x` at `date +%T` | Waiting for 60 seconds..." >> $outputDir
    sleep 60
    echo "`date +%x` at `date +%T` | Cycling for 60 seconds..." >> $outputDir
done
