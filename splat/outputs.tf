

output "echo" {

   value  = data.external.echo.result
}

output "echo_foo" {
    value = data.external.echo.result.foo
}


## becuase laoded over by a count expression in resource declaration

output "splat_example_id"  {

   value = aws_instance.instance2[*].id
}

output "splat_example_public_ip"  {

   value = aws_instance.instance2[*].public_ip
}
