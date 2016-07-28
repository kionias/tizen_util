#!/bin/bash



tizenBasePkgList=(
libpython-
python-2
)

tizenBaseDebugPkgList=(
bc-debuginfo
glibc-debugsource
)

tizenPkgList=(
gdb-7
gdb-ser
)

tizenDebugPkgList=(
pulseaudio-debuginfo
pulseaudio-debugsource
capi-appfw-application-debuginfo
capi-appfw-application-debugsource
audio-session-manager-debuginfo
audio-session-manager-debugsource
efl-debuginfo
efl-debugsource
evas-debuginfo
elementary-debuginfo
elementary-debugsource
eina-debuginfo
app-core-efl-debuginfo
app-core-common-debuginfo
app-core-debugsource
ecore-debuginfo
edje-debuginfo
efl-assist-debuginfo
efl-assist-debugsource
ui-gadget-1-debuginfo
ui-gadget-1-debugsource
)

tizenBaseUrl=https://download.tizen.org/snapshots/tizen/base/latest/repos
tizenMobileUrl=https://download.tizen.org/snapshots/tizen/mobile/latest/repos
tizenTvUrl=https://download.tizen.org/snapshots/tizen/tv/latest/repos
tizenWearableUrl=https://download.tizen.org/snapshots/tizen/wearable/latest/repos
tizenCommonUrl=https://download.tizen.org/snapshots/tizen/common/latest/repos

tizenBasePkgUrl=""
tizenBaseDbgUrl=""
tizenPkgUrl=""
tizenDbgUrl=""

tizenBasePkgListFile="tizenBasePkgList.txt"
tizenBaseDbgListFile="tizenBaseDbgList.txt"
tizenPkgListFile="tizenPkgList.txt"
tizenDbgListFile="tizenDbgList.txt"

tizen_userid=""
tizen_passwd=""

installDir="_tizen_gdb_install"
WGET=""

init() {
    rm -rf  ${installDir}
    mkdir ${installDir}
}


getPackageList() {

    pushd ${installDir}
    
    echo "============================================="
    echo "Download Tizen Base Package List"
    echo "============================================="
    ${WGET} -O -  $tizenBasePkgUrl  |  grep -o '<a href=['"'"'"][^"'"'"']*['"'"'"]' |   sed -e 's/^<a href=["'"'"']//' -e 's/["'"'"']$//' > ${tizenBasePkgListFile}

    echo "============================================="
    echo "Download Tizen Base Debug Package List"
    echo "============================================="
    ${WGET} -O -  $tizenBaseDbgUrl |  grep -o '<a href=['"'"'"][^"'"'"']*['"'"'"]' |   sed -e 's/^<a href=["'"'"']//' -e 's/["'"'"']$//' > ${tizenBaseDbgListFile}

    echo "============================================="
    echo "Download Tizen Package List"
    echo "============================================="
    ${WGET} -O -  $tizenPkgUrl  |  grep -o '<a href=['"'"'"][^"'"'"']*['"'"'"]' |   sed -e 's/^<a href=["'"'"']//' -e 's/["'"'"']$//' > ${tizenPkgListFile}

    echo "============================================="
    echo "Download Tizen Debug Package List"
    echo "============================================="
    ${WGET} -O -  $tizenDbgUrl |  grep -o '<a href=['"'"'"][^"'"'"']*['"'"'"]' |   sed -e 's/^<a href=["'"'"']//' -e 's/["'"'"']$//' > ${tizenDbgListFile}

    popd
}

downloadPackage() {

    pushd ${installDir}

    for package in ${tizenBasePkgList[*]}
    do
        packageFullName=`grep -ir ^$package $tizenBasePkgListFile`

        if [ "x$packageFullName" != "x" ]
        then

            echo "============================================="
            echo "Get Package Name : [$tizenBasePkgUrl/$packageFullName]"
            echo "============================================="
            
            ${WGET}  $tizenBasePkgUrl/$packageFullName
        else 
            echo "============================================="
            echo "(W) : $package is not found" 
            echo "============================================="
        fi
    done

    for package in ${tizenBaseDebugPkgList[*]}
    do
        packageFullName=`grep -ir ^$package $tizenBaseDbgListFile`

        if [ "x$packageFullName" != "x" ]
        then

            echo "============================================="
            echo "Get Package Name : [$tizenBaseDbgUrl/$packageFullName]"
            echo "============================================="
            
            ${WGET}  $tizenBaseDbgUrl/$packageFullName
        else 
            echo "============================================="
            echo "(W) : $package is not found" 
            echo "============================================="
        fi
    done

    for package in ${tizenPkgList[*]}
    do
        packageFullName=`grep -ir ^$package $tizenPkgListFile`

        if [ "x$packageFullName" != "x" ]
        then

            echo "============================================="
            echo "Get Package Name : [$tizenPkgUrl/$packageFullName]"
            echo "============================================="
            
            ${WGET}  $tizenPkgUrl/$packageFullName
        else 
            echo "============================================="
            echo "(W) : $package is not found" 
            echo "============================================="
        fi
    done

    for package in ${tizenDebugPkgList[*]}
    do
        packageFullName=`grep -ir ^$package $tizenDbgListFile`

        if [ "x$packageFullName" != "x" ]
        then

            echo "============================================="
            echo "Get Package Name : [$tizenDbgUrl/$packageFullName]"
            echo "============================================="
            
            ${WGET}  $tizenDbgUrl/$packageFullName
        else 
            echo "============================================="
            echo "(W) : $package is not found" 
            echo "============================================="
        fi
    done

    popd
}

