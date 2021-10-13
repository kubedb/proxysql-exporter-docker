# Copyright The KubeDB Authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

FROM debian:stable as builder

ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN true

ARG TAG

RUN set -x \
  && apt-get update \
  && apt-get install -y --no-install-recommends apt-transport-https ca-certificates curl unzip

RUN set -x \
  && curl -fssL -O https://github.com/percona/proxysql_exporter/releases/download/${TAG}/proxysql_exporter_linux_amd64.tar.gz \
  && tar -xzvf proxysql_exporter_linux_amd64.tar.gz \
  && chmod +x proxysql_exporter

FROM alpine:latest

COPY --from=builder proxysql_exporter /bin/proxysql_exporter

EXPOSE 9216

ENTRYPOINT  [ "/bin/proxysql_exporter" ]
