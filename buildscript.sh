#!/bin/bash
clear
set LANG="C.utf8"
if [ -z "$(uname -a | grep CYGWIN_NT)" ]; then
	echo "Please run this script on cygwin."
	exit
fi
LONGUTVERSION="3.3.2"
LONGBTVERSION="7.8.1"
REVISION=29976
DATE=$(date +"%Y%m%d")
DIR=$(dirname $0);
echo "DIR=$DIR"
BTDIR=/tmp/bittorrent
cd $DIR
which hhc.exe > /dev/null 2>&1
if [ $? -eq 0 ]; then
	hhc='hhc.exe'
else
	hhc='./hhc.exe'
	if [ ! -f $hhc ]; then
		echo 'hhc.exe missing. Please install HTML Help Workshop and add it to your path';
		exit
	fi
fi
which 7z >/dev/null 2>&1
if [ $? -eq 0 ]; then
compress='7z';
else
compress='./7z';
fi
mkdir -p $BTDIR/
mkdir -p $DIR/output

UTVERSION=$(echo $LONGUTVERSION | tr -d '.')
BTVERSION=$(echo $LONGBTVERSION | tr -d '.')
cp -R $DIR/resources/* $BTDIR/
for i in "$BTDIR/html/*" "$BTDIR/*.h*"; do
sed -i s/'&micro;Torrent'/BitTorrent/g $i;
sed -i s/v$LONGUTVERSION/v$LONGBTVERSION/g $i;
sed -i s/µTorrent/BitTorrent/g $i;
sed -i s/main\.png/main_bittorrent.png/g $i;
sed -i s/icon\.ico/icon_bittorrent\.ico/g $i;
done

sed -i s/www\.utorrent\.com/www.bittorrent.com/g $BTDIR/html/ExternalLinks.html
sed -i s/utorrent\.chm/bittorrent.chm/g $BTDIR/utorrent.hhp
sed -i s/utorrent\.log/bittorrent.log/g $BTDIR/utorrent.hhp
echo $BTVERSION-$REVISION-$DATE > $BTDIR/version.txt
$hhc $(cygpath -w $BTDIR/utorrent.hhp)
rm -f $DIR/output/bittorrent-help-${BTVERSION}1.zip
$compress a -tzip -y -mx=9 $(cygpath -w $DIR/output/bittorrent-help-${BTVERSION}0.zip) $(cygpath -w -a $BTDIR/bittorrent.chm) $(cygpath -w -a $BTDIR/version.txt)
mv $BTDIR/bittorrent.log $DIR/output/
rm -r $BTDIR

echo $UTVERSION-$REVISION-$DATE > $DIR/resources/version.txt
$hhc $(cygpath -a -w $DIR/resources/utorrent.hhp)
rm -f $DIR/output/utorrent-help-${UTVERSION}1.zip
$compress a -tzip -y -mx=9 $(cygpath -w $DIR/output/utorrent-help-${UTVERSION}1.zip) $(cygpath -w -a $DIR/resources/utorrent.chm) $(cygpath -w -a $DIR/resources/version.txt)
mv $DIR/resources/utorrent.log $DIR/output/
rm $DIR/resources/utorrent.chm
rm $DIR/resources/version.txt
