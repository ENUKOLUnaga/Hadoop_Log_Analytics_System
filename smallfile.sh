#!/bin/bash

echo "===  Small Log File Storage (Custom File) ==="

# 1. Variables — customize your file name & HDFS path
LOCAL_FILE="logfiles.log"
HDFS_DIR="/user/nagendra/logs"
HDFS_FILE="$HDFS_DIR/logfiles.log"

echo "Using local file: $LOCAL_FILE"
echo "Uploading to HDFS path: $HDFS_FILE"

# 2. Check if local file exists
if [ ! -f "$LOCAL_FILE" ]; then
    echo "ERROR: Local file '$LOCAL_FILE' does not exist!"
    exit 1
fi

# 3. Create HDFS directory (if not exists)
echo "Creating HDFS directory if not present..."
hdfs dfs -mkdir -p $HDFS_DIR

# 4. Upload file to HDFS
echo "Uploading file to HDFS..."
hdfs dfs -put -f $LOCAL_FILE $HDFS_DIR

# 5. Show file details
echo "HDFS File details:"
hdfs dfs -ls $HDFS_FILE

# 6. Block-level information
echo "Checking HDFS block information..."
hdfs fsck $HDFS_FILE -files -blocks -locations

echo ""
echo "=== Expected Analysis ==="
echo "Small files (few KB or MB) occupy an entire 128MB HDFS block."
echo "This causes:"
echo " - Increased NameNode memory usage"
echo " - Reduced efficiency for large-scale workloads"
echo " - Poor MapReduce parallelism"
