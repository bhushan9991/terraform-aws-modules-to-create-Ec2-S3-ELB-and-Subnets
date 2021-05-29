resource "aws_s3_bucket" "s3bucket" {
  bucket = "test-bucket5678444"
  acl = "private"
  versioning {
    enabled = false
  }

force_destroy = true

     lifecycle {
          create_before_destroy = true
     }
 tags = {
   Name = "test_bucket"
   product_id = "test_product"
   env        = var.env
 }
}
