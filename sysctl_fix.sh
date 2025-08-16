#!/bin/bash

# sysctl 명령어를 가짜로 만들어서 Flutter가 동작하도록 함
if [ "$1" = "-n" ] && [ "$2" = "hw.optional.arm64" ]; then
    echo "1"
    exit 0
fi

# 다른 경우에는 실제 sysctl 호출 (있다면)
if command -v /usr/sbin/sysctl >/dev/null 2>&1; then
    /usr/sbin/sysctl "$@"
else
    echo ""
    exit 1
fi