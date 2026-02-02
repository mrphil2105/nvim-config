{ ... }:
{
  programs.git.enable = true;
  programs.git.settings = {
    user.name = "Philip Mørch";
    user.email = "mrphil2105@gmail.com";
    init.defaultBranch = "main";
    pull.rebase = true;
    merge.ff = false;
  };
  programs.lazygit.enable = true;
  programs.lazygit.settings = {
    git.autoForwardBranches = "none";
    git.autoFetch = false;
    git.autoStageResolvedConflicts = false;
  };
}
