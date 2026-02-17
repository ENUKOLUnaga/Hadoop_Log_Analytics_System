#!/bin/bash

echo "=== Built-in WordCount Execution ==="

# Variables
LOCAL_LOG="/home/nagendra/biglog.log"
HDFS_LOG_DIR="/user/nagendra/logs"
HDFS_OUTPUT="/user/nagendra/output_wordcount"
HADOOP_EXAMPLES_JAR="$HADOOP_HOME/share/hadoop/mapreduce/hadoop-mapreduce-examples-*.jar"

# Upload log file to HDFS
echo "Uploading log file to HDFS..."
hdfs dfs -mkdir -p $HDFS_LOG_DIR
hdfs dfs -put -f $LOCAL_LOG $HDFS_LOG_DIR/

# Remove old output directory if exists
echo "Removing existing HDFS output directory if any..."
hdfs dfs -rm -r $HDFS_OUTPUT 2>/dev/null

# Run WordCount
echo "Running WordCount..."
hadoop jar $HADOOP_EXAMPLES_JAR wordcount $HDFS_LOG_DIR/biglog.log $HDFS_OUTPUT

# Check output
echo "Listing WordCount output files in HDFS..."
hdfs dfs -ls $HDFS_OUTPUT

echo "Displaying top 20 lines of WordCount output..."
hdfs dfs -cat $HDFS_OUTPUT/part-r-00000 | head

echo "=== Script Finished ==="
