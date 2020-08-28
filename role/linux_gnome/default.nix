{ config, lib, pkgs, attrsets, ... }:
{
    nixpkgs.config.allowUnfree = true;

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
            export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
            gpgconf --launch gpg-agent
            gpg-connect-agent updatestartuptty /bye
        '';
    };

    home.file.".gnupg/gpg-agent.conf".text = ''
        enable-ssh-support
        default-cache-ttl 600
        max-cache-ttl 7200
        pinentry-program ${pkgs.pinentry-gnome}/bin/pinentry
    '';
}
