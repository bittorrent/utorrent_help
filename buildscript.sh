#!/bin/bash
echo "This CHM compiler script will only work on cygwin. Requires 7z.exe and 7z.dll!"
VERSION=321
BTVERSION=720
REVISION=28086
DATE=$(date +"%Y%m%d")
DIR=$(dirname $0);
BTDIR=/tmp/bittorrent
cd $DIR
which hhc.exe > /dev/null 2>&1
if [ $? -eq 0 ]; then
hhc='hhc.exe'
else
hhc='./hhc.exe'
fi
which 7z >/dev/null 2>&1
if [ $? -eq 0 ]; then
compress='7z';
else
compress='./7z';
fi
mkdir $BTDIR/
mkdir $DIR/output

cp -R $DIR/resources/* $BTDIR/
for i in "$BTDIR/html/*" "$BTDIR/*.h*"; do
sed -i s/'&micro;Torrent'/BitTorrent/g $i;
sed -i s/v2.2/v7.2/g $i;
sed -i s/µTorrent/BitTorrent/g $i;
sed -i s/main\.png/main_bittorrent.png/g $i;
sed -i s/icon\.ico/icon_bittorrent\.ico/g $i;
done

sed -i s/www\.utorrent\.com/www.bittorrent.com/g $BTDIR/html/ExternalLinks.html
sed -i s/utorrent\.chm/bittorrent.chm/g $BTDIR/utorrent.hhp
sed -i s/utorrent\.log/bittorrent.log/g $BTDIR/utorrent.hhp
echo $BTVERSION-$REVISION-$DATE > $BTDIR/version.txt
$hhc $(cygpath -w $BTDIR/utorrent.hhp)
rm $DIR/output/bittorrent-help-${BTVERSION}0.zip
$compress a -tzip -y -mx=9 $(cygpath -w $DIR/output/bittorrent-help-${BTVERSION}0.zip) $(cygpath -w $BTDIR/bittorrent.chm) $(cygpath -w $BTDIR/version.txt)
mv $BTDIR/bittorrent.log $DIR/output/
rm -r $BTDIR

echo $VERSION-$REVISION-$DATE > $DIR/resources/version.txt
$hhc $(cygpath -w $DIR/resources/utorrent.hhp)
rm $DIR/output/utorrent-help-${VERSION}0.zip
$compress a -tzip -y -mx=9 $(cygpath -w $DIR/output/utorrent-help-${VERSION}0.zip) $(cygpath -w $DIR/resources/utorrent.chm) $(cygpath -w $DIR/resources/version.txt)
mv $DIR/resources/utorrent.log $DIR/output/
rm $DIR/resources/utorrent.chm
rm $DIR/resources/version.txt

