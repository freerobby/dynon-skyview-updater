#!/bin/bash
OUTPUT_DIR=./dynon
CHARTDATA_DIR=$OUTPUT_DIR/ChartData
TMP_DIR=./tmp
mkdir -p $TMP_DIR

echo "Enter this month's prefix number (4 digits): "
read PREFIX

echo "Enter this month's password: "
read PASSWORD

echo "Downloading latest Geo-Referenced Charts and Airport Diagrams..."
wget -P $TMP_DIR --no-clobber http://data.seattleavionics.com/OEM/Generic/$PREFIX/$PREFIX.Plates1024.PNG.zip
wget -P $TMP_DIR --no-clobber http://data.seattleavionics.com/OEM/Generic/$PREFIX/$PREFIX.Plates.GEO.zip
wget -P $TMP_DIR --no-clobber http://data.seattleavionics.com/OEM/Generic/$PREFIX/$PREFIX.ScannedCharts.sqlite.zip
wget -P $TMP_DIR --no-clobber http://data.seattleavionics.com/OEM/Generic/$PREFIX/$PREFIX.FG1024.PNG.zip
wget -P $TMP_DIR --no-clobber http://data.seattleavionics.com/OEM/Generic/$PREFIX/$PREFIX.FG.GEO.zip
wget -P $TMP_DIR --no-clobber http://data.seattleavionics.com/OEM/Generic/$PREFIX/$PREFIX.LO.MultiDiskImg.zip
wget -P $TMP_DIR --no-clobber http://data.seattleavionics.com/OEM/Generic/$PREFIX/$PREFIX.HI.MultiDiskImg.zip
wget -P $TMP_DIR --no-clobber http://data.seattleavionics.com/OEM/Generic/$PREFIX/$PREFIX.SEC.MultiDiskImg.zip

echo "Downloading latest US Aviation / Obstacles database..."
aviation_obstacles_path=$(curl -s https://www.dynoncertified.com/us-aviation-obstacle-data.php | grep -m 1 software\/data\/.*\.duc | sed -n 's/^.*href="\(.*.duc\)".*$/\1/p')
aviation_obstacles_filename=$(echo $aviation_obstacles_path | sed -n 's/^.*\/\(.*.duc\)$/\1/p')
aviation_obstacles_uri=$(echo "https://www.dynoncertified.com/$aviation_obstacles_path")
wget -P $TMP_DIR --no-clobber $aviation_obstacles_uri

echo "Downloading latest software updates..."
software_ten_path=$(curl -s https://www.dynoncertified.com/software-updates-single.php | grep -m 1 HDX1100 | sed -n 's/^.*href="\(.*.duc\)".*$/\1/p')
software_ten_filename=$(echo $software_ten_path | sed -n 's/^.*\/\(.*.duc\)$/\1/p')
software_ten_uri=$(echo "https://www.dynoncertified.com/$software_ten_path")
wget -P $TMP_DIR --no-clobber $software_ten_uri
software_seven_path=$(curl -s https://www.dynoncertified.com/software-updates-single.php | grep -m 1 HDX800 | sed -n 's/^.*href="\(.*.duc\)".*$/\1/p')
software_seven_filename=$(echo $software_seven_path | sed -n 's/^.*\/\(.*.duc\)$/\1/p')
software_seven_uri=$(echo "https://www.dynoncertified.com/$software_seven_path")
wget -P $TMP_DIR --no-clobber $software_seven_uri

echo "Removing old data"
rm -rf $OUTPUT_DIR
mkdir -p $OUTPUT_DIR
mkdir -p $CHARTDATA_DIR

echo "Extracting databases"
unzip -q -o -P $PASSWORD -d ./$CHARTDATA_DIR/Plates $TMP_DIR/$PREFIX.Plates.GEO.zip
unzip -q -o -P $PASSWORD -d ./$CHARTDATA_DIR/Plates/US $TMP_DIR/$PREFIX.Plates1024.PNG.zip
unzip -q -o -P $PASSWORD -d ./$CHARTDATA_DIR/FG $TMP_DIR/$PREFIX.FG.GEO.zip
unzip -q -o -P $PASSWORD -d ./$CHARTDATA_DIR/FG/US $TMP_DIR/$PREFIX.FG1024.PNG.zip
unzip -q -o              -d ./$CHARTDATA_DIR $TMP_DIR/$PREFIX.ScannedCharts.sqlite.zip
unzip -q -o -P $PASSWORD -d ./$CHARTDATA_DIR $TMP_DIR/$PREFIX.LO.MultiDiskImg.zip
unzip -q -o -P $PASSWORD -d ./$CHARTDATA_DIR $TMP_DIR/$PREFIX.HI.MultiDiskImg.zip
unzip -q -o -P $PASSWORD -d ./$CHARTDATA_DIR $TMP_DIR/$PREFIX.SEC.MultiDiskImg.zip

echo "Staging Skyview updates"
cp $TMP_DIR/$aviation_obstacles_filename $OUTPUT_DIR/
cp $TMP_DIR/$software_ten_filename $OUTPUT_DIR/
cp $TMP_DIR/$software_seven_filename $OUTPUT_DIR/

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
