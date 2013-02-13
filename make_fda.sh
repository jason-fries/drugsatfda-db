#!/bin/sh
# 
# Create Drugs@FDA sqlite3 Database (OSX/Linux)
#
# @author	Jason Alan Fries 
# @email 	jason-fries [at] uiowa.edu
# 
# USAGE: make_fda.sh
# OPTIONS: -d Download Drugs@FDA database snapshot
#
DBNAME="drugsatfda.db"

# Use drugsatfda.zip snapshot from
# http://www.fda.gov/downloads/Drugs/InformationOnDrugs/UCM054599.zip
if [ "$1" == "-d" ]
then
  curl http://www.fda.gov/downloads/Drugs/InformationOnDrugs/UCM054599.zip > snapshot.zip
  unzip snapshot.zip -d drugsatfda
fi

# backup any existing Drugs@FDA database version
if [ -f $DBNAME ];
then
mv $DBNAME "$DBNAME.bak";
fi

# prepare CSV data by stripping field header row (to prevent datatype import errors)
mkdir tmp
tail +2 drugsatfda/AppDoc.txt > tmp/AppDoc.txt
tail +2 drugsatfda/AppDocType_Lookup.txt > tmp/AppDocType_Lookup.txt
tail +2 drugsatfda/application.txt > tmp/application.txt
tail +2 drugsatfda/ChemTypeLookup.txt > tmp/ChemTypeLookup.txt
tail +2 drugsatfda/DocType_lookup.txt > tmp/DocType_lookup.txt
tail +2 drugsatfda/Product_tecode.txt > tmp/Product_tecode.txt
tail +2 drugsatfda/Product.txt > tmp/Product.txt
tail +2 drugsatfda/RegActionDate.txt > tmp/RegActionDate.txt
tail +2 drugsatfda/ReviewClass_Lookup.txt > tmp/ReviewClass_Lookup.txt

# create database
sqlite3 $DBNAME < fda.sql

# import snapshot for each table
sqlite3 -separator "	" "$DBNAME" ".import tmp/AppDoc.txt AppDoc"
sqlite3 -separator "	" "$DBNAME" ".import tmp/AppDocType_Lookup.txt AppDocType_Lookup"
sqlite3 -separator "	" "$DBNAME" ".import tmp/application.txt Application"
sqlite3 -separator "	" "$DBNAME" ".import tmp/ChemTypeLookup.txt ChemicalType_Lookup"
sqlite3 -separator "	" "$DBNAME" ".import tmp/DocType_lookup.txt DocType_Lookup"
sqlite3 -separator "	" "$DBNAME" ".import tmp/Product.txt Product"
sqlite3 -separator "	" "$DBNAME" ".import tmp/Product_tecode.txt Product_TECode"
sqlite3 -separator "	" "$DBNAME" ".import tmp/ReviewClass_Lookup.txt ReviewClass_Lookup"
sqlite3 -separator "	" "$DBNAME" ".import tmp/RegActionDate.txt RegActionDate"

# remove tmp files
rm -r -f tmp

echo "Created $DBNAME"
echo "TO ACCESS DATABASE, TYPE -> \"sqlite3 $DBNAME\""



