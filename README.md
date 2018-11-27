# Ackee Packer Elasticsearch image + GCS backup plugin

It should be deployed with Terraform module from `tf/es` folder

This image is build on top of official Ubuntu 16.04 image with these extras preinstalled :
* GCS repository plugin for backups - https://www.elastic.co/guide/en/elasticsearch/plugins/6.4/repository-gcs.html
* GCE discovery plugin for hosts discovery - https://www.elastic.co/guide/en/elasticsearch/plugins/6.4/discovery-gce-usage-long.html
* Stackdriver agent for advanced Stackdriver monitoring
* Google fluentd plugin for Stackdriver logs ingestion