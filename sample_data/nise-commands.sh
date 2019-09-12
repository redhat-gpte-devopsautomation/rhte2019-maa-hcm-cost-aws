#  nise --aws --static-report-file .//aws_gpte_sample_ILT.yaml
#  nise --ocp --ocp-cluster-id gpte-sample-cluster --static-report-file ocp_gpte_sample_ILT.yaml
#  
#  nise --aws --static-report-file .//aws_gpte_sample_ILT.yaml --aws-s3-bucket-name cost-test-bucket  --aws-s3-report-name cur
#  INSIGHTS_USER=insights-upload-rhte19mbu1org INSIGHTS_PASSWORD=yaR3dBRKg2iPkPy nise --ocp --ocp-cluster-id cost-test-1 --static-report-file ocp_gpte_sample_ILT.yaml --insights-upload https://cloud.redhat.com/api/ingress/v1/upload
#  
#  
#  INSIGHTS_USER=insights-upload-rhte19mbu2org INSIGHTS_PASSWORD=yaR3dBRKg2iPkPy nise --ocp --ocp-cluster-id ocp-cluster-example-1 --static-report-file ocp_gpte_sample_ILT.yaml --insights-upload https://cloud.redhat.com/api/ingress/v1/upload
#  
 # csplit -f "ocp_sample_" -n4 -b "%04d.yaml"  ocp_source_gpte_sample_ILT.yaml /---/ {*} 
  # iterate over all data to upload OCP clusters


for x in static-report-files/ocp_sample_0{270..285}.yaml 
do
	# provider_resource_name
	cluster_id=$(sed -ne 's/^.*node_name: "\(............\)_.*/\1/p' $x | head -1)
	provider_resource_name="ocp_${cluster_id}"
	
	provider_name=$(basename $x .yaml)

	JSON_STRING=$( jq -n \
		--arg nm "$provider_name" \
		--arg cl "$provider_resource_name" \
		'{"name": $nm, "type": "OCP", "authentication": { "provider_resource_name": $cl, "credentials": null }, "billing_source": { "bucket": "", "data_source": null } }')

	echo "### Creating OCP Source from file $x"
	echo "curl --user insights-upload-rhte19mbu2org:REDACTED -d '${JSON_STRING}'  -H 'Content-Type: application/json' https://cloud.redhat.com/api/cost-management/v1/providers/"
	UUID=$(curl -s -H 'Content-Type: application/json' --user insights-upload-rhte19mbu2org:yaR3dBRKg2iPkPy -d "${JSON_STRING}"  https://cloud.redhat.com/api/cost-management/v1/providers/ | jq -r '.uuid' )
	echo "UUID is $UUID of provider_resource_name ${provider_resource_name} and provider_name ${provider_name}"



	# upload data through insights

	#echo "Upload $x to $ocp_cluster_id"
	echo "INSIGHTS_USER=insights-upload-rhte19mbu2org INSIGHTS_PASSWORD=REDACTED  nise --ocp --ocp-cluster-id ${UUID}  --static-report-file $x --insights-upload https://cloud.redhat.com/api/ingress/v1/upload"
	INSIGHTS_USER=insights-upload-rhte19mbu2org INSIGHTS_PASSWORD=yaR3dBRKg2iPkPy nise --ocp --ocp-cluster-id ${UUID}  --static-report-file $x --insights-upload https://cloud.redhat.com/api/ingress/v1/upload
	echo


#{
#    "name": "",
#    "type": OCP,
#    "authentication": {
#        "provider_resource_name": "UUID goes here",
#        "credentials": null
#    },
#    "billing_source": {
#        "bucket": "",
#        "data_source": null
#    }
#}

done

# delete all OCP providers
exit 0;
[ec2-user@clientvm ~]$ curl  -o uuids2.json --user insights-upload-rhte19mbu2org:yaR3dBRKg2iPkPy https://cloud.redhat.com/api/cost-management/v1/providers/?type=OCP
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   211  100   211    0     0    177      0  0:00:01  0:00:01 --:--:--   177
[ec2-user@clientvm ~]$ for x in $(cat uuids2.json| jq '.data[] .uuid' | sed -e 's/"//g'); do curl -X DELETE --user insights-upload-rhte19mbu2org:yaR3dBRKg2iPkPy https://cloud.redhat.com/api/cost-management/v1/providers/$x/; done
