module "EC2-Creation-form-git-personal-repo" {
  source = "github.com/Tejas-thawari-05/terraform-practice/Day-7-module-source-temp"

  ami = "ami-08a6efd148b1f7504"
  instance_type = "t2.micro"
  instance-name = "my-ec2-instance"
}