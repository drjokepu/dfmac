#!/bin/sh

set -e

PACKAGE_DF_VERSION="`cat dfversion`"
DF_VERSION=${DF_VERSION:-$PACKAGE_DF_VERSION}

DF_URL_FILENAME_VERSION=`echo $DF_VERSION | sed 's/^0\.//' | sed 's/\./_/'`
DF_URL="http://www.bay12games.com/dwarves/df_${DF_URL_FILENAME_VERSION}_osx.tar.bz2"

CURRENT_DIR="`pwd`"
BASE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
DF_DIR="${BASE_DIR}/df"
DF_ARCHIVE_FILENAME="${DF_URL##*/}"

function init_df_dir
{
	rm -rf "$DF_DIR"
	mkdir -p "$DF_DIR"
}

function get_df
{
	echo "Downloading: ${DF_URL}"
	cd "$DF_DIR"
	wget -q "http://www.bay12games.com/dwarves/df_42_05_osx.tar.bz2"
	echo "Extracting: ${DF_ARCHIVE_FILENAME}"
	tar xjf "$DF_ARCHIVE_FILENAME"
	rm -rf "$DF_ARCHIVE_FILENAME"
	cd "$BASE_DIR"
}

function prepare_df
{
	rm -rf "${DF_DIR}/libs"
	mkdir -p "${DF_DIR}/libs"
	ln "${DF_DIR}/df_osx/libs/libstdc++.6.dylib" "${DF_DIR}/libs/"
	ln "${DF_DIR}/df_osx/libs/libgcc_s.1.dylib" "${DF_DIR}/libs/"
	ln "${DF_DIR}/df_osx/libs/libfmodex.dylib" "${DF_DIR}/libs/"
	
	rm -rf "${DF_DIR}/Frameworks"
	mkdir -p "${DF_DIR}/Frameworks"
	cp -r "${DF_DIR}/df_osx/libs/SDL.Framework" "${DF_DIR}/Frameworks/"
	cp -r "${DF_DIR}/df_osx/libs/SDL_image.framework" "${DF_DIR}/Frameworks/"
	cp -r "${DF_DIR}/df_osx/libs/SDL_ttf.framework" "${DF_DIR}/Frameworks/"
	
	rm -rf "${DF_DIR}/init"
	mkdir -p "${DF_DIR}/init"
	
	cp -f "${DF_DIR}/df_osx/data/init/init.txt" "${DF_DIR}/init/init.txt"
    chmod -x "${DF_DIR}/init/init.txt"
	cp -f "${DF_DIR}/df_osx/data/init/d_init.txt" "${DF_DIR}/init/d_init.txt"
    chmod -x "${DF_DIR}/init/d_init.txt"
}

function build_dfhack
{
	cd "${BASE_DIR}/dfhack/build"
	sh ./build-osx.sh -e port "${DF_DIR}/df_osx"
	cd "$BASE_DIR"
	
    cp -f "${DF_DIR}/df_osx/dfhack.init-example" "${DF_DIR}/init/dfhack.init"
    chmod -x "${DF_DIR}/init/dfhack.init"
}

function set_mod
{
	find "${DF_DIR}/df_osx" -type f -perm +111 | sed 's/.*/"&"/' | xargs chmod -x
	chmod u+x "${DF_DIR}/df_osx/dwarfort.exe" "${DF_DIR}/df_osx/df" "${DF_DIR}/df_osx/dfhack"
}

function install_launch_script
{
    rm -f "${DF_DIR}/launch.sh"
    ln "${BASE_DIR}/dfmac/scripts/launch.sh" "${DF_DIR}/launch.sh" 
}

set -e
init_df_dir
get_df
prepare_df
build_dfhack
set_mod
install_launch_script
