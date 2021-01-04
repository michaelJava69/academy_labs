output "file_id" {

     description = " the id of example file"
     value = local_file.example.id

}

output "file_content" {
     
     description = "The content of the example file"
     value =  local_file.example.content
     sensitive = true   ## the content of file will not be displayed

}
