module "creating-S3-Bucket" {
  source = "github.com/terraform-aws-modules/terraform-aws-s3-bucket"     // to get automatic suggestion run command terraform init and then write below code 

  bucket = "my-s3-bucket"                                       
  acl    = "private"

  control_object_ownership = true
  object_ownership         = "ObjectWriter"

  versioning = {
    enabled = true
  }

}


        #  BELOW VARIABLE CODE IS PRESENT IN THE TERRAFORM OFFICIAL GIT REPOSITORY THIS IS DIRECTLY CALLED IN THE ABOVE MODULE CODE


# variable "bucket" {
#   description = "(Optional, Forces new resource) The name of the bucket. If omitted, Terraform will assign a random, unique name."
#   type        = string
#   default     = null
# }
# variable "acl" {
#   description = "(Optional) The canned ACL to apply. Conflicts with `grant`"
#   type        = string
#   default     = null
# }
# variable "control_object_ownership" {
#   description = "Whether to manage S3 Bucket Ownership Controls on this bucket."
#   type        = bool
#   default     = false
# }
# variable "object_ownership" {
#   description = "Object ownership. Valid values: BucketOwnerEnforced, BucketOwnerPreferred or ObjectWriter. 'BucketOwnerEnforced': ACLs are disabled, and the bucket owner automatically owns and has full control over every object in the bucket. 'BucketOwnerPreferred': Objects uploaded to the bucket change ownership to the bucket owner if the objects are uploaded with the bucket-owner-full-control canned ACL. 'ObjectWriter': The uploading account will own the object if the object is uploaded with the bucket-owner-full-control canned ACL."
#   type        = string
#   default     = "BucketOwnerEnforced"
# }
# variable "versioning" {
#   description = "Map containing versioning configuration."
#   type        = map(string)
#   default     = {}
# }

