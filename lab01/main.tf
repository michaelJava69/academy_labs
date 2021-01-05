/*
resource "local_file"  "hello" {
  filename = "hello.txt"
 

}

*/

resource "local_file"  "hello" {
  filename = "hello.txt"
  content = "Changed now  World"
  
}

