#!/bin/bash

# 清空或创建 userCode.txt
> userCode.txt

# 查找所有 .go 文件并处理
find "$PWD" -type f -name "*.go" | while read -r file; do
    echo "##################################################" >> userCode.txt
    echo "# FILE: $file" >> userCode.txt
    echo "##################################################" >> userCode.txt
    cat "$file" >> userCode.txt
    echo -e "\n\n" >> userCode.txt
done