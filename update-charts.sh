#!/bin/bash
OUTPUT_DIR=dynon/ChartData

echo "Enter this month's prefix number (4 digits): "
read PREFIX

echo "Enter this month's password: "
read PASSWORD

echo "Downloading databases"
wget --no-clobber http://data.seattleavionics.com/OEM/Generic/$PREFIX/$PREFIX.Plates1024.PNG.zip
wget --no-clobber http://data.seattleavionics.com/OEM/Generic/$PREFIX/$PREFIX.Plates.GEO.zip
wget --no-clobber http://data.seattleavionics.com/OEM/Generic/$PREFIX/$PREFIX.ScannedCharts.sqlite.zip
wget --no-clobber http://data.seattleavionics.com/OEM/Generic/$PREFIX/$PREFIX.FG1024.PNG.zip
wget --no-clobber http://data.seattleavionics.com/OEM/Generic/$PREFIX/$PREFIX.FG.GEO.zip
wget --no-clobber http://data.seattleavionics.com/OEM/Generic/$PREFIX/$PREFIX.LO.MultiDiskImg.zip
wget --no-clobber http://data.seattleavionics.com/OEM/Generic/$PREFIX/$PREFIX.HI.MultiDiskImg.zip
wget --no-clobber http://data.seattleavionics.com/OEM/Generic/$PREFIX/$PREFIX.SEC.MultiDiskImg.zip

echo "Removing old data"
rm -rf ./$OUTPUT_DIR
mkdir -p ./$OUTPUT_DIR

echo "Extracting databases"
 unzip -q -o -P $PASSWORD -d ./$OUTPUT_DIR/Plates $PREFIX.Plates.GEO.zip
 unzip -q -o -P $PASSWORD -d ./$OUTPUT_DIR/Plates/US $PREFIX.Plates1024.PNG.zip
 unzip -q -o -P $PASSWORD -d ./$OUTPUT_DIR/FG $PREFIX.FG.GEO.zip
 unzip -q -o -P $PASSWORD -d ./$OUTPUT_DIR/FG/US $PREFIX.FG1024.PNG.zip
 unzip -q -o              -d ./$OUTPUT_DIR $PREFIX.ScannedCharts.sqlite.zip
 unzip -q -o -P $PASSWORD -d ./$OUTPUT_DIR $PREFIX.LO.MultiDiskImg.zip
 unzip -q -o -P $PASSWORD -d ./$OUTPUT_DIR $PREFIX.HI.MultiDiskImg.zip
 unzip -q -o -P $PASSWORD -d ./$OUTPUT_DIR $PREFIX.SEC.MultiDiskImg.zip

echo "Removing old disk image"
rm -f ./image.img

echo "Creating new disk image"
hdiutil create \
  -layout NONE \
  -size 16g \
  -fs "MS-DOS FAT32" \
  -format UDTO \
  -volname DYNCHRTS \
  -srcfolder ./dynon \
  -nospotlight \
  -noskipunreadable \
  ./image.img
mv ./image.img.cdr ./image.img
