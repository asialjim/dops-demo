#!/usr/bin/env bash
#
# Copyright 2014 - 2024 <a href="mailto:asialjim@hotmail.com">Asial Jim</a>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# 	http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

#发布端口
port=$1

#发布环境
env=$2

#根据端口号查询对应的pid
pid=$(netstat -nlp | grep :$port | awk '{print $7}' | awk -F"/" '{ print $1 }');

#判断进程是否存在，存在则杀死
if [  -n  "$pid"  ];  then
    kill  -9  $pid;
fi
# 用户目录
BACKEND=/home/backend
# 软件环境目录
WORK=${BACKEND}/${env}
# 软件环境日志
logName=${WORK}/logs/output.log
# 软件名称
APP=demo-1.0.0-SNAPSHOT.jar
# 要部署的软件
DEPLOY=${BACKEND}/deploy/${APP}

WORK=/home/backend/${env}
EXECUTE=${WORK}/${APP}
DEPLOY=${WORK}/${APP}
logName=${WORK}/logs/output.log

rm -rf ${EXECUTE}
mv ${DEPLOY} ${WORK}/
chmod 777 ${EXECUTE}

ACTIVE=db-${env},core,admin,wx,knife4j
PATH=/api/v1/wechat
CORN='0 0 19 * * ?'
nohup java -jar -DPORT=${port} -DPATH=${PATH} -DREMIND_DAY=-1 -DACTIVE=${ACTIVE} -DENABLE_VALIDATE=false -DNOTICE_CORN=${CORN} ${EXECUTE} > ${logName} 2>&1 &
