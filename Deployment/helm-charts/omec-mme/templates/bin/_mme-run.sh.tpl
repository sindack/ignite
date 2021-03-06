#!/bin/bash
#
# Copyright 2019-present Open Networking Foundation
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

APPLICATION=$1

{{- if .Values.config.coreDump.enabled }}
cp /openmme/target/bin/$APPLICATION /tmp/coredump/
{{- end }}

# copy config files to openmme target directly
cp /opt/mme/config/shared/* /openmme/target/conf/
sleep 1

cd /openmme/target
export LD_LIBRARY_PATH=/usr/local/lib:./lib

case $APPLICATION in
    "mme-app")
      export MMERUNENV="container"
      echo "Starting mme-app"
      echo "conf/mme.json"
      cat conf/mme.json
       /usr/sbin/sshd -D &
      ./bin/mme-app
      ;;
    "s1ap-app")
      export MMERUNENV="container"
      echo "Starting s1ap-app"
      echo "conf/s1ap.json"
      cat conf/s1ap.json
      ./bin/s1ap-app
      ;;
    "s6a-app")
      export MMERUNENV="container"
      echo "Starting s6a-app"
      echo "conf/s6a.json"
      cat conf/s6a.json
      echo "conf/s6a_fd.conf"
      cat conf/s6a_fd.conf
      ./bin/s6a-app
      ;;
    "s11-app")
      export MMERUNENV="container"
      echo "Starting s11-app"
      echo "conf/s11.json"
      cat conf/s11.json
      ./bin/s11-app
      ;;
    *)
      echo "invalid app $APPLICATION"
      ;;
esac
