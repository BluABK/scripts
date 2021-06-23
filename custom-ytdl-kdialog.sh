#!/bin/bash
downloader="/usr/bin/youtube-dl"
download_dir="~/Downloads/YouTube/"
notifier="/usr/bin/kdialog --passivepopup"
output_template="%(uploader)s_-_%(upload_date)s_-_%(title)s_-_v-id-%(id)s.%(ext)s"
opts="--merge-output-format mkv --sub-format \"ass/srt/best\" --sub-lang en --embed-subs --add-metadata --mark-watched -o $output_template"

id=$(echo "$@" | cut -d ':' -f 2)
url="https://www.youtube.com/watch?v=$id"

cd $download_dir
title=$($downloader --get-title $id)
echo "Sending download notification..."
$notifier "Downloading $title [$id]..." &

echo "Downloading video..."
$downloader $opts $url

echo "Determining output filename..."
filename=$($downloader --merge-output-format mkv --get-filename -o $output_template $url)

echo "Replacing whitespace placeholders with actual whitespace..."
file-rename -v 's/_/ /gm' "$filename"

echo "Determining renamed filename..."
filename=$(echo "$filename" | sed -e 's/_/ /gm')

echo "Reformatting upload datestamp..."
file-rename -v 's/(\d{4})(0)?((?(2)\d|\d\d))(0)?((?(4)\d|\d\d))/$1-$2$3-$4$5/' "$filename"
