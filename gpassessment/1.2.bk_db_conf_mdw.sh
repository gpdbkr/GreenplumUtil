#!/bin/bash

SHELL_NM=$0
CURDIR=`pwd`
CONFDIR=$CURDIR"/"conf
mkdir -p $CONFDIR

cp $MASTER_DATA_DIRECTORY/postgresql.conf $CONFDIR"/"mdw_postgresql.conf
cp $MASTER_DATA_DIRECTORY/pg_hba.conf $CONFDIR"/"mdw_pg_hba.conf

