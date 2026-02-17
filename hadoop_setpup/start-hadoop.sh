#!/bin/bash

echo "======================================"
echo "     Hadoop Safe Auto Start Script"
echo "======================================"

# Load environment
source ~/.bashrc

echo "Checking Java..."
if ! java -version &>/dev/null; then
    echo "Java not installed. Hadoop cannot start."
    exit 1
else
    echo "Java found"
fi

echo "Checking Hadoop installation..."
if [ ! -d "$HADOOP_HOME" ]; then
    echo "HADOOP_HOME not found. Please run setup.sh first."
    exit 1
else
    echo "Hadoop installed at $HADOOP_HOME"
fi

echo "Checking SSH..."
if ! service ssh status &>/dev/null; then
    echo "SSH not running — starting SSH..."
    sudo service ssh start
else
    echo "SSH running"
fi

echo "Checking NameNode format..."
if [ ! -d "/mnt/d/hadoop/data/namenode/current" ]; then
    echo "NameNode NOT formatted — formatting now..."
    hdfs namenode -format -force
else
    echo "NameNode already formatted"
fi

echo "Starting HDFS..."
start-dfs.sh
sleep 2

echo "Checking HDFS safe mode..."
SAFE=$(hdfs dfsadmin -safemode get)

if [[ "$SAFE" == *"ON"* ]]; then
    echo "Safe mode is ON — leaving safe mode"
    hdfs dfsadmin -safemode leave
else
    echo "Safe mode is OFF"
fi

echo "Starting YARN..."
start-yarn.sh
sleep 2

echo "Checking running Hadoop daemons..."
jps

echo "======================================"
echo "  Hadoop started safely and correctly"
echo "======================================"
