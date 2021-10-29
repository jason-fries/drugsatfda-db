#!/bin/sh
#
# Create Drugs@FDA sqlite3 Database (MacOS/Linux)
#
# USAGE: make_fda.sh
# OPTIONS: -d Download Drugs@FDA database snapshot
#
DBNAME="drugsatfda.db"

# Use drugsatfda.zip snapshot from
# https://www.fda.gov/media/89850/download
if [ "$1" = "-d" ]
then
  curl https://www.fda.gov/media/89850/download > snapshot.zip
  unzip snapshot.zip -d drugsatfda
fi

# backup any existing Drugs@FDA database version
if [ -f $DBNAME ];
then
mv $DBNAME "$DBNAME.bak";
fi

# prepare CSV data by stripping field header row (to prevent datatype import errors)
mkdir tmp
tail +2 drugsatfda/ActionTypes_Lookup.txt > tmp/ActionTypes_Lookup.txt
tail +2 drugsatfda/ApplicationDocs.txt > tmp/ApplicationDocs.txt
tail +2 drugsatfda/Applications.txt > tmp/Applications.txt
tail +2 drugsatfda/ApplicationsDocsType_Lookup.txt > tmp/ApplicationsDocsType_Lookup.txt
tail +2 drugsatfda/MarketingStatus.txt > tmp/MarketingStatus.txt
tail +2 drugsatfda/MarketingStatus_Lookup.txt > tmp/MarketingStatus_Lookup.txt
tail +2 drugsatfda/Products.txt > tmp/Products.txt
tail +2 drugsatfda/SubmissionClass_Lookup.txt > tmp/SubmissionClass_Lookup.txt
tail +2 drugsatfda/SubmissionPropertyType.txt > tmp/SubmissionPropertyType.txt
tail +2 drugsatfda/Submissions.txt > tmp/Submissions.txt
tail +2 drugsatfda/TE.txt > tmp/TE.txt

# create database
sqlite3 $DBNAME < fda.sql

# import snapshot for each table
sqlite3 -separator "	" "$DBNAME" ".import tmp/ActionTypes_Lookup.txt ActionTypes_Lookup"
sqlite3 -separator "	" "$DBNAME" ".import tmp/ApplicationDocs.txt ApplicationDocs"
sqlite3 -separator "	" "$DBNAME" ".import tmp/Applications.txt Applications"
sqlite3 -separator "	" "$DBNAME" ".import tmp/ApplicationsDocsType_Lookup.txt ApplicationsDocsType_Lookup"
sqlite3 -separator "	" "$DBNAME" ".import tmp/MarketingStatus.txt MarketingStatus"
sqlite3 -separator "	" "$DBNAME" ".import tmp/MarketingStatus_Lookup.txt MarketingStatus_Lookup"
sqlite3 -separator "	" "$DBNAME" ".import tmp/Products.txt Products"
sqlite3 -separator "	" "$DBNAME" ".import tmp/SubmissionClass_Lookup.txt SubmissionClass_Lookup"
sqlite3 -separator "	" "$DBNAME" ".import tmp/SubmissionPropertyType.txt SubmissionPropertyType"
sqlite3 -separator "	" "$DBNAME" ".import tmp/Submissions.txt Submissions"
sqlite3 -separator "	" "$DBNAME" ".import tmp/TE.txt TE"


# remove tmp files
rm -rf tmp

echo "Created $DBNAME"
echo "TO ACCESS DATABASE, TYPE -> \"sqlite3 $DBNAME\""
