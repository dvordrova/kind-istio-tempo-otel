#!/usr/bin/env python3
import yaml
import sys

def modify_yaml(yaml_data):
    docs = yaml.safe_load_all(yaml_data)
    modified_docs = []

    for doc in docs:
        if doc['kind'] == 'Service':
            for port in doc.get('spec', {}).get('ports', []):
                port['appProtocol'] = port.get('appProtocol', '') or 'tcp'
        modified_docs.append(doc)
    yaml.dump_all(modified_docs, sys.stdout, default_flow_style=False, sort_keys=False)

if __name__ == '__main__':
    modify_yaml(sys.stdin.read())
