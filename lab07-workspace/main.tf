



resource "local_file"  "hello" {
  filename = "example-file-in-workspace-${terraform.workspace}.txt"
  content = "This file is in the ${terraform.workspace} workspace "
  
}
