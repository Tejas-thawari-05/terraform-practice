resource "aws_instance" "name" {
  ami = "ami-00ca32bbc84273381"
  instance_type = "t2.micro"
  tags = {
    Name = "ec2"
  }
}
#terraform import aws_instance.name i-09e0aefd9a03b2979

resource "aws_iam_user" "user" {
  name = "tejas123"
}
#terraform import aws_iam_user.user tejas123

resource "aws_iam_user_policy_attachment" "attach-policy" {
  user = aws_iam_user.user.name
  policy_arn = "arn:aws:iam::343218214917:policy/AllowS3UploadPolicy"
}
# terraform import aws_iam_user_policy_attachment.attach-policy tejas123/arn:aws:iam::343218214917:policy/AllowS3UploadPolicy