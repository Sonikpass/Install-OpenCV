#!/bin/bash
# Dan Walkes
# 2014-01-29
# Call this script after configuring variables:
# version - the version of OpenCV to be installed
# downloadfile - the name of the OpenCV download file
# dldir - the download directory (optional, if not specified creates an OpenCV directory in the working dir)
if [[ -z "$version" ]]; then
    echo "Please define version before calling `basename $0` or use a wrapper like opencv_latest.sh"
    exit 1
fi
if [[ -z "$downloadfile" ]]; then
    echo "Please define downloadfile before calling `basename $0` or use a wrapper like opencv_latest.sh"
    exit 1
fi
if [[ -z "$dldir" ]]; then
    dldir=OpenCV
fi
if ! sudo true; then
    echo "You must have root privileges to run this script."
    exit 1
fi
set -e

echo "--- Installing OpenCV" $version

echo "--- Installing Dependencies"
source dependencies.sh

echo "--- Downloading OpenCV" $version
mkdir -p $dldir
cd $dldir
if [ ! -f $downloadfile ]; then
    echo "Downloading OpenCV" $version
    wget -O $downloadfile http://sourceforge.net/projects/opencvlibrary/files/opencv-unix/$version/$downloadfile/download
fi
#wget -c -O $downloadfile http://sourceforge.net/projects/opencvlibrary/files/opencv-unix/$version/$downloadfile/download

echo "--- Installing OpenCV" $version
echo $downloadfile | grep ".zip"
if [ $? -eq 0 ]; then
    unzip $downloadfile
else
    tar -xvf $downloadfile
fi
cd opencv-$version
mkdir build
cd build
#cmake -D CMAKE_BUILD_TYPE=RELEASE -D CMAKE_INSTALL_PREFIX=/usr/local -D WITH_TBB=ON -D BUILD_NEW_PYTHON_SUPPORT=OFF -D WITH_V4L=ON -D INSTALL_C_EXAMPLES=OFF -D INSTALL_PYTHON_EXAMPLES=OFF -D BUILD_EXAMPLES=OF -D WITH_QT=ON -D WITH_OPENGL=ON -D BUILD_DOCS=OFF -D OPENCV_EXTRA_MODULES_PATH=/home/ec2-user/opencv_contrib/modules BUILD_TESTS=OFF -D BUILD_PERF_TESTS=OFF BUILD_PERF_TESTS=OFF ..
cmake   -D BUILD_DOCS=OFF -D OPENCV_EXTRA_MODULES_PATH=/home/ec2-user/opencv_contrib/modules -D CMAKE_BUILD_TYPE=RELEASE -D ENABLE_PRECOMPILED_HEADERS=OFF -D BUILD_opencv_aruco=OFF -D BUILD_opencv_python2=OFF -D BUILD_opencv_python=OFF -D BUILD_opencv_optflow=OFF -D BUILD_opencv_text=OFF -D BUILD_opencv_videoio=OFF -D BUILD_opencv_world=OFF -D BUILD_opencv_tracking=OFF -D BUILD_opencv_contrib_world=OFF -D BUILD_opencv_ccalib=OFF -D BUILD_opencv_calib3d=OFF -D BUILD_opencv_apps=OFF -D BUILD_TESTS=OFF -D BUILD_PERF_TESTS=OFF  -D BUILD_EXAMPLES=OFF -D INSTALL_PYTHON_EXAMPLES=OFF -D CMAKE_INSTALL_PREFIX=/usr/local ..
make -j 4
sudo make install
sudo sh -c 'echo "/usr/local/lib" > /etc/ld.so.conf.d/opencv.conf'
sudo ldconfig
echo "OpenCV" $version "ready to be used"
