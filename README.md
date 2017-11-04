# dotfiles
I :heart: zsh

## Usage

### Installation

#### Automatically

```console
bash -c "$(curl -fsSL https://raw.githubusercontent.com/yuys13/dotfiles/master/bin/setup.sh)"
```

#### Manually

```console
git clone https://github.com/yuys13/dotfiles ${HOME}/dev/src/github.com/yuys13/dotfiles
cd ${HOME}/dev/src/github.com/yuys13/dotfiles
make install
```

### Only use dotfiles

#### Automatically

```console
bash -c "$(curl -fsSL https://raw.githubusercontent.com/yuys13/dotfiles/master/bin/deploy.sh)"
```

#### Manually

```console
git clone https://github.com/yuys13/dotfiles ${HOME}/dev/src/github.com/yuys13/dotfiles
cd ${HOME}/dev/src/github.com/yuys13/dotfiles
make link
```

