#! /bin/bash

#
# Installation script for clBLAS.
#
# See CK LICENSE for licensing details.
# See CK COPYRIGHT for copyright details.
#
# Developer(s):
# - Grigori Fursin, 2015;
# - Anton Lokhmotov, 2016.
#

# PACKAGE_DIR
# INSTALL_DIR

cd ${INSTALL_DIR}

############################################################
echo ""
echo "Downloading '${PACKAGE_FILE}' ..."

rm -f ${PACKAGE_FILE}
wget ${PACKAGE_URL}
if [ "${?}" != "0" ] ; then
  echo "Error: downloading failed!"
  exit 1
fi

############################################################
echo ""
echo "Unbzipping ..."

bzip2 -d ${PACKAGE_FILE}
if [ "${?}" != "0" ] ; then
  echo "Error: unbzipping failed!"
  exit 1
fi

############################################################
echo ""
echo "Untarring ..."

tar xvf ${PACKAGE_FILE1}
if [ "${?}" != "0" ] ; then
  echo "Error: untarring failed!"
  exit 1
fi

############################################################
echo ""
echo "Cleaning ..."

rm -f ${PACKAGE_FILE1}

############################################################
echo ""
echo "Removing obj and lib directories ..."

cd ${INSTALL_DIR}

rm -rf obj
rm -rf lib

mkdir obj
cd obj

############################################################
echo ""
echo "Executing cmake ..."

cmake -DCMAKE_TOOLCHAIN_FILE="${PACKAGE_DIR}/android.toolchain.cmake" \
      -DANDROID_NDK="${CK_ANDROID_NDK_ROOT_DIR}" \
      -DCMAKE_BUILD_TYPE=Release \
      -DANDROID_ABI="${CK_ANDROID_ABI}" \
      -DANDROID_NATIVE_API_LEVEL=${CK_ANDROID_API_LEVEL} \
      -DCMAKE_INSTALL_PREFIX="${INSTALL_DIR}/install" \
      ..

if [ "${?}" != "0" ] ; then
  echo "Error: cmake failed!"
  exit 1
fi

############################################################
echo ""
echo "Building package ..."

make -j ${CK_HOST_CPU_NUMBER_OF_PROCESSORS}
if [ "${?}" != "0" ] ; then
  echo "Error: build failed!"
  exit 1
fi

############################################################
echo ""
echo "Installing package ..."

make install/strip
if [ "${?}" != "0" ] ; then
  echo "Error: installation failed!"
  exit 1
fi

exit 0
