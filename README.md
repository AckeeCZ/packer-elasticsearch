# Ackee GCP Elasticsearch image with GCE discovery service + GCS backup plugin

This [Packer](https://www.packer.io/) image template is meant to be used together with https://github.com/AckeeDevOps/docker-elasticsearch, which will utilize preinstalled GCE discovery plugin for Elasticsearch and will make cluster ES cluster available from GKE cluster.

There is also Terraform module which should handle the deployment and orchestration of GCE instances and creation of Service account for backup : [Ackee ElasticSearch Terraform module](https://github.com/AckeeCZ/terraform-elasticsearch) 

This image is build on top of official Ubuntu 16.04 image with these extras preinstalled :
* GCS repository plugin for backups - https://www.elastic.co/guide/en/elasticsearch/plugins/6.4/repository-gcs.html
* GCE discovery plugin for hosts discovery - https://www.elastic.co/guide/en/elasticsearch/plugins/6.4/discovery-gce-usage-long.html
* Stackdriver agent for advanced Stackdriver monitoring
* Google fluentd plugin for Stackdriver logs ingestion

## Backing up

Starting with ES version 6.4 you can't use "application default credentials", so you must create Service Account and insert it to elasticsearch-keystore - this can be automated by Terraform module mentioned before.

### Define GCS repository

*You have to do this before first backup*

    curl -XPUT http://elasticsearch:9200/_snapshot/ackee-%PROJECT_NAME%-backup?pretty -H 'Content-Type: application/json' -d '{
        "type": "gcs",
        "settings": {
            "bucket": "ackee-%PROJECT_NAME%-backup",
            "base_path": "es_backup" 
        }
    }'
