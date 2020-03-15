{config, pkgs, ... }:

{
    home.packages = [
        pkgs.exa
        pkgs.direnv
        pkgs.rustup
        pkgs.oh-my-zsh
        pkgs.ripgrep
        pkgs.zsh-powerlevel10k
        pkgs.fastlane
        pkgs._1password
    ];

    xdg.configFile."direnv/direnvrc".text = ''
        #export DIRENV_LOG_FORMAT=""
    '';

    programs.ssh = {
        enable = true;

        extraOptionOverrides = {
            UseKeychain = "yes";
            ControlMaster = "auto";
            ControlPath =  "/tmp/ssh_mux_%h_%p_%r";
            ControlPersist = "60m";
        };
    };

    programs.direnv = {
        enable = true;
        enableZshIntegration = true;
    };

    programs.fzf = {
        enable = false;
        enableZshIntegration = false;
    };

    programs.zsh = {
        enable = true;
        dotDir = ".config/zsh";
        history = {
            expireDuplicatesFirst = true;
            ignoreDups = true;
            save = 10000;
            size = 10000;
            share = true;
        };

        localVariables = {
            POWERLEVEL9K_LEFT_PROMPT_ELEMENTS = ["os_icon" "dir" "vcs" "newline" "status"];
            POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS = ["direnv" "asdf" "pyenv" "rbenv" "nodenv" "nix_shell"];
            POWERLEVEL9K_SHOW_CHANGESET = false;
            POWERLEVEL9K_VCS_HIDE_TAGS = true;
            POWERLEVEL9K_MODE = "nerdfont-complete";
            POWERLEVEL9K_PROMPT_ON_NEWLINE = true;
            POWERLEVEL9K_RPROMPT_ON_NEWLINE = false;
            POWERLEVEL9K_STATUS_VERBOSE = true;
            POWERLEVEL9K_STATUS_CROSS = true;
            POWERLEVEL9K_PROMPT_ADD_NEWLINE = true;
        };

        initExtra = ''
            source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
        '';

        oh-my-zsh = {
            enable = false;
        };

        shellAliases = {
            gg = "git status -s";
            ls = "exa";
            ll = "ls -l";
            la = "ls -la";
            l = "ls -lh";
        };
    };

    programs.git = {
        enable = true;
        userEmail = "manfred.endres@tslarusso.de";
        userName = "Manfred Endres";
        signing.key = "EA3055E0";
        signing.signByDefault = true;
        lfs.enable = true;

        extraConfig = {
            url = {
                "git@github.com:" = {
                    insteadOf = "https://github.com/";
                };
            };

            core = {
                quotepath = false;
                autocrlf = "input";
                editor = "${pkgs.vim}/bin/vim";
                commitGraph = true;
            };

            user.useConfigOnly = true;
            push.default = "current";
            merge.tool = "opendiff";
            color.ui = "auto";
            rebase.autoStash = true;
            pull.rebase = true;
            tag.gpgsign = true;
        };

        ignores = [
            "*~"
            ".DS_Store"
            "atlassian-ide-plugin.xml"
            ".ant-targets-*.xml"
            "*.ipr"
            "*.iws"
            "*.sublime-project"
            "*.sublime-workspace"
            "*.iml"
            ".idea/"
            "auth.txt"
            "*.apk"
            "*.tar.gz"
        ];

        aliases = {
            "ci" = "commit";
            "st" = "status -s";
            "co" = "checkout";
            "fco" = "!git co $(git branch | fzf)";
            "lg" = "!\"git lg1\"";
            "graph" = "!\"git lg\"";
            "lg1" = "!sh -c \"git log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)' $*\"";
            "lg2" = "!sh -c \"git log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(reset) %C(bold green)(%ar)%C(reset)%C(bold yellow)%d%C(reset)%n''          %C(white)%s%C(reset) %C(dim white)- %an%C(reset)' $*\"";
            "lg3" = "!sh -c \"git log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(reset) %C(bold green)(%ar)%C(reset) %C(bold cyan)(committed: %cD)%C(reset) %C(bold yellow)%d%C(reset)%n''          %C(white)%s%C(reset)%n''          %C(dim white)- %an <%ae> %C(reset) %C(dim white)(committer: %cn <%ce>)%C(reset)' $*\"";
            "prune-all" = "!git remote | xargs -n 1 git remote prune";
            "prune-merged" = "!git branch -d $(git branch --merged)";

            "make-wooga" = "config user.email \"manfred.endres@wooga.net\"";
            "make-private" = "config user.email \"manfred.endres@tslarusso.de\"";

            "next" = "!git co $(git log master --reverse --ancestry-path HEAD..master --pretty=tformat:\"%H\" | head -1)";
            "prev" = "!git co $(git rev-list --first-parent --max-count=2 HEAD | tail -1)";

            "commend" = "commit --amend --no-edit";
            "fix-message" = "commit --amend --allow-empty";
            "last-commit" = "!sh -c \"git log -1 --pretty=tformat:\\\"%H\\\" --author=\\\"`git config user.name`\\\" $*\"";
        };
    };
}
