# Hadoop-Based Log Analytics System
## Project Overview

This project demonstrates how Hadoop can be used to process large-scale web access logs for analytics in a growing enterprise. It covers cluster setup, log ingestion, HDFS behavior, MapReduce processing, Python streaming jobs, advanced log analysis, Hadoop architecture study, and configuration tuning.

### Dataset used:
Kaggle – Website Access Log Dataset
https://www.kaggle.com/datasets/avinhok/website-log-access

### Phase 1: Hadoop Environment Setup
#### Implementation 

- Installed Hadoop (pseudo-distributed mode) in Ubuntu/WSL.

- Configured core-site, hdfs-site, mapred-site, yarn-site.

- Set JAVA_HOME and Hadoop environment variables.

- Formatted HDFS and started NameNode, DataNode, ResourceManager, NodeManager.

- Verified running daemons using jps.

- Performed basic HDFS operations (upload, list, read).

### Phase 2: Log Ingestion & HDFS Block Analysis
#### Task 2: Small Log File Analysis

- Uploaded a small log file to HDFS.

- Observed block allocation using HDFS fsck.

- Analyzed how small files consume full block space (128 MB).

- Identified inefficiencies: NameNode metadata overhead, low parallelism.

### Task 3: Large Log File Scalability Test

- Generated a large (1–2 GB) log file.

- Uploaded it to HDFS.

- Observed multiple HDFS blocks created (≈15 blocks for 1.8 GB).

#### Analyzed:

- More blocks -> more parallel mappers.

- Better fault tolerance.

- More metadata overhead but improved performance.

### Phase 3: Built-in MapReduce WordCount
#### Implementation 

- Executed Hadoop’s built-in WordCount example using log data in HDFS.

- Mappers launched = number of HDFS input blocks.

- Observed shuffle, sorting, and reducer behavior.

- Verified output stored in HDFS.

### Phase 4: Python MapReduce Using Hadoop Streaming

- Implemented custom Python mapper & reducer for WordCount.

- Executed the job using Hadoop Streaming.

- Compared performance with built-in WordCount:

  - Python: easier to modify, slower execution.

  - Java: faster, optimized, less flexible.

### Phase 5: Error-Focused Log Analysis (HTTP 400+)
#### Enhancements Implemented

- Modified mapper to extract only error-related log entries.

### Counted:

- Frequency of error status codes.

- Endpoints generating most errors.

- Observed improved performance due to early filtering.

- Designed reducers to aggregate filtered data.

### Phase 6: Hadoop Architecture Evolution Study

- Hadoop 1.x:

  - JobTracker + TaskTracker bottlenecks.

  - Limited scalability & single point of failure.

- Hadoop 2.x:

  - YARN introduced with ResourceManager & NodeManager.

  - Improved resource management and multi-framework support.

- Hadoop 3.x:

  - Erasure coding to reduce storage overhead.

  - NameNode high availability improvements.

  - Better scalability and performance.

### Phase 7: Hadoop Configuration & Performance Tuning
#### Reviewed:

- HDFS tuning (block size, replication, NameNode memory).

- MapReduce tuning (mapper/reducer memory, sort buffer).

- YARN resource allocation (containers, vcores, RAM limits).

#### Outcome

- Recommended configuration changes for:

  - Better parallelism.

  - Faster job execution.

  - Optimal resource usage.

## Conclusion

- Successfully built an end-to-end Hadoop-based log analytics system.

- Demonstrated scalability from small to large log files.

- Showed performance differences between built-in and Python streaming jobs.

- Gained insights into HDFS behavior, YARN resource allocation, and MapReduce execution.

- Documented the evolution of Hadoop architecture and applied performance optimizations.
