Drugs@FDA: Data Import Utility
=============

drugsatfda-db is a shell script for creating a sqlite database from FDA Approved Drugs ( Drugs@FDA ) snapshot data, available at: <http://www.fda.gov/Drugs/InformationOnDrugs/ucm079750.htm> .

### Overview

The U.S. Food and Drug Administration ( FDA ) releases weekly updates on the status of drugs approvded for use in the U.S, provided as table data in plain text format. This script specifies a database schema based on the FDA's table specification and exports a Sqlite database file. 

### Script Usage

**USAGE**
  
    $ ./make_fda.sh [-d <download>]

**OPTIONS**
    
    -d *download ZIP file of Drugs@FDA table data*
