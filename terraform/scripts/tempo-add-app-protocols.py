#!/usr/bin/env python3
import yaml
import sys

def modify_yaml(yaml_data):
    # Load the YAML data
    docs = yaml.safe_load_all(yaml_data)

    for doc in docs:
        if doc['kind'] != 'Service':
            continue
        for port in doc.get('spec', {}).get('ports', []):
            port['appProtocol'] = port.get('appProtocol', '') or 'tcp'
        # Output the modified document
    yaml.dump(doc, sys.stdout)


if __name__ == '__main__':
    modify_yaml(sys.stdin.read())
