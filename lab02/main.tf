resource "local_file"  "file01" {
  filename = "file01.txt"
  content = "the first changed file"

  lifecycle {
     prevent_destroy = true
  }

}
