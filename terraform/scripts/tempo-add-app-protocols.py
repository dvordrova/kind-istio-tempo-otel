#!/usr/bin/env python3
import yaml
import sys

def add_app_protocol(service):
    for port in service.get('spec', {}).get('ports', []):
        calculatedAppProtocol = port.get('appProtocol', '') or 'tcp'
        for protocol in ['https', 'http2', 'grpc', 'http']:
            if protocol in port['name'] or protocol in str(port['targetPort']):
                calculatedAppProtocol = protocol
        if port['name'] == 'gossip-ring':
            port['appProtocol'] = port.get('appProtocol', '') or 'tcp'
        else:
            port['appProtocol'] = calculatedAppProtocol


def modify_service(doc, mapper):
    if doc['kind'] == 'Service':
        mapper(doc)

def modify_yaml(yaml_data):
    with open("grafana-tempo-distributed.yaml", "w") as f:
        f.write(yaml_data)

    yaml_data = yaml_data.replace('dns+tempo-gossip-ring:7946', 'dns+tempo-gossip-ring.monitoring.svc.cluster.local:7946')
    docs = yaml.safe_load_all(yaml_data)
    modified_docs = []
    for doc in docs:
        modify_service(doc, add_app_protocol)
        modified_docs.append(doc)
    yaml_dump = yaml.dump_all(modified_docs, default_flow_style=False, sort_keys=False)
    with open("grafana-tempo-distributed-modified.yaml", "w") as f:
        f.write(yaml_dump)
    sys.stdout.write(yaml_dump)

if __name__ == '__main__':
    modify_yaml(sys.stdin.read())
