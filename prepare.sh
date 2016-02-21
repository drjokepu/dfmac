#!/bin/bash

set -e

PACKAGE_DF_VERSION="`cat dfversion`"
DF_VERSION=${DF_VERSION:-$PACKAGE_DF_VERSION}

DF_URL_FILENAME_VERSION=`echo $DF_VERSION | sed 's/^0\.//' | sed 's/\./_/'`
DF_URL="https://dfmac.s3-eu-west-1.amazonaws.com/df/df_${DF_URL_FILENAME_VERSION}_osx.tar.bz2"

GEMSET_URL='https://dfmac.s3.amazonaws.com/graphics_sets/gemset/GemSet%201.41.zip'

CURRENT_DIR="`pwd`"
BASE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
DF_DIR="${BASE_DIR}/df"
DF_ARCHIVE_FILENAME="${DF_URL##*/}"

function init_df_dir
{
	rm -rf "$DF_DIR"
	mkdir -p "$DF_DIR"
}

function init_version_files
{
    init_df_version_file
    init_dfhack_version_file
}

function init_df_version_file
{
    echo -n "${DF_VERSION}" > "${DF_DIR}/dfversion"
}

function init_dfhack_version_file
{
    cd "${BASE_DIR}/dfhack"
    local DFHACK_VERSION=`git describe --tags`
    cd "${CURRENT_DIR}"
    echo -n "${DFHACK_VERSION}" > "${DF_DIR}/dfhackversion"
}

function get_df
{
	echo "Downloading: ${DF_URL}"
	cd "$DF_DIR"
	wget "${DF_URL}" 
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

function build_twbt
{
    cd "${BASE_DIR}/dfhack"
    local DFHACKVER="`git describe --tags`"

    cd "${BASE_DIR}/twbt"
    local TWBT_VER=`git describe --tags | sed 's/^v//'`
    local DF="${DF_DIR}/df_osx"
    local DH="${BASE_DIR}/dfhack"
    local GCC_TEMP="${BASE_DIR}/gcc_temp"
    rm -rf "${GCC_TEMP}"
    mkdir -p "${GCC_TEMP}"
    ln -s "`which g++`" "${GCC_TEMP}/g++-4.5"

    local DFHACK_LIB_DIR="${BASE_DIR}/dfhack/build/library"
    
    ln -s "${BASE_DIR}/dfhack/build-osx/library" "${DFHACK_LIB_DIR}"

    PATH="${PATH}:${GCC_TEMP}" TWBT_VER=${TWBT_VER} DF=${DF} DH=${DH} DFHACKVER=${DFHACKVER} make
    build_twbt_plugin mousequery
    build_twbt_plugin resume
    build_twbt_plugin automaterial

    rm -rf "${GCC_TEMP}" "${DFHACK_LIB_DIR}"
    cd "${CURRENT_DIR}"

    cp -f "${BASE_DIR}/twbt/dist/${DFHACKVER}/"*.dylib "${DF_DIR}/df_osx/hack/plugins"
    cp -f "${BASE_DIR}/twbt/dist/overrides.txt" "${DF_DIR}/df_osx/data/init"
    cp -f "${BASE_DIR}/twbt/dist/"*.png "${DF_DIR}/df_osx/data/art"
    cp -f "${BASE_DIR}/twbt/dist/"*.lua "${DF_DIR}/df_osx/hack/lua/plugins"
}

function build_twbt_plugin
{
    local PLUGIN="$1"
    cd plugins
    PATH="${PATH}:${GCC_TEMP}" TWBT_VER=${TWBT_VER} DF=${DF} DH=${DH} DFHACKVER=${DFHACKVER} PLUGIN=${PLUGIN} make
    cd ..
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

function get_graphics_sets
{
    mkdir -p "${DF_DIR}/graphics_sets"
    get_gemset
}

function get_gemset
{
    echo "Getting GemSet..."
    local GEMSET_DIR="${DF_DIR}/graphics_sets/gemset"
    mkdir -p "${GEMSET_DIR}"
    cd "${GEMSET_DIR}"
    wget -O gemset.zip "${GEMSET_URL}"
    unzip gemset.zip
    rm gemset.zip
    cd "${CURRENT_DIR}" 
}

#init_df_dir
#get_df
#prepare_df
#build_dfhack
build_twbt
#set_mod
#install_launch_script
#init_version_files
#get_graphics_sets
