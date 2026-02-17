#!/bin/bash

echo "============================================"
echo "     Hadoop Performance Optimization  "
echo "============================================"

HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop

echo "[1] Creating Backup of Configuration Files..."
cp $HADOOP_CONF_DIR/hdfs-site.xml $HADOOP_CONF_DIR/hdfs-site.xml.bak
cp $HADOOP_CONF_DIR/mapred-site.xml $HADOOP_CONF_DIR/mapred-site.xml.bak
cp $HADOOP_CONF_DIR/yarn-site.xml $HADOOP_CONF_DIR/yarn-site.xml.bak

echo "[2] Applying HDFS Optimizations..."
cat > $HADOOP_CONF_DIR/hdfs-site.xml << EOL
<configuration>
    <!-- Increase block size -->
    <property>
        <name>dfs.block.size</name>
        <value>134217728</value> <!-- 128 MB -->
    </property>

    <!-- Replication factor (single node) -->
    <property>
        <name>dfs.replication</name>
        <value>1</value>
    </property>

    <!-- Improve NameNode memory -->
    <property>
        <name>dfs.namenode.handler.count</name>
        <value>20</value>
    </property>
</configuration>
EOL

echo "[3] Applying MapReduce Optimizations..."
cat > $HADOOP_CONF_DIR/mapred-site.xml << EOL
<configuration>
    <!-- Number of reducers -->
    <property>
        <name>mapreduce.job.reduces</name>
        <value>4</value>
    </property>

    <!-- Increase sort buffer memory -->
    <property>
        <name>mapreduce.task.io.sort.mb</name>
        <value>256</value>
    </property>

    <!-- Split size aligned with HDFS block size -->
    <property>
        <name>mapreduce.input.fileinputformat.split.maxsize</name>
        <value>134217728</value>
    </property>

    <property>
        <name>mapreduce.input.fileinputformat.split.minsize</name>
        <value>134217728</value>
    </property>
</configuration>
EOL

echo "[4] Applying YARN Resource Optimizations..."
cat > $HADOOP_CONF_DIR/yarn-site.xml << EOL
<configuration>

    <!-- NodeManager memory -->
    <property>
        <name>yarn.nodemanager.resource.memory-mb</name>
        <value>4096</value>
    </property>

    <!-- Maximum memory allocation per container -->
    <property>
        <name>yarn.scheduler.maximum-allocation-mb</name>
        <value>4096</value>
    </property>

    <!-- Minimum memory allocation per container -->
    <property>
        <name>yarn.scheduler.minimum-allocation-mb</name>
        <value>512</value>
    </property>

    <!-- CPU cores for NodeManager -->
    <property>
        <name>yarn.nodemanager.resource.cpu-vcores</name>
        <value>4</value>
    </property>

</configuration>
EOL

echo "[5] Restarting Hadoop Services..."
$HADOOP_HOME/sbin/stop-dfs.sh
$HADOOP_HOME/sbin/stop-yarn.sh
sleep 3
$HADOOP_HOME/sbin/start-dfs.sh
$HADOOP_HOME/sbin/start-yarn.sh

echo ""
echo "============================================"
echo " Optimization Completed Successfully! "
echo "============================================"
echo "Backups created as:"
echo " - hdfs-site.xml.bak"
echo " - mapred-site.xml.bak"
echo " - yarn-site.xml.bak"
echo ""
echo " $HADOOP_CONF_DIR/"
echo ""
