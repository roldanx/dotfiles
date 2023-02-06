# dotfiles

This repository is a personal backup for Linux OS files

## ZSH setup
* Install ZSH and make it default:

  `$ sudo apt install zsh`

  `$ chsh -s $(which zsh)`

* ZSH theme setup requires installing **powerline**

  `$ sudo apt install powerline`

* Clone Powerlevel10k theme:

  `$ git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k`

* Clone ZSH plugins respective repos:

  `$ git clone https://github.com/zsh-users/zsh-history-substring-search ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-history-substring-search`

  `$ git clone https://github.com/zsh-users/zsh-history-substring-search ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting`
