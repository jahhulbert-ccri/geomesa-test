#!/usr/bin/env bash

GM="/tmp/geomesa-tools-1.2.1-SNAPSHOT"
geomesa="$GM/bin/geomesa"

. "$HOME/dev/cloud-local/bin/config.sh"

#$geomesa ingest -u root -p secret -c test1 -s example-csv  -C example-csv                                      $GM/examples/ingest/csv/example.csv
#$geomesa ingest -u root -p secret -c test1 -s example-json -C example-json                                     $GM/examples/ingest/json/example.json
#$geomesa ingest -u root -p secret -c test1 -s example-json -C $GM/examples/ingest/json/example_multi_line.conf $GM/examples/ingest/json/example_multi_line.json
#$geomesa ingest -u root -p secret -c test1 -s example-xml  -C example-xml                                      $GM/examples/ingest/xml/example.xml
#$geomesa ingest -u root -p secret -c test1 -s example-xml  -C example-xml-multi                                $GM/examples/ingest/xml/example_multi_line.xml
#$geomesa ingest -u root -p secret -c test1 -s example-avro -C example-avro-no-header                           $GM/examples/ingest/avro/example_no_header.avro
##$geomesa ingest -u root -p secret -c test1 -s example-avro -C example-avro-header                             $GM/examples/ingest/avro/with_header.avro

#hadoop fs -ls /user/$(whoami)

#hadoop fs -put $GM/examples/ingest/csv/example.csv
#hadoop fs -put $GM/examples/ingest/json/example.json
#hadoop fs -put $GM/examples/ingest/json/example_multi_line.json
#hadoop fs -put $GM/examples/ingest/xml/example.xml
#hadoop fs -put $GM/examples/ingest/xml/example_multi_line.xml
#hadoop fs -put $GM/examples/ingest/avro/example_no_header.avro
##hadoop fs -put $GM/examples/ingest/avro/with_header.avro

#$geomesa ingest -u root -p secret -c test1 -s example-csv  -C example-csv                                      hdfs://localhost:9000/user/$(whoami)/example.csv
#$geomesa ingest -u root -p secret -c test1 -s example-json -C example-json                                     hdfs://localhost:9000/user/$(whoami)/example.json
#$geomesa ingest -u root -p secret -c test1 -s example-json -C $GM/examples/ingest/json/example_multi_line.conf hdfs://localhost:9000/user/$(whoami)/example_multi_line.json
#$geomesa ingest -u root -p secret -c test1 -s example-xml  -C example-xml                                      hdfs://localhost:9000/user/$(whoami)/example.xml
#$geomesa ingest -u root -p secret -c test1 -s example-xml  -C example-xml-multi                                hdfs://localhost:9000/user/$(whoami)/example_multi_line.xml
#$geomesa ingest -u root -p secret -c test1 -s example-avro -C example-avro-no-header                           hdfs://localhost:9000/user/$(whoami)/example_no_header.avro
##$geomesa ingest -u root -p secret -c test1 -s example-avro -C example-avro-header                             hdfs://localhost:9000/user/$(whoami)/with_header.avro

# uses gmdata jar in tools lib
# s3n
#$geomesa ingest -u root -p secret -c awstest -s geolife -C geolife s3n://ahulbert-test/geolife/Data/000/Trajectory/20081023025304.plt s3n://ahulbert-test/geolife/Data/000/Trajectory/20081024020959.plt
# s3a
$geomesa ingest -u root -p secret -c awstest -s geolife -C geolife s3a://ahulbert-test/geolife/Data/000/Trajectory/20081023025304.plt s3a://ahulbert-test/geolife/Data/000/Trajectory/20081024020959.plt



echo "DONE"