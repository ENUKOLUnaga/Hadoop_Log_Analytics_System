#!/bin/bash

# Variables
LOCAL_LOG_FILE="biglog.log"
HDFS_DIR="/user/nagendra/logs"
HDFS_FILE="$HDFS_DIR/$LOCAL_LOG_FILE"
SMALL_LOG_PATTERN="log_pattern.txt"
TARGET_SIZE_GB=1.8
BLOCK_SIZE_MB=128

echo "=== Large Log File Scalability Test ==="

# Step 1: Create small log pattern if not exists
if [ ! -f "$SMALL_LOG_PATTERN" ]; then
    echo '"GET /index.html 200"' > $SMALL_LOG_PATTERN
    echo '"POST /login 302"' >> $SMALL_LOG_PATTERN
    echo '"DELETE /user/123 200"' >> $SMALL_LOG_PATTERN
fi

# Step 2: Generate large log file
echo "Generating large log file (~$TARGET_SIZE_GB GB)..."

# Calculate number of lines to write
FILE_SIZE_BYTES=$(echo "$TARGET_SIZE_GB * 1024 * 1024 * 1024" | bc)
LINE_SIZE_BYTES=$(stat -c%s $SMALL_LOG_PATTERN)
LINES_TO_WRITE=$(echo "$FILE_SIZE_BYTES / $LINE_SIZE_BYTES" | bc)

# Generate the file
yes "$(cat $SMALL_LOG_PATTERN)" | head -n $LINES_TO_WRITE > $LOCAL_LOG_FILE

echo "Large log file created: $LOCAL_LOG_FILE"
ls -lh $LOCAL_LOG_FILE

# Step 3: Upload to HDFS
hdfs dfs -mkdir -p $HDFS_DIR
hdfs dfs -put -f $LOCAL_LOG_FILE $HDFS_FILE

# Step 4: Check HDFS blocks
echo "Checking HDFS file blocks..."
hdfs fsck $HDFS_FILE -files -blocks -locations

NUM_BLOCKS=$(hdfs fsck $HDFS_FILE | grep "Total blocks" | awk '{print $3}')
echo "Number of HDFS blocks created: $NUM_BLOCKS"

echo "Analysis Notes:"
echo "- HDFS block size: $BLOCK_SIZE_MB MB"
echo "- Number of blocks = ceil(file_size / block_size)"
echo "- More blocks -> better parallelism"
echo "- Smaller blocks -> more metadata overhead, inefficient for small files"
echo "- Larger blocks -> fewer blocks, less metadata, may reduce parallelism"

echo "=== Script Finished ==="
