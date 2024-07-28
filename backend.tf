terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
////Below added July 28 2024
    random = {
      source  = "hashicorp/random"
      version = "~> 3.1.0"
    }

    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.2.0"
    }
/////End
  }


  required_version=">=1.6.6" #this version is for Terraform Version, not aws
    cloud {
          organization = "mcitccrf2301"
        workspaces {
          name = "Hospital-queue"
      }
    }
  
}
