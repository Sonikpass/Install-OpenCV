#sudo yum -y install wget
. `dirname $0`/opencv_get_3_1_0.sh
if [ $? -ne 0 ]; then
	exit $?;
fi
. `dirname $0`/opencv_install.sh
