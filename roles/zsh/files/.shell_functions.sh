# .shell_functions - Custom shell functions for convenience and system management

# Check if the shell is interactive
[[ $- != *i* ]] && return

function upgrade_system_packages {
    # Use a subshell (brackets) so 'set -e' and 'export' don't leak into your main session
    (
        set -e
        export DEBIAN_FRONTEND=noninteractive

        # Use -E to pass the environment through sudo
        sudo -E apt update
        sudo -E apt full-upgrade -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold"
        sudo -E apt autoremove --purge -y
        sudo -E apt autoclean

        if [ -f /var/run/reboot-required ]; then
            printf '\n\033[0;31m[!] A reboot is required to finish updates.\033[0m\n'
        fi
    )
}

# a locked-down firefox instance running inside a sandbox
function safefox {
    /usr/bin/firejail --name=safe-firefox --apparmor --seccomp --private --private-dev --private-tmp --protocol=inet firefox --new-instance --no-remote --safe-mode --private-window $1
}

function extract {
    if [ -z "$1" ]; then
        # display usage if no parameters given
        echo "Usage: extract <path/file_name>.<zip|rar|bz2|gz|tar|tbz2|tgz|Z|7z|xz|ex|tar.bz2|tar.gz|tar.xz>"
        echo "       extract <path/file_name_1.ext> [path/file_name_2.ext] [path/file_name_3.ext]"
    else
        for n in "$@"
        do
        if [ -f "$n" ] ; then
            case "${n%,}" in
              *.cbt|*.tar.bz2|*.tar.gz|*.tar.xz|*.tbz2|*.tgz|*.txz|*.tar)
                            tar xvf "$n"       ;;
              *.lzma)      unlzma ./"$n"      ;;
              *.bz2)       bunzip2 ./"$n"     ;;
              *.cbr|*.rar)       unrar x -ad ./"$n" ;;
              *.gz)        gunzip ./"$n"      ;;
              *.cbz|*.epub|*.zip)       unzip ./"$n"       ;;
              *.z)         uncompress ./"$n"  ;;
              *.7z|*.arj|*.cab|*.cb7|*.chm|*.deb|*.dmg|*.iso|*.lzh|*.msi|*.pkg|*.rpm|*.udf|*.wim|*.xar)
                            7z x ./"$n"        ;;
              *.xz)        unxz ./"$n"        ;;
              *.exe)       cabextract ./"$n"  ;;
              *.cpio)      cpio -id < ./"$n"  ;;
              *.cba|*.ace)      unace x ./"$n"      ;;
              *)
                            echo "ex: '$n' - unknown archive method"
                            return 1
                            ;;
            esac
        else
            echo "'$n' - file does not exist"
            return 1
        fi
        done
    fi
}
