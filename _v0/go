# shellcheck shell=sh disable=SC3043

proxy_go(){
    local op
    if [ $# -eq 0 ]; then
        op=help
    else
        case "$op" in
            -h|--help)      op=help ;;
            -v|--version)   op=version ;;
        esac
        op="$1"; shift
    fi

    case "$op" in
        help)                       ;;
        version)                    ;;
        auto|autoset)               proxy_go_auto ${1:+"$@"} ;;
        sum|sumdb|gosumdb|gosum)    proxy_go_gosumdb ${1:+"$@"} ;;
        set)                        proxy_go_set ${1:+"$@"} ;;
        unset)                      proxy_go_unset ${1:+"$@"} ;;
        service)                    proxy_go_service ${1:+"$@"} ;;
        tutorial)                   proxy_go_tutorial ${1:+"$@"} ;;
    esac
}


subcmd "
Subcommands:
    :auto|autoset                       Set the goproxy and gosumdb to recommended mirror
    :reset|reset                        Reet the download mirror
    :gosumdb|sumdb|sum|gosum <mirror>   operations for gosumdb
    :set                                Set the download mirror
    :service                            Provide mirror service in docker or native binary
    :version                            Show version
    :tutorial|xman                      Tutorial for setting goproxy                       
    :help                               Show help
"

proxy_go_auto(){
    if dig sh.x-cmd.com 2>/dev/null | grep gitee 2>/dev/null 1>dev/null; then
        proxy_go set aliyun
        proxy_go sum set qiniu
    else
        : Why
    fi
}

_proxy_go_set(){
    local url="${1:?URL}"
    local code

    case $(go version | awk '{ print substr($3, 3) }') in
        1.13*);;
        1.14*);;
        1.15*);;
        *) 
            code="
    export GOPROXY=$url
    export GO111MODULE=on
"
            eval "$code"
            printf "%s\n%s" "Seting the GORPOXY and GO111MODULE env with following code:" "$code" >&2
            return 0 ;;
    esac

    code="
    go env -w GO111MODULE=on
    go env -w GOPROXY="$url,direct"
"

    eval "$code"
    printf "%s\n%s" "Seting the GORPOXY and GO111MODULE env with following code:" "$code" >&2
}

proxy_go_set(){
    case "$1" in
        ali|aliyun)             _proxy_go_set    https://mirrors.aliyun.com/goproxy/ ;;
        goproxy|goproxy.cn)     _proxy_go_set    https://goproxy.io/zh/ ;;
        qiniu|io|goproxy.io)   _proxy_go_set    https://goproxy.cn ;;
        *) ;;
    esac
}

proxy_go_gosumdb(){
    if [ $# -eq 0 ]; then
        echo "$GOSUMDB"
    fi

    local op="$1"; shift

    case "$op" in
        set)                    gosumdb_set "$@" ;;
        unset|reset|clear)      gosumdb_unset "$@" ;;
        *)                      gosumdb_set "$op" "$@" ;;
    esac
}

proxy_go_gosumdb_set(){
    case "${1:gosum.io}" in
        qiniu|io|goproxoy.io)   _proxy_go_set    https://goproxy.cn ;;
        *)                      export GOSUMDB=gosum.io+ce6e7565+AY5qEHUk/qmHc5btzW45JVoENfazw8LielDsaI+lEbq6 ;;
    esac
}

proxy_go_gosumdb_unset(){
    export GOSUMDB=
}

# TODO: 
proxy_go_unset(){
    local url="${1:?URL}"

    case $(go version | awk '{ print substr($3, 3) }') in
        1.13*);;
        1.14*);;
        1.15*);;
        *) 
            code="
    export GOPROXY=
"
            eval "$code"
            printf "Unset the GOPROXY env." >&2
            return 0 ;;
    esac

    code="
    go env -u GOPROXY
"

    eval "$code"
    printf "Unset the GOPROXY env." >&2
}

# help doc: https://goproxy.io/zh/docs/enterprise.html
proxy_go_service(){
    if docker ps >/dev/null 2>&1; then
        docker run -d -p80:8081 goproxy/goproxy "$@"
    elif :; then
        : Build directly.
    else
        # Just download the exe file.
        ./bin/goproxy -listen=0.0.0.0:80 -cacheDir=/tmp/test -proxy https://goproxy.io -exclude "git.corp.example.com,rsc.io/private"
    fi
}

proxy_go_tutorial(){
    cat <<AAA
Windows Powershell:

Format: \$env:GOPROXY = <url>

Example:
\$env:GOPROXY = "https://goproxy.cn"

Windows:

1. 右键 我的电脑 -> 属性 -> 高级系统设置 -> 环境变量
2. 在 “[你的用户名]的用户变量” 中点击 ”新建“ 按钮
3. 在 “变量名” 输入框并新增 “GOPROXY”
4. 在对应的 “变量值” 输入框中新增 “https://goproxy.io,direct”
5. 最后点击 “确定” 按钮保存设置    
AAA

}


