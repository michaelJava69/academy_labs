output "file_content64" {
    description = "The base64 encoded content of the file "
    value = data.local_file.lab04.content_base64

}
