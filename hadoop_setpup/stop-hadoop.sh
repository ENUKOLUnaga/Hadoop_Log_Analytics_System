#!/bin/bash

echo "========================================"
echo "      Hadoop Safe Auto-Stop Script"
echo "========================================"

# Load environment
source ~/.bashrc

echo "Checking if Hadoop is running..."
RUNNING=$(jps | wc -l)

if [ "$RUNNING" -le 1 ]; then
    echo "Hadoop is already stopped"
    exit 0
else
    echo "Hadoop daemons detected, stopping..."
fi

echo "Stopping YARN..."
stop-yarn.sh

sleep 2

echo "Stopping HDFS..."
stop-dfs.sh

sleep 2

echo "Checking remaining Hadoop daemons..."
jps

echo ""

if jps | grep -q "NameNode\|DataNode\|ResourceManager\|NodeManager\|SecondaryNameNode"; then
    echo "WARNING: Some Hadoop processes are still running!"
    echo "You may need to stop them manually:"
    echo ""
    jps | grep "NameNode\|DataNode\|ResourceManager\|NodeManager\|SecondaryNameNode"
else
    echo "All Hadoop daemons have stopped successfully"
fi

echo ""
echo "Checking leftover Java processes..."
ps -ef | grep java | grep -v grep

echo "========================================"
echo "      Hadoop Safe Shutdown Complete"
echo "========================================"
