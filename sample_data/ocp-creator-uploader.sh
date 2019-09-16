for x in static-report-files/ocp_sample_*.yaml 
do
	# provider_resource_name
	provider_resource_name=$(sed -ne 's/^.*openshift_cluster: "\(.*\)"/\1/p' $x | head -1)
	provider_name=$(basename $x .yaml)
	

	# create OCP provider
	JSON_STRING=$( jq -n \
		--arg nm "$provider_name" \
		--arg cl "$provider_resource_name" \
		'{"name": $nm, "type": "OCP", "authentication": { "provider_resource_name": $cl, "credentials": null }, "billing_source": { "bucket": "", "data_source": null } }')

	echo "### Creating OCP provider from file $x"
	echo "curl --user insights-upload-rhte19mbu2org:REDACTED -d ${JSON_STRING}  -H 'Content-Type: application/json' https://cloud.redhat.com/api/cost-management/v1/providers/"
        exit 1
	UUID=$(curl -s -H 'Content-Type: application/json' --user insights-upload-rhte19mbu2org:yaR3dBRKg2iPkPy -d "${JSON_STRING}"  https://cloud.redhat.com/api/cost-management/v1/providers/ | jq -r '.uuid' )
	echo "UUID is $UUID of provider_resource_name ${provider_resource_name} and provider_name ${provider_name}"

	# upload data through insights
	echo "### Upload $x to $ocp_cluster_id"
	echo "INSIGHTS_USER=insights-upload-rhte19mbu2org INSIGHTS_PASSWORD=REDACTED  nise --ocp --ocp-cluster-id ${provider_resource_name}  --static-report-file $x --insights-upload https://cloud.redhat.com/api/ingress/v1/upload"
	INSIGHTS_USER=insights-upload-rhte19mbu2org INSIGHTS_PASSWORD=yaR3dBRKg2iPkPy nise --ocp --ocp-cluster-id ${provider_resource_name}  --static-report-file $x --insights-upload https://cloud.redhat.com/api/ingress/v1/upload
	echo
done

