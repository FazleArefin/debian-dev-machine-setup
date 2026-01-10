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

