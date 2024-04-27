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
            # idk why
            calculatedAppProtocol = 'tcp'
        port['appProtocol'] = calculatedAppProtocol


def modify_service(doc, mapper):
    if doc['kind'] == 'Service':
        mapper(doc)

def modify_yaml(yaml_data):
    with open("debug_grafana-tempo-distributed.yaml", "w") as f:
        f.write(yaml_data)

    docs = yaml.safe_load_all(yaml_data)
    modified_docs = []
    for doc in docs:
        modify_service(doc, add_app_protocol)
        modified_docs.append(doc)
    yaml_dump = yaml.dump_all(modified_docs, default_flow_style=False, sort_keys=False)
    with open("debug_grafana-tempo-distributed-modified.yaml", "w") as f:
        f.write(yaml_dump)
    sys.stdout.write(yaml_dump)

if __name__ == '__main__':
    modify_yaml(sys.stdin.read())
