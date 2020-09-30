{ config, lib, pkgs, attrsets, ... }:
{
    nixpkgs.config.allowUnfree = true;

    home.packages = [
        pkgs.socat
    ];

    programs.gpg = {
        enable = true;
        settings = {
            keyserver = "hkps://keys.openpgp.org";
            auto-key-locate = "keyserver";
            auto-key-retrieve = true;
            no-emit-version = true;
        };
    };

    programs.zsh = {
        initExtra = ''
            #####
            ## Autorun for the gpg-relay bridge
            ##
            SOCAT_PID_FILE=$HOME/.cache/socat-gpg.pid

            if [[ -f $SOCAT_PID_FILE ]] && kill -0 $(cat $SOCAT_PID_FILE); then
                : # already running
            else
                rm -f "$HOME/.gnupg/S.gpg-agent"
                (trap "rm $SOCAT_PID_FILE" EXIT; ${pkgs.socat}/bin/socat UNIX-LISTEN:"$HOME/.gnupg/S.gpg-agent,fork" EXEC:'/mnt/c/ubuntu/npiperelay/npiperelay.exe -ei -ep -s -a "C:/Users/Larusso/AppData/Roaming/gnupg/S.gpg-agent"',nofork </dev/null &>/dev/null) &
                echo $! >$SOCAT_PID_FILE
            fi

            #####
            ## Autorun for the gpg-ssh-agent-relay bridge
            ##
            SOCAT_SSH_PID_FILE=$HOME/.misc/socat-ssh.pid

            if [[ -f $SOCAT_SSH_PID_FILE ]] && kill -0 $(cat $SOCAT_SSH_PID_FILE); then
                : # already running
            else
                rm -f "$HOME/.gnupg/S.gpg-agent"
                (trap "rm $SOCAT_SSH_PID_FILE" EXIT; ${pkgs.socat}/bin/socat UNIX-LISTEN:"/mnt/c/ubuntu/wsl-ssh-pageant/ssh-agent.sock,fork,unlink-close,unlink-early" EXEC:"/mnt/c/ubuntu/npiperelay/npiperelay.exe /\/\./\pipe/\ssh-pageant",nofork </dev/null &>/dev/null) &
                echo $! >$SOCAT_SSH_PID_FILE
            fi
            export SSH_AUTH_SOCK=/mnt/c/ubuntu/wsl-ssh-pageant/ssh-agent.sock
        '';
    };

    home.file.".gnupg/gpg-agent.conf".text = ''
        enable-ssh-support
        default-cache-ttl 600
        max-cache-ttl 7200
        pinentry-program ${pkgs.pinentry-qt}/bin/pinentry-qt
    '';
}
