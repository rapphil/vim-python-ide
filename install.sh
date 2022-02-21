#!/bin/bash

VIM_VERSION="v8.2.0007"
CURDIR=${PWD}
CPUS=$(grep -c ^processor /proc/cpuinfo)

read -p "Please backup your .vimrc file and .vim directory before starting. Press [Enter] to continue."

git clone --branch $VIM_VERSION https://github.com/vim/vim.git /tmp/vim-build/
cd /tmp/vim-build

./configure --prefix=${HOME}/tools/vim --with-features=huge --enable-multibyte --enable-pythoninterp=yes --enable-python3interp=yes

make -j $CPUS && make install

pip2 install --user rope jedi ropevim flake8

UPDATE_PATH='export PATH=${HOME}/tools/vim/bin:$PATH'

export PATH=${HOME}/tools/vim/bin:$PATH

if grep -qF "$UPDATE_PATH" ${HOME}/.bashrc; then
	echo "Not updating bashrc"
else
	echo "$UPDATE_PATH"  >> ${HOME}/.bashrc
fi

curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
	    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

vim -u ${CURDIR}/plugins +PlugInstall! +qall!
# No touchy my vimrc
# cat ${CURDIR}/plugins ${CURDIR}/configs > ${HOME}/.vimrc
