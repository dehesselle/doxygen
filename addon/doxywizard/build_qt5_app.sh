#!/usr/bin/env bash
#
# https://github.com/dehesselle/doxygen
#
# This script builds the DoxyWizard app for macOS using the latest Qt.
# Created on macOS 10.14.3 using Qt 5.12.1.
#
# - This script uses gnu coreutils. ('brew install coreutils')
# - Xapian is required to build Doxygen. ('brew install xapian')

# --- setup repository and Qt directories
QT5_BIN_DIR=/opt/Qt/5.12.1/clang_64/bin
export PATH=$PATH:$QT5_BIN_DIR
DOXYWIZARD_DIR=$(dirname $(greadlink -f $0))
DOXYGEN_DIR=$DOXYWIZARD_DIR/../..

# --- create temporary workspace
RAMDISK_VOL=WORKSPACE
diskutil erasevolume HFS+ "$RAMDISK_VOL" $(hdiutil attach -nomount ram://524288)
WORK_DIR=/Volumes/$RAMDISK_VOL

# --- build doxywizard
BUILD_DIR=$WORK_DIR/build
mkdir $BUILD_DIR; cd $BUILD_DIR
cmake -Dbuild_wizard=ON -Dbuild_search=ON $DOXYGEN_DIR
make

# --- build Qt template app
cp -R $DOXYWIZARD_DIR/template_app $WORK_DIR
cd $WORK_DIR/template_app
qmake -makefile DoxyWizard.pro
make
macdeployqt DoxyWizard.app
DOXYWIZARD_APP=$WORK_DIR/template_app/DoxyWizard.app

# --- copy binaries and resources to template app
cp $BUILD_DIR/bin/doxywizard       $DOXYWIZARD_APP/Contents/MacOS
cp $BUILD_DIR/bin/doxygen          $DOXYWIZARD_APP/Contents/Resources
cp $BUILD_DIR/bin/doxyindexer      $DOXYWIZARD_APP/Contents/Resources
cp $BUILD_DIR/bin/doxysearch.cgi   $DOXYWIZARD_APP/Contents/Resources
cp $DOXYWIZARD_DIR/DoxyWizard.icns $DOXYWIZARD_APP/Contents/Resources

# --- get version
VERSION=$(cd $DOXYGEN_DIR; git describe --always --tags)
if [[ $VERSION =~ Release_([0-9]+_[0-9]+_[0-9]+)(.*) ]]; then
  VERSION_SHORT=${BASH_REMATCH[1]}
  VERSION_SHORT=${VERSION_SHORT//_/.}
  VERSION=$VERSION_SHORT${BASH_REMATCH[2]}
fi

# --- modify property list
INFO_PLIST=$DOXYWIZARD_APP/Contents/Info.plist
/usr/libexec/PlistBuddy -c "Set CFBundleGetInfoString '$VERSION, Copyright (c) 1997-2011 by Dimitri van Heesch.'" $INFO_PLIST
/usr/libexec/PlistBuddy -c "Set CFBundleIdentifier org.doxygen" $INFO_PLIST
/usr/libexec/PlistBuddy -c "Set NOTE https://github.com/dehesselle/doxygen" $INFO_PLIST
/usr/libexec/PlistBuddy -c "Set CFBundleSignature Doxy" $INFO_PLIST
/usr/libexec/PlistBuddy -c "Set CFBundleIconFile DoxyWizard.icns" $INFO_PLIST
/usr/libexec/PlistBuddy -c "Add CFBundleShortVersionString string $VERSION_SHORT" $INFO_PLIST

