## Datastax AI stack (Azure) without a custom domain

## Table of contents

1. [Overview](#1-overview)
2. [Installation and Prerequisites](#2-installation-and-prerequisites)
3. [Setup](#3-setup)
4. [Deployment](#4-deployment)
5. [Cleanup](#5-cleanup)

## 1. Overview

### 1.1 - About this module

Terraform module which helps you quickly deploy an opinionated AI/RAG stack to your cloud provider of choice, provided by Datastax.

It offers multiple easy-to-deploy components, including:
 - Langflow
 - Astra Assistants API
 - Vector databases

### 1.2 - About this example

This example uses the Azure variant of the module, and allows you to deploy langflow/assistants easily using Container Apps, using a custom domain.

There are a couple ways to go about this:
- The more managed way, where you provide an Azure DNS hosted zone, and we handle the rest, or
- The less managed way, where you need to configure your DNS to point to the output `container_apps_fqdns` yourself manually

This example will follow the first method.

## 2. Installation and Prerequisites

### 2.1 - Terraform installation

You will need to install the Terraform CLI to use Terraform. Follow the steps below to install it, if you still need to.

- ✅ `2.1.a` Visit the Terraform installation page to install the Terraform CLI

https://developer.hashicorp.com/terraform/install

- ✅ `2.1.b` After the installation completes, verify that Terraform is installed correctly by checking its version:

```sh
terraform -v
```

### 2.2 - Astra token w/ sufficient perms

Additionally, you'll need a Datastax AstraDB token to enable creation and management of any vector databases.

The token must have the sufficient perms to manage DBs, as shown in the steps below.

- ✅ `2.2.a` Connect to [https://astra.datastax.com](https://astra.datastax.com)

![https://raw.githubusercontent.com/datastax/terraform-astra-ai-stack/main/assets/astra/login.png](https://raw.githubusercontent.com/datastax/terraform-astra-ai-stack/main/assets/astra/login.png)

- ✅ `2.2.b` Navigate to token and generate a token with `Organization Administrator` permissions and copy the token starting by `AstraCS:...`

![https://raw.githubusercontent.com/datastax/terraform-astra-ai-stack/main/assets/astra/token.png](https://raw.githubusercontent.com/datastax/terraform-astra-ai-stack/main/assets/astra/token.png)

Keep the token secure, as you won't be able to access it again!

### 2.3 - Log into the Azure CLI

There are many ways to provide authentication for the azure provider—this guide will authenticate using the `az` CLI tool, but you can
find more methods in the offial [azurerm provider documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs#authenticating-to-azure).

Below is a short guide on logging in via the CLI tool, if you still need to.

- ✅ `2.3.a` - Visit Microsoft's Azure installation guide and follow the steps there for your platform

https://learn.microsoft.com/en-us/cli/azure/install-azure-cli

- ✅ `2.3.b` - After the installation completes, verify that `az` is installed correctly by checking its version:

```sh
az -v
```

- ✅ `2.3.c` - Sign into your Azure account using the following command:

```sh
az login
```

- ✅ `2.3.d` - Verify that you're logged in by displaying your account profile:

```sh
az account show
```

## 2.4 - Setting up an Azure DNS managed zone

There are a few different ways to set up an Azure DNS managed zone. You can find more information about all of them in
the official [Azure DNS documentation](https://learn.microsoft.com/en-us/azure/dns/dns-operations-dnszones-portal).

The quick guide below will show you how to do it through the portal. The most important thing is that the managed zone is
created in the same subscription as the one you plan to deploy the Container Apps to.

- ✅ `2.4.a` - Access the [Azure portal](https://portal.azure.com/#home) and click on "Create a resource" in the top left.

![https://raw.githubusercontent.com/datastax/terraform-astra-ai-stack/main/assets/azure/create-resource-btn.png](https://raw.githubusercontent.com/datastax/terraform-astra-ai-stack/main/assets/azure/create-resource-btn.png)

- ✅ `2.4.b` - Search for "DNS zone", select it, and click "create". Make sure you aren't using "Private DNS zone".

![https://raw.githubusercontent.com/datastax/terraform-astra-ai-stack/main/assets/azure/dns-zone-card.png](https://raw.githubusercontent.com/datastax/terraform-astra-ai-stack/main/assets/azure/dns-zone-card.png)

- ✅ `2.4.c` - Select the subscription to create it in, and the resource group as well (create one if you need to).

![https://raw.githubusercontent.com/datastax/terraform-astra-ai-stack/main/assets/azure/dns-zone-project-details.png](https://raw.githubusercontent.com/datastax/terraform-astra-ai-stack/main/assets/azure/dns-zone-project-details.png)

- ✅ `2.4.d` - The "name" should be the apex domain you plan to use (e.g. `azure.enterprise-ai-stack.com`).

![https://raw.githubusercontent.com/datastax/terraform-astra-ai-stack/main/assets/azure/dns-zone-name.png](https://raw.githubusercontent.com/datastax/terraform-astra-ai-stack/main/assets/azure/dns-zone-name.png)

- ✅ `2.4.e` - When you're done with any additional options, you can click on the "Create" button in the bottom left.

![https://raw.githubusercontent.com/datastax/terraform-astra-ai-stack/main/assets/azure/dns-zone-create.png](https://raw.githubusercontent.com/datastax/terraform-astra-ai-stack/main/assets/azure/dns-zone-create.png)

- ✅ `2.4.f` - Once it's deployed, continue to the resource page

![https://raw.githubusercontent.com/datastax/terraform-astra-ai-stack/main/assets/azure/dns-zone-go-to-resource.png](https://raw.githubusercontent.com/datastax/terraform-astra-ai-stack/main/assets/azure/dns-zone-go-to-resource.png)

- ✅ `2.4.g` - In the "Recordsets" section of the dashboard, you'll find the nameserver records, which you'll need to add to your domain provider's DNS settings. There's no need to worry about the SOA records.

![https://raw.githubusercontent.com/datastax/terraform-astra-ai-stack/main/assets/azure/dns-zone-record-sets.png](https://raw.githubusercontent.com/datastax/terraform-astra-ai-stack/main/assets/azure/dns-zone-record-sets.png)

## 3. Setup

### 3.1 - Cloning the sample project

- ✅ `3.1.a` - Clone the same project through the following git command:

```sh
git clone https://github.com/datastax/terraform-azure-astra-ai-stack.git
```

- ✅ `3.1.b` - Then, find your way to the correct diectory:

```sh
cd terraform-azure-astra-ai-stack/examples/azure-no-custom-domain
```

### 3.2 - Initialize Terraform

- ✅ `3.2.a` - In this specific example directory, simply run `terraform init`, and wait as it downloads all of the necessary dependencies.

```sh
terraform init
```

## 4. Deployment

### 4.1 - Actually deploying

- ✅ `4.1.a` - Run the following command to list out the components to be created.  The `dns_name` will be the apex domain you created a managed zone for earlier (e.g. `azure.enterprise-ai-stack.com`)

```sh
terraform plan -var="astra_token=<your_astra_token>" -var="dns_name=<dns_name>"
```

- ✅ `4.1.b` - Once you're ready to commit to the deployment, run the following command, and type `yes` after double-checking that it all looks okay

```sh
terraform apply -var="astra_token=<your_astra_token>" -var="dns_name=<dns_name>"
```

- ✅ `4.1.c` - Simply wait for it to finish deploying everything—it may take a hot minute!

### 4.2 - Accessing your deployments

- ✅ `4.2.a` - Run the following command to access the variables output from deploying the infrastructure

```sh
terraform output datastax-ai-stack-azure
```

- ✅ `4.2.b` - Access Langflow

In your browser, go to `langflow.<your_domain>` (e.g. `langflow.azure.enterprise-ai-stack.com`) to access Langflow.

Note that it may take a minute to start up for the first time.

- ✅ `4.2.c` - Access Astra Assistants API

You can access the Astra Assistants API @ `assistants.<your_domain>` through your HTTP client of choice. e.g:

```sh
curl assistants.azure.enterprise-ai-stack.com/metrics
```

- ✅ `4.2.d` - Access your Astra Vector DB

You can connect to your Astra DB instance through your method of choice, using `astra_vector_dbs.<db_id>.endpoint`.

The [Data API clients](https://docs.datastax.com/en/astra-db-serverless/api-reference/overview.html) are heavily recommended for this.

## 5. Cleanup

### 5.1 - Destruction

- ✅ `5.1.a` - When you're done, you can easily tear everything down with the following command:

```sh
terraform destroy -var="astra_token=<your_astra_token>" -var="dns_name=<dns_name>"
```
