#!/bin/bash
 if [ $# -ne 1 ]; then
     echo "Usage: `basename $0` <schemaname.tablename> "
     echo "Example for run : ./`basename $0`  schemanam.tablename "
     exit
 fi

psql -ec "alter table $1 set with (reorganize=true); "
psql -ec "analyze $1 ; "
