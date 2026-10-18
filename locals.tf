locals {
  project_tags = {
    contact      = "ananse@gmail.com"
    application  = "Ananse.App"
    project      = "CIE"
    environment  = "${terraform.workspace}"
   #creationTime = timestamp() 
  }
}

# locals {
#   name_prefix = "CIE-${terraform.workspace}"

#   project_tags = {
#     Contact     = "ananseinteriors@gmail.com"
#     Application = "A.I-WebApp"
#     Project     = "CIE"
#     Environment = terraform.workspace
#   }
# }