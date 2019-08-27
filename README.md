= Red Hat Tech Exchange 2019

== A2003 Hybrid Cloud Management - Cost Management on AWS - rhte2019-maa-hcm-cost-aws

Welcome to the 2019 HCM Cost Management with OpenShift and AWS Lab

Red Hat is in the midsts of developing SaaS offerings for our customer base. One of the first ones will be Cost Management.

Cost Management uses OpenShift labels and AWS tags to bind together the Business initiatives of an organization with the actual expenditures of the technology infrastructure.

Red Hatters will need to learn the basic financial terminology and the problem domains that this product seeks to solve, including:

* Budgeting
* Forecasting
* Workload Optimization

=== Goals

In this lab you will:

* Walk through the setup of the Metering Operator on your own cluster
* Add your cluster as a "source" for cost related information to the Account
* Use labels and tags to associate OpenShift resources with AWS resource tags.
* Analyse of the existing Account's current costs per Business Initiative
* Forecast the cost of the Business's proposed Initiatives

[WARNING]
This product is in the ALPHA state.  Not all features are expected to work.  Your suggestions for improvements and features are welcome.

=== Infrastructure

* Your OCP4 Cluster - one small OCP4 cluster.
* Your AWS Sandbox Account
* The Cost Management BU's Account on https://cloud.openshift.com

=== Prerequisites

. Get a GUID from the GUIDGrabber. This is the GUID of your personal cluster.
* Cluster 1 has a bastion VM that you will use to execute all tasks.
* GUIDGrabber will show the command to connect to the bastion VM.
* Your cluster runs in a Sandbox. Make a note of the Sandbox Number.
** For example if GUIDGrabber shows the following command:
+
[source,sh]
----
ssh lab-user@bastion.b1fa.sandbox23.opentlc.com
----
+
this means that your GUID is b1fa and your Sandbox Number is 23.


