#!/bin/bash

out_path=$1

function prepare_patch_service_port(){
    # Clear directory from previous results
    rm -f $out_path/gen_*

    for namespace in $(kubectl get ns --no-headers | cut -d " " -f1); do
        for service in $(kubectl get svc -n "$namespace" --no-headers | cut -d " " -f1); do
            # Get the current service definition in JSON format
            local service_json=$(kubectl get svc $service -n $namespace -o json)

            # Prepare the modified JSON
            local modified_json=$(echo $service_json | jq '
            .spec.ports |= map(
                if (.name | type != "string") then .
                elif (.appProtocol | type == "string") then .
                elif (.name | test("^(http|http2|https|grpc)\\b")) then .
                elif (.name | test("https")) then .appProtocol = "https"
                elif (.name | test("http2")) then .appProtocol = "http2"
                elif (.name | test("grpc")) then .appProtocol = "grpc"
                elif (.name | test("http")) then .appProtocol = "http"
                elif ((.targetPort | type == "string") and (.targetPort | contains("https"))) then .appProtocol = "https"
                elif ((.targetPort | type == "string") and (.targetPort | contains("http2"))) then .appProtocol = "http2"
                elif ((.targetPort | type == "string") and (.targetPort | contains("http"))) then .appProtocol = "http"
                elif ((.targetPort | type == "string") and (.targetPort | contains("grpc"))) then .appProtocol = "grpc"
                else . end
            )')
            # local modified_json=$(echo $service_json | jq '
            # .spec.ports |= map(
            #     if (.name | type != "string") then .
            #     elif (.name | test("^(http|http2|https|grpc)\\b")) then .
            #     elif (.name | test("https")) then .name |= (gsub("-?(http|http2|https|grpc)\\b"; "") | ("https-" + .))
            #     elif (.name | test("http2")) then .name |= (gsub("-?(http|http2|https|grpc)\\b"; "") | ("http2-" + .))
            #     elif (.name | test("grpc")) then .name |= (gsub("-?(http|http2|https|grpc)\\b"; "") | ("grpc-" + .))
            #     elif (.name | test("http")) then .name |= (gsub("-?(http|http2|https|grpc)\\b"; "") | ("http-" + .))
            #     elif ((.targetPort | type == "string") and (.targetPort | contains("https"))) then .name = "https-" + .name
            #     elif ((.targetPort | type == "string") and (.targetPort | contains("http2"))) then .name = "http2-" + .name
            #     elif ((.targetPort | type == "string") and (.targetPort | contains("http"))) then .name = "http-" + .name
            #     elif ((.targetPort | type == "string") and (.targetPort | contains("grpc"))) then .name = "grpc-" + .name
            #     else . end
            # )')

            local original_file=$(mktemp)
            local modified_file=$(mktemp)
            echo "$service_json" | jq .spec.ports > "$original_file"
            echo "$modified_json" | jq .spec.ports > "$modified_file"

            # Compare the original and the modified JSON
            local diff_output=$(diff "$original_file" "$modified_file")

            if [ -n "$diff_output" ]; then
                echo "Differences for service $service in namespace $namespace found"
                echo "$diff_output"
                echo $modified_json | jq > "$out_path/gen_${namespace}_service_${service}.json"
                echo "---------------------------"
            fi

            # Cleanup temporary files
            rm -f "$original_file" "$modified_file"
        done
    done
}

prepare_patch_service_port
