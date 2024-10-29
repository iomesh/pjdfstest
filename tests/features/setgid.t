#!/bin/sh
# vim: filetype=sh noexpandtab ts=8 sw=8

desc="verify SGID bit behaviour"

dir=`dirname $0`
. ${dir}/../misc.sh

echo "1..25"

cdir=`pwd`

d1=`namegen`
d2=`namegen`
d3=`namegen`


# Check the gid of files created under a non-set-gid direcotry
expect 0 mkdir ${d1} 0757
gid=`${fstest} stat ${d1} gid`
cd ${d1}
f1=`namegen`
d1_1=`namegen`
s1=`namegen`
expect 0 -u 65534 -g 65534 create ${f1} 0644
expect 65534 stat ${f1} gid
expect 0 -u 65534 -g 65534 symlink ${f1} ${s1}
expect 65534 stat ${s1} gid
expect 0 -u 65534 -g 65534 mkdir ${d1_1} 0755
expect 65534 stat ${d1_1} gid
expect 0755 stat ${d1_1} mode
expect 0 unlink ${f1}
expect 0 unlink ${s1}
expect 0 rmdir ${d1_1}


cd ${cdir}
expect 0 rmdir ${d1}

# Check the gid of files created under a set-gid direcotry
expect 0 mkdir ${d2} 0757
expect 0 chmod ${d2} 02757
cd ${d2}
expect 0 -u 65534 -g 65534 create ${f1} 0644
expect $gid stat ${f1} gid
expect 0 -u 65534 -g 65534 symlink ${f1} ${s1}
expect $gid stat ${s1} gid
expect 0 -u 65534 -g 65534 mkdir ${d1_1} 0755
expect ${gid} stat ${d1_1} gid
expect 02755 stat ${d1_1} mode
expect 0 unlink ${f1}
expect 0 unlink ${s1}
expect 0 rmdir ${d1_1}

cd ${cdir}
expect 0 rmdir ${d2}