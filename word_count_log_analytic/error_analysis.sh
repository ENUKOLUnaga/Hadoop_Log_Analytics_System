#!/bin/bash

# Bash script to run Error-Focused Log Analysis using Hadoop Streaming

# Variables
HDFS_INPUT="/user/nagendra/logs/biglog.log"
HDFS_OUTPUT="/user/nagendra/output_error_analysis"
LOCAL_RESULT_DIR="/mnt/e/Log_Analytic_System_Hadoop/results"

MAPPER="error_mapper.py"
REDUCER="error_reducer.py"

# Step 1: Remove existing HDFS output directory (if exists)
hdfs dfs -rm -r $HDFS_OUTPUT

# Step 2: Run Hadoop Streaming job
hadoop jar $HADOOP_HOME/share/hadoop/tools/lib/hadoop-streaming-*.jar \
  -files $MAPPER,$REDUCER \
  -input $HDFS_INPUT \
  -output $HDFS_OUTPUT \
  -mapper $MAPPER \
  -reducer $REDUCER

# Step 3: Create local results folder if not exists
mkdir -p $LOCAL_RESULT_DIR

# Step 4: Copy results from HDFS to local folder
hdfs dfs -get $HDFS_OUTPUT/* $LOCAL_RESULT_DIR/

echo "Error-focused log analysis complete!"
echo "Results stored in: $LOCAL_RESULT_DIR"
