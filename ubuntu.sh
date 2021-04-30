# shellcheck shell=bash

# TODO: get ubuntu versio

proxy_apt_ubuntu_generate(){
    local url="${1:?url}"
    cat <<A
deb $url/ubuntu/ bionic main restricted universe multiverse
deb $url/ubuntu/ bionic-security main restricted universe multiverse
deb $url/ubuntu/ bionic-updates main restricted universe multiverse
deb $url/ubuntu/ bionic-proposed main restricted universe multiverse
deb $url/ubuntu/ bionic-backports main restricted universe multiverse
deb-src $url/ubuntu/ bionic main restricted universe multiverse
deb-src $url/ubuntu/ bionic-security main restricted universe multiverse
deb-src $url/ubuntu/ bionic-updates main restricted universe multiverse
deb-src $url/ubuntu/ bionic-proposed main restricted universe multiverse
deb-src $url/ubuntu/ bionic-backports main restricted universe multiverse
A

}


setup.apt.src(){
    # TODO: Add whether backup
    
    local s=${1:-ali}
    s="$(echo "$s" | tr "[:upper:]" "[:lower:]")"
    local CONTENT=""
    case "$s" in
        ali) CONTENT=$(proxy_apt_ubuntu_generate "https://mirrors.aliyun.com/")
            ;;
    esac

    local SRC_FP BAK_FP
    SRC_FP=/etc/apt/sources.list
    BAK_FP="$SRC_FP.$(date +%Y%M%d_%0H%m%S).bak"
    echo "Backing up $SRC_FP to $BAK_FP"
    cp $SRC_FP "$BAK_FP" && \
    (
        echo "$CONTENT"
        echo ""
        cat "$BAK_FP"
    ) > $SRC_FP
}

setup.apt.src "$*"

