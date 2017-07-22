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
git clone https://github.com/yuys13/dotfiles ${HOME}/
cd ${HOME}/dotfiles
make install
```

### Only use dotfiles

#### Automatically

```console
bash -c "$(curl -fsSL https://raw.githubusercontent.com/yuys13/dotfiles/master/bin/deploy.sh)"
```

#### Manually

```console
git clone https://github.com/yuys13/dotfiles ${HOME}/
cd ${HOME}/dotfiles
make link
```

or

```console
cd ${HOME}
curl -L -O https://github.com/yuys13/dotfiles/archive/master.zip
unzip master.zip
rm master.zip
mv dotfiles-master dotfiles
cd ${HOME}/dotfiles
make link
```

