nise --aws --static-report-file .//aws_gpte_sample_ILT.yaml
nise --ocp --ocp-cluster-id gpte-sample-cluster --static-report-file ocp_gpte_sample_ILT.yaml

nise --aws --static-report-file .//aws_gpte_sample_ILT.yaml --aws-s3-bucket-name cost-test-bucket  --aws-s3-report-name cur
INSIGHTS_USER=insights-upload-rhte19mbu1org INSIGHTS_PASSWORD=yaR3dBRKg2iPkPy nise --ocp --ocp-cluster-id cost-test-1 --static-report-file ocp_gpte_sample_ILT.yaml --insights-upload https://cloud.redhat.com/api/ingress/v1/upload
