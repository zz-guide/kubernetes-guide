#!/usr/bin/env bash

string="Hello^MWorld^M!"
new_string=$(echo "$string" | tr -d '\r')
echo "原始字符串：$string"
echo "去除'^M'后的新字符串：$new_string"