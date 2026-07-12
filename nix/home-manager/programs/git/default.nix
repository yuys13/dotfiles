{ pkgs, ... }:
{
  programs.git = {
    enable = true;
    ignores = [
      # macOS.gitignore
      # General
      ".DS_Store"
      ".localized"
      "__MACOSX/"
      ".AppleDouble"
      ".LSOverride"
      "Icon[\r]"

      # Resource forks
      "._*"

      # Files and directories that might appear in the root of a volume
      ".DocumentRevisions-V100"
      ".fseventsd"
      ".Spotlight-V100"
      ".TemporaryItems"
      ".Trashes"
      ".VolumeIcon.icns"
      ".com.apple.timemachine.donotpresent"
      ".com.apple.timemachine.supported"
      ".PKInstallSandboxManager"
      ".PKInstallSandboxManager-SystemSoftware"
      ".hotfiles.btree"
      ".vol"
      ".file"
      ".disk_label*"
      "lost+found"
      ".HFS+ Private Directory Data[\r]"

      # Directories potentially created on remote AFP share
      ".AppleDB"
      ".AppleDesktop"
      "Network Trash Folder"
      "Temporary Items"
      ".apdisk"

      # Mac OS 6 to 9
      "Desktop DB"
      "Desktop DF"
      "TheFindByContentFolder"
      "TheVolumeSettingsFolder"
      ".FBCIndex"
      ".FBCSemaphoreFile"
      ".FBCLockFolder"

      # Quota system
      ".quota.group"
      ".quota.user"
      ".quota.ops.group"
      ".quota.ops.user"

      # TimeMachine
      "Backups.backupdb"
      ".MobileBackups"
      ".MobileBackups.trash"
      "MobileBackups.trash"
      "tmbootpicker.efi"

      # Windows.gitignore
      # Windows thumbnail cache files
      "Thumbs.db"
      "Thumbs.db:encryptable"
      "ehthumbs.db"
      "ehthumbs_vista.db"

      # Dump file
      "*.stackdump"

      # Folder config file
      "[Dd]esktop.ini"

      # Recycle Bin used on file shares
      "$RECYCLE.BIN/"

      # Windows Installer files
      "*.cab"
      "*.msi"
      "*.msix"
      "*.msm"
      "*.msp"

      # Windows shortcuts
      "*.lnk"

      # neovim
      ".nvim.lua"
      ".nvimrc"
      ".exrc"
    ];
    settings = {
      user = {
        name = "yuys13";
        email = "yuys13@users.noreply.github.com";
      };
      init = {
        defaultbranch = "main";
      };
      commit = {
        verbose = true;
      };
      push = {
        default = "simple";
        autoSetupRemote = true;
        useForceIfIncludes = true;
      };
      pull = {
        ff = "only";
      };
      rebase = {
        autoStash = true;
        autoSquash = true;
      };
      diff = {
        tool = "nvimdiff";
      };
      difftool = {
        trustExitCode = true;
      };
      merge = {
        tool = "nvimdiff";
      };
      mergetool = {
        "vimdiff".trustExitCode = true;
        "nvimdiff".trustExitCode = true;
      };
      blame = {
        markIgnoredLines = true;
      };
    };
  };
}
