#!/bin/bash

echo "======================================"
echo "      Hadoop Pseudo Cluster Setup     "
echo "======================================"

# STEP 1: INSTALL JAVA
if ! java -version &>/dev/null; then
    echo "Installing Java..."
    sudo apt update -y
    sudo apt install openjdk-11-jdk -y
else
    echo "Java already installed"
fi

JAVA_HOME="/usr/lib/jvm/java-11-openjdk-amd64"

if ! grep -q "JAVA_HOME" ~/.bashrc; then
    echo "export JAVA_HOME=$JAVA_HOME" >> ~/.bashrc
    echo "export PATH=\$PATH:\$JAVA_HOME/bin" >> ~/.bashrc
fi

source ~/.bashrc

# STEP 2: DOWNLOAD HADOOP
if [ ! -d "$HOME/hadoop" ]; then
    echo "Downloading Hadoop..."
    wget https://downloads.apache.org/hadoop/common/hadoop-3.3.6/hadoop-3.3.6.tar.gz -P ~/
    tar -xvzf ~/hadoop-3.3.6.tar.gz -C ~/
    mv ~/hadoop-3.3.6 ~/hadoop
else
    echo "Hadoop already downloaded"
fi

export HADOOP_HOME="$HOME/hadoop"
export PATH="$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin"

# STEP 3: CREATE DATA DIRECTORIES
mkdir -p /mnt/d/hadoop/data/namenode
mkdir -p /mnt/d/hadoop/data/datanode

# STEP 4: CONFIGURE Hadoop ENV
HADOOP_ENV="$HADOOP_HOME/etc/hadoop/hadoop-env.sh"
if ! grep -q "JAVA_HOME" $HADOOP_ENV; then
    echo "export JAVA_HOME=$JAVA_HOME" >> $HADOOP_ENV
    echo "JAVA_HOME added to hadoop-env.sh"
else
    echo "JAVA_HOME already present in hadoop-env.sh"
fi

# STEP 5: core-site.xml
CORE_SITE=$HADOOP_HOME/etc/hadoop/core-site.xml
cat <<EOF > $CORE_SITE
<configuration>
  <property>
    <name>fs.defaultFS</name>
    <value>hdfs://localhost:9000</value>
  </property>
</configuration>
EOF
echo "core-site.xml configured"

# STEP 6: hdfs-site.xml
HDFS_SITE=$HADOOP_HOME/etc/hadoop/hdfs-site.xml
cat <<EOF > $HDFS_SITE
<configuration>

  <property>
    <name>dfs.replication</name>
    <value>1</value>
  </property>

  <property>
    <name>dfs.namenode.name.dir</name>
    <value>file:/mnt/d/hadoop/data/namenode</value>
  </property>

  <property>
    <name>dfs.datanode.data.dir</name>
    <value>file:/mnt/d/hadoop/data/datanode</value>
  </property>

</configuration>
EOF
echo "hdfs-site.xml configured"

# STEP 7: mapred-site.xml
MAPRED_SITE=$HADOOP_HOME/etc/hadoop/mapred-site.xml
cat <<EOF > $MAPRED_SITE
<configuration>
  <property>
    <name>mapreduce.framework.name</name>
    <value>yarn</value>
  </property>
</configuration>
EOF
echo "mapred-site.xml configured"

# STEP 8: yarn-site.xml
YARN_SITE=$HADOOP_HOME/etc/hadoop/yarn-site.xml
cat <<EOF > $YARN_SITE
<configuration>
  <property>
    <name>yarn.nodemanager.aux-services</name>
    <value>mapreduce_shuffle</value>
  </property>
</configuration>
EOF
echo "yarn-site.xml configured"

# STEP 9: SSH Setup
echo "Checking SSH..."

if ! command -v ssh >/dev/null; then
    sudo apt install -y openssh-server
fi

sudo service ssh start

if [ ! -f ~/.ssh/id_rsa ]; then
    ssh-keygen -t rsa -P "" -f ~/.ssh/id_rsa
    cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
    chmod 600 ~/.ssh/authorized_keys
fi

# STEP 10: Format NameNode
if [ ! -d "/mnt/d/hadoop/data/namenode/current" ]; then
    echo "Formatting NameNode..."
    hdfs namenode -format
else
    echo "NameNode already formatted"
fi

echo "======================================"
echo "      HADOOP SETUP COMPLETED"
echo "======================================"
