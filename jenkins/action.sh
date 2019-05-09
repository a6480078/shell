echo "Print all the environment variables"
echo "======================================"
echo
cd $WORKSPACE
echo "Now we are under `pwd`"
export TARGET_HOST=10.10.15.16
export TARGET_PACKAGE_DIR=/home/packages

cd $WORKSPACE/hanshang-coreService/src/main/resources/properties/dev
sed -ie "s/localhost/$TARGET_HOST/" sys.properties

cd $WORKSPACE
echo "Now we are under `pwd`"

/usr/local/maven/bin/mvn test 

if [ $? -ne 0 ];then
  echo "Unit Test Failed! Please go back and check the source code!"
  exit 1
fi

# Start deployment
/usr/local/maven/bin/mvn package

echo "Deploying $WORKSPACE/hanshang-coreService/target/hanshang-coreService.war"
rsync $WORKSPACE/hanshang-coreService/target/hanshang-coreService.war $TARGET_HOST:$TARGET_PACKAGE_DIR
ssh $TARGET_HOST "cd /data/scripts;./app_deploy_war.sh $TARGET_PACKAGE_DIR $TARGET_HOST 106.112.143.254"
echo "Deployment done"


echo
echo "======================================"
echo "Yes, it is!"
#echo "######## Next is the integrated test procedure ########"
#cd IntegratedTest
#/usr/bin/python3 testcase1.py
#echo "######## Integrated test done! ########"
exit 0

