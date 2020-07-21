#!/bin/bash

# --- Generates bckg.cache file using genrand.py ---

currDay=$(expr `date +%s` / 86400) # days since Unix Epoch (1 January 1970)
currDir=`dirname "$0"` # this script's directory (not necessarily working directory)
cacheDir="$currDir/../cache" # cache directory
bckgCache="$cacheDir/bckg.cache" # bckg.cache file

if [ ! -f $bckgCache ]
then
    echo "Creating $bckgCache and parent directories..."
    mkdir -p $cacheDir
    touch $bckgCache
    bckgCacheLines=`cat $bckgCache | wc -l`
else
    bckgCacheLines=`cat $bckgCache | wc -l`

    if [[ `sed -n 7p $bckgCache` == *`date +%x`* ]]
    then
        exit
    fi
fi


background=`python $currDir/genrand.py $currDay`

attempts=1
while [[ "BACKGROUND      $background" == `sed -n 5p $bckgCache` ]]
do
    attempts=`expr $attempts + 1`
    background=$(python $currDir/genrand.py `expr $currDay \* $attempts`)
done

echo -e "This file is auto-generated daily by Slideday.
Messing with it probably won't cause damage,
but it is not recommended.\n" > $bckgCache
echo "BACKGROUND      $background" >> $bckgCache
echo "ATTEMPTS        $attempts" >> $bckgCache
echo "DATE            `date +%x`" >> $bckgCache

echo $background
