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
	# echo $x
	echo $x
	echo
	#cat $x
	echo
	
	# upload data through insights

	cluster_id=$(sed -ne 's/^.*node_name: "\(............\)_.*/\1/p' $x | head -1)
	#cluster_id=$(sed -ne 's/node_name: "\(............\)_.*/\1/pq' $x)
	ocp_cluster_id="ocp_${cluster_id}"
	#echo "Upload $x to $ocp_cluster_id"
	INSIGHTS_USER=insights-upload-rhte19mbu2org INSIGHTS_PASSWORD=yaR3dBRKg2iPkPy nise --ocp --ocp-cluster-id ${ocp_cluster_id}  --static-report-file $x --insights-upload https://cloud.redhat.com/api/ingress/v1/upload
	#echo "INSIGHTS_USER=insights-upload-rhte19mbu2org INSIGHTS_PASSWORD=REDACTED  nise --ocp --ocp-cluster-id ${ocp_cluster_id}  --static-report-file $x --insights-upload https://cloud.redhat.com/api/ingress/v1/upload"
	echo

	# create ocp source

	source_id=$(basename $x .yaml)

	JSON_STRING=$( jq -n \
		--arg nm "$source_id" \
		--arg cl "$ocp_cluster_id" \
		'{"name": $nm, "type": "OCP", "authentication": { "provider_resource_name": $cl, "credentials": null }, "billing_source": { "bucket": "", "data_source": null } }')

	echo "curl --user insights-upload-rhte19mbu2org:REDACTED -d '${JSON_STRING}'  -H 'Content-Type: application/json' https://cloud.redhat.com/api/cost-management/v1/providers/"
	curl -H 'Content-Type: application/json' --user insights-upload-rhte19mbu2org:yaR3dBRKg2iPkPy -d "${JSON_STRING}"  https://cloud.redhat.com/api/cost-management/v1/providers/

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
