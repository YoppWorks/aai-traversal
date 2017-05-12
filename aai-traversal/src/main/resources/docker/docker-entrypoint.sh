###
# ============LICENSE_START=======================================================
# org.openecomp.aai
# ================================================================================
# Copyright (C) 2017 AT&T Intellectual Property. All rights reserved.
# ================================================================================
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#      http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# ============LICENSE_END=========================================================
###

cd /opt/app/aai-traversal;

TITAN_CACHED="/opt/app/aai-traversal/bundleconfig/etc/appprops/titan-cached.properties";
TITAN_REALTIME="/opt/app/aai-traversal/bundleconfig/etc/appprops/titan-realtime.properties";
SERVER_HOST=${SERVER_HOST:-localhost};
SERVER_TABLE=${SERVER_TABLE:-aaigraph-dev02};

sed -i 's/^storage.backend=inmemory/storage.backend=hbase/g' $TITAN_CACHED $TITAN_REALTIME;
sed -i "s/^storage.hostname=.*$/storage.hostname=${SERVER_HOST}/g" $TITAN_CACHED $TITAN_REALTIME;
sed -i "s/^storage.hbase.table=.*$/storage.hbase.table=${SERVER_TABLE}/g" $TITAN_CACHED $TITAN_REALTIME;

/opt/app/aai-traversal/bin/createDBSchema.sh;

java -cp ${CLASSPATH}:/opt/app/commonLibs/*:/opt/app/aai-traversal/etc:/opt/app/aai-traversal/lib/*:/opt/app/aai-traversal/extJars/logback-access-1.1.7.jar:/opt/app/aai-traversal/extJars/logback-core-1.1.7.jar:/opt/app/aai-traversal/extJars/aai-core-${AAI_CORE_VERSION}.jar -server -XX:NewSize=512m -XX:MaxNewSize=512m -XX:SurvivorRatio=8 -XX:+DisableExplicitGC -verbose:gc -XX:+UseParNewGC -XX:+CMSParallelRemarkEnabled -XX:+CMSClassUnloadingEnabled -XX:+UseConcMarkSweepGC -XX:-UseBiasedLocking -XX:ParallelGCThreads=4 -XX:LargePageSizeInBytes=128m -XX:+PrintGCDetails -XX:+PrintGCTimeStamps -Dsun.net.inetaddr.ttl=180 -XX:+HeapDumpOnOutOfMemoryError -Dhttps.protocols=TLSv1.1,TLSv1.2 -DSOACLOUD_SERVICE_VERSION=1.0.1 -DAJSC_HOME=/opt/app/aai-traversal/ -DAJSC_CONF_HOME=/opt/app/aai-traversal/bundleconfig -DAJSC_SHARED_CONFIG=/opt/app/aai-traversal/bundleconfig -DAFT_HOME=/opt/app/aai-traversal -DAAI_CORE_VERSION=${AAI_CORE_VERSION} -Daai-core.version=${AAI_CORE_VERSION} -Dlogback.configurationFile=/opt/app/aai-traversal/bundleconfig/etc/logback.xml -Xloggc:/opt/app/aai-traversal/logs/ajsc-jetty/gc/graph-query_gc.log com.att.ajsc.runner.Runner context=/ port=8086 sslport=8446
