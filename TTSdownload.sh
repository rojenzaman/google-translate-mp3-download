#!/bin/bash

. bin/urlencode.sh #import urlencode

function guide() {
echo -e "\nusage: ./`basename $0` [-l <lang-code> ]  [-f <file-name>  |  -t \"write some text to here\" <-o> ]"
echo "-l      set language code"
echo "-f      give a file for input"
echo "-t      give a string for input, if you want to listen to the generated file, give the -o argument"

echo -e "\nexample:"
echo -e "./`basename $0` -l en -t \"Hello World!\"\n"
}


function forFile() {
while IFS='' read -r line || [[ -n "$line" ]]; do
    words=$(echo $line | tr "," "\n")
    echo "$words"
    for word in $words
    do
      	echo "> [$word]"
        url="https://translate.google.com/translate_tts?ie=UTF-8&total=1&idx=0&textlen=${#word}&client=tw-ob&q=$word&tl=$langCode"
        echo $url
        wget -q -U Mozilla -O tmp/$word.mp3 $url
    done
echo "for outputs look tmp folder"
done < "$fileName"
exit 0
}


function forArgument() {
   savedFile=$(cat /dev/urandom | tr -dc 'a-e0-9' | fold -w 8 | head -n 1)
   echo "> [$String]"
   urlString=$(urlencode "$String")
   url="https://translate.google.com/translate_tts?ie=UTF-8&total=1&idx=0&textlen=${#word}&client=tw-ob&q=$urlString&tl=$langCode"
   echo $url
   wget -q -U Mozilla -O tmp/$savedFile.mp3 $url
   echo "look tmp/$savedFile.mp3 file"
}

while getopts ":l:f:t:op" opt; do
  case ${opt} in
    l )
      langCode=${OPTARG};
      ;;
    f )
      fileName=${OPTARG};
      forFile
      ;;
    t )
      String=${OPTARG};
      forArgument
      ;;
    o )
      xdg-open tmp/$savedFile.mp3
      ;;
    p )
      rm -rf var/mp3/* tmp/* >/dev/null
      ;;
    : )
      echo "Missing option argument for -$OPTARG"
      exit 0
      ;;
  esac
done


if [ "$#" -lt 1 ]; then
    guide
    exit 0
fi