getTargetInfo() {
    echo "========================================="
    echo "11. Tizen 3.0 Mobile arm-wayland"
    echo "12. Tizen 3.0 Mobile arm64-wayland"
    echo "13. Tizen 3.0 Mobile emulator32-wayland"
    echo "14. Tizen 3.0 Mobile emulator64-wayland"
    echo "15. Tizen 3.0 Mobile target-TM1"
    echo ""
    echo "21. Tizen 3.0 TV arm-wayland"
    echo "22. Tizen 3.0 TV emulator32-wayland"
    echo ""
    echo "31. Tizen 3.0 Wearable emulator-circle"
    echo "32. Tizen 3.0 Wearable emulator32-wayland"
    echo "33. Tizen 3.0 Wearable target-circle"
    echo ""
    echo "41. Tizen 3.0 Common arm-wayland"
    echo "42. Tizen 3.0 Common arm64-wayland"
    echo "43. Tizen 3.0 Common emulator32-wayland"
    echo "44. Tizen 3.0 Common ia32-wayland"
    echo "45. Tizen 3.0 Common x86_64-wayland"
    echo "========================================="


    while :
    do
        read -p "Please enter number : " tizen_target_num
        case $tizen_target_num in
            11)
                tizenTaget="arm-wayland"
                tizenBasePkgUrl="${tizenBaseUrl}/arm/packages/armv7l"
                tizenBaseDbgUrl="${tizenBaseUrl}/arm/debug"
                tizenPkgUrl="${tizenMobileUrl}/${tizenTaget}/packages/armv7l"
                tizenDbgUrl="${tizenMobileUrl}/${tizenTaget}/debug"
                break
                ;;
            12)
                tizenTaget="arm64-wayland"
                tizenBasePkgUrl="${tizenBaseUrl}/arm64/packages/aarch64"
                tizenBaseDbgUrl="${tizenBaseUrl}/arm64/debug"
                tizenPkgUrl="${tizenMobileUrl}/${tizenTaget}/packages/aarch64"
                tizenDbgUrl="${tizenMobileUrl}/${tizenTaget}/debug"
                break
                ;;
            13)
                tizenTaget="emulator32-wayland"
                tizenBasePkgUrl="${tizenBaseUrl}/emulator32/packages/i686"
                tizenBaseDbgUrl="${tizenBaseUrl}/emulator32/debug"
                tizenPkgUrl="${tizenMobileUrl}/${tizenTaget}/packages/i686"
                tizenDbgUrl="${tizenMobileUrl}/${tizenTaget}/debug"
                break
                ;;
            14)
                tizenTaget="emulator64-wayland"
                tizenBasePkgUrl="${tizenBaseUrl}/emulator64/packages/x86_64"
                tizenBaseDbgUrl="${tizenBaseUrl}/emulator64/debug"
                tizenPkgUrl="${tizenMobileUrl}/${tizenTaget}/packages/x86_64"
                tizenDbgUrl="${tizenMobileUrl}/${tizenTaget}/debug"
                break
                ;;
            15)
                tizenTaget="target-TM1"
                tizenBasePkgUrl="${tizenBaseUrl}/arm/packages/armv7l"
                tizenBaseDbgUrl="${tizenBaseUrl}/arm/debug"
                tizenPkgUrl="${tizenMobileUrl}/${tizenTaget}/packages/armv7l"
                tizenDbgUrl="${tizenMobileUrl}/${tizenTaget}/debug"
                break
                ;;
            21)
                tizenTaget="arm-wayland"
                tizenBasePkgUrl="${tizenBaseUrl}/arm/packages/armv7l"
                tizenBaseDbgUrl="${tizenBaseUrl}/arm/debug"
                tizenPkgUrl="${tizenTvUrl}/${tizenTaget}/packages/armv7l"
                tizenDbgUrl="${tizenTvUrl}/${tizenTaget}/debug"
                break
                ;;
            22)
                tizenTaget="emulator32-wayland"
                tizenBasePkgUrl="${tizenBaseUrl}/emulator32/packages/i686"
                tizenBaseDbgUrl="${tizenBaseUrl}/emulator32/debug"
                tizenPkgUrl="${tizenTvUrl}/${tizenTaget}/packages/i686"
                tizenDbgUrl="${tizenTvUrl}/${tizenTaget}/debug"
                break
                ;;
            31)
                tizenTaget="emulator-circle"
                tizenBasePkgUrl="${tizenBaseUrl}/emulator32/packages/i686"
                tizenBaseDbgUrl="${tizenBaseUrl}/emulator32/debug"
                tizenPkgUrl="${tizenWearableUrl}/${tizenTaget}/packages/i686"
                tizenDbgUrl="${tizenWearableUrl}/${tizenTaget}/debug"
                break
                ;;
            32)
                tizenTaget="emulator32-wayland"
                tizenBasePkgUrl="${tizenBaseUrl}/emulator32/packages/i686"
                tizenBaseDbgUrl="${tizenBaseUrl}/emulator32/debug"
                tizenPkgUrl="${tizenWearableUrl}/${tizenTaget}/packages/i686"
                tizenDbgUrl="${tizenWearableUrl}/${tizenTaget}/debug"
                break
                ;;
            33)
                tizenTaget="target-circle"
                tizenBasePkgUrl="${tizenBaseUrl}/arm/packages/armv7l"
                tizenBaseDbgUrl="${tizenBaseUrl}/arm/debug"
                tizenPkgUrl="${tizenWearableUrl}/${tizenTaget}/packages/armv7l"
                tizenDbgUrl="${tizenWearableUrl}/${tizenTaget}/debug"
                break
                ;;
            41)
                tizenTaget="arm-wayland"
                tizenBasePkgUrl="${tizenBaseUrl}/arm/packages/armv7l"
                tizenBaseDbgUrl="${tizenBaseUrl}/arm/debug"
                tizenPkgUrl="${tizenCommonUrl}/${tizenTaget}/packages/armv7l"
                tizenDbgUrl="${tizenCommonUrl}/${tizenTaget}/debug"
                break
                ;;
            42)
                tizenTaget="arm64-wayland"
                tizenBasePkgUrl="${tizenBaseUrl}/arm64/packages/aarch64"
                tizenBaseDbgUrl="${tizenBaseUrl}/arm64/debug"
                tizenPkgUrl="${tizenCommonUrl}/${tizenTaget}/packages/aarch64"
                tizenDbgUrl="${tizenCommonUrl}/${tizenTaget}/debug"
                break
                ;;
            43)
                tizenTaget="emulator32-wayland"
                tizenBasePkgUrl="${tizenBaseUrl}/emulator32/packages/i686"
                tizenBaseDbgUrl="${tizenBaseUrl}/emulator32/debug"
                tizenPkgUrl="${tizenCommonUrl}/${tizenTaget}/packages/i686"
                tizenDbgUrl="${tizenCommonUrl}/${tizenTaget}/debug"
                break
                ;;
            44)
                tizenTaget="ia32-wayland"
                tizenBasePkgUrl="${tizenBaseUrl}/ia32/packages/i686"
                tizenBaseDbgUrl="${tizenBaseUrl}/ia32/debug"
                tizenPkgUrl="${tizenCommonUrl}/${tizenTaget}/packages/i686"
                tizenDbgUrl="${tizenCommonUrl}/${tizenTaget}/debug"
                break
                ;;
            45)
                tizenTaget="x86_64-wayland"
                tizenBasePkgUrl="${tizenBaseUrl}/x86_64/packages/x86_64"
                tizenBaseDbgUrl="${tizenBaseUrl}/x86_64/debug"
                tizenPkgUrl="${tizenCommonUrl}/${tizenTaget}/packages/x86_64"
                tizenDbgUrl="${tizenCommonUrl}/${tizenTaget}/debug"
                break
                ;;
            *)
                echo "Unknow number!!"
                ;;
        esac
    done


}
getUserInfo() {
    read -p "Tizen download server user id  : " tizen_userid
    read -p "Tizen download server password : " tizen_passwd

    WGET="wget --user=${tizen_userid} --password=${tizen_passwd}"


}

pushPackageToSDB() {

    pushd ${installDir}
    sdb root on
    if [ $? != 0 ]
    then
        echo "========================================="
        echo "sdb connect error! "
        echo "Please check sdb connection!"
        echo "========================================="
        exit -1
    fi

    sleep 2

    if [ "x${installDir}" != "x" ]
    then
    sdb rm -rf /${installDir}
    sdb mkdir -f /${installDir}
    sdb push *.rpm /${installDir}
    sdb shell rpm -Uvh /${installDir}/*.rpm --force --nodeps
    else
        echo "========================================="
        echo "(W) : installDir is empty!!"
        echo "========================================="
    fi

    popd

}

argumentCheck() {
    getUserInfo
    getTargetInfo
}

main() {
    argumentCheck
    init
    getPackageList
    downloadPackage 
    pushPackageToSDB
    

}

main $*
