#!/usr/bin/env bash

GM="/tmp/geomesa-tools-1.2.2-SNAPSHOT"
GMTMP="geomesa-test-tmp"
geomesa="$GM/bin/geomesa"

. "$HOME/dev/cloud-local/bin/config.sh"

$geomesa ingest -u root -p secret -c test1 -s example-csv  -C example-csv                                      $GM/examples/ingest/csv/example.csv
$geomesa ingest -u root -p secret -c test1 -s example-json -C example-json                                     $GM/examples/ingest/json/example.json
$geomesa ingest -u root -p secret -c test1 -s example-json -C $GM/examples/ingest/json/example_multi_line.conf $GM/examples/ingest/json/example_multi_line.json
$geomesa ingest -u root -p secret -c test1 -s example-xml  -C example-xml                                      $GM/examples/ingest/xml/example.xml
$geomesa ingest -u root -p secret -c test1 -s example-xml  -C example-xml-multi                                $GM/examples/ingest/xml/example_multi_line.xml
$geomesa ingest -u root -p secret -c test1 -s example-avro -C example-avro-no-header                           $GM/examples/ingest/avro/example_no_header.avro
#$geomesa ingest -u root -p secret -c test1 -s example-avro -C example-avro-header                             $GM/examples/ingest/avro/with_header.avro

hadoop fs -ls /user/$(whoami)

hadoop fs -put $GM/examples/ingest/csv/example.csv
hadoop fs -put $GM/examples/ingest/json/example.json
hadoop fs -put $GM/examples/ingest/json/example_multi_line.json
hadoop fs -put $GM/examples/ingest/xml/example.xml
hadoop fs -put $GM/examples/ingest/xml/example_multi_line.xml
hadoop fs -put $GM/examples/ingest/avro/example_no_header.avro
#hadoop fs -put $GM/examples/ingest/avro/with_header.avro

$geomesa ingest -u root -p secret -c test1 -s example-csv  -C example-csv                                      hdfs://localhost:9000/user/$(whoami)/example.csv
$geomesa ingest -u root -p secret -c test1 -s example-json -C example-json                                     hdfs://localhost:9000/user/$(whoami)/example.json
$geomesa ingest -u root -p secret -c test1 -s example-json -C $GM/examples/ingest/json/example_multi_line.conf hdfs://localhost:9000/user/$(whoami)/example_multi_line.json
$geomesa ingest -u root -p secret -c test1 -s example-xml  -C example-xml                                      hdfs://localhost:9000/user/$(whoami)/example.xml
$geomesa ingest -u root -p secret -c test1 -s example-xml  -C example-xml-multi                                hdfs://localhost:9000/user/$(whoami)/example_multi_line.xml
$geomesa ingest -u root -p secret -c test1 -s example-avro -C example-avro-no-header                           hdfs://localhost:9000/user/$(whoami)/example_no_header.avro
#$geomesa ingest -u root -p secret -c test1 -s example-avro -C example-avro-header                             hdfs://localhost:9000/user/$(whoami)/with_header.avro

# uses gmdata jar in tools lib
# s3n
$geomesa ingest -u root -p secret -c awstest -s geolife -C geolife s3n://ahulbert-test/geolife/Data/000/Trajectory/20081023025304.plt s3n://ahulbert-test/geolife/Data/000/Trajectory/20081024020959.plt
# s3a
$geomesa ingest -u root -p secret -c awstest -s geolife -C geolife s3a://ahulbert-test/geolife/Data/000/Trajectory/20081023025304.plt s3a://ahulbert-test/geolife/Data/000/Trajectory/20081024020959.plt

if [[ -d "$GMTMP" ]]; then
  rm "/tmp/${GMTMP}" -rf
fi

t="/tmp/${GMTMP}"
mkdir $t

# Export some formats
$geomesa export -u root -p secret -c test1 -f example-csv -F csv  > "$t/e.csv"
$geomesa export -u root -p secret -c test1 -f example-csv -F avro > "$t/e.avro"
$geomesa export -u root -p secret -c test1 -f example-csv -F tsv  > "$t/e.tsv"

# Reingest automatically those formats both locally and via hdfs
$geomesa ingest -u root -p secret -c test1 -f re-avro "$t/e.avro"
$geomesa ingest -u root -p secret -c test1 -f re-csv  "$t/e.csv"
$geomesa ingest -u root -p secret -c test1 -f re-tsv  "$t/e.tsv"

hadoop fs -put "$t/e.avro"
hadoop fs -put "$t/e.csv"
hadoop fs -put "$t/e.tsv"

$geomesa ingest -u root -p secret -c test1 -f re-avro-hdfs hdfs://localhost:9000/user/$(whoami)/e.avro
$geomesa ingest -u root -p secret -c test1 -f re-csv-hdfs  hdfs://localhost:9000/user/$(whoami)/e.csv
$geomesa ingest -u root -p secret -c test1 -f re-tsv-hdfs  hdfs://localhost:9000/user/$(whoami)/e.tsv

# compare output of reimported tsv,csv,avro to standard export
$geomesa export -u root -p secret -c test1 -f re-avro       -F csv  | sort >  "$t/re.avro.export"
$geomesa export -u root -p secret -c test1 -f re-avro-hdfs  -F csv  | sort >  "$t/re.avro.hdfs.export"
$geomesa export -u root -p secret -c test1 -f re-csv        -F csv  | sort >  "$t/re.csv.export"
$geomesa export -u root -p secret -c test1 -f re-csv-hdfs   -F csv  | sort >  "$t/re.csv.hdfs.export"
$geomesa export -u root -p secret -c test1 -f re-tsv        -F csv  | sort >  "$t/re.tsv.export"
$geomesa export -u root -p secret -c test1 -f re-tsv-hdfs   -F csv  | sort >  "$t/re.tsv.hdfs.export"

target="$t/e.csv.sorted"
cat "$t/e.csv" | sort > "$target"


function differ() {
  local f=$1
  echo "diff $f"
  diff "${target}" "$f"
  echo "done"
}

differ "$t/re.avro.export"
differ "$t/re.avro.hdfs.export"
differ "$t/re.csv.export"
differ "$t/re.csv.hdfs.export"
differ "$t/re.tsv.export"
differ "$t/re.tsv.hdfs.export"
echo "DONE"
