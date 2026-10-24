# Mac Bootstrap

Bootstrap a Mac with Chezmoi and the dotfiles repository.

```sh
curl -fsSL https://raw.githubusercontent.com/404ALegend/mac-start/main/bootstrap-mac.sh | sh
```

## Override

Set `CHEZMOI_REPO_URL` to use a different dotfiles repository.

```sh
curl -fsSL https://raw.githubusercontent.com/404ALegend/mac-start/main/bootstrap-mac.sh \
  | CHEZMOI_REPO_URL=https://github.com/404ALegend/mac-dots.git sh
```
