using namespace System.Net

# Input bindings are passed in via param block.
param($Request, $TriggerMetadata)

# Write to the Azure Functions log stream.
Write-Host "PowerShell HTTP trigger function processed a request."

if($Request.Headers."x-auth-token" -eq "52a8163a-803b-475b-9c53-f99f6e7f4c22"){

    # Interact with query parameters or the body of the request.
    if($Request.Method -eq "GET"){
        $status = [HttpStatusCode]::OK
        $body = '{"items":[{"address":"10.255.8.21","enabled":true,"gateway":"10.255.8.1","id":"6cd0559d-3b7b-4c2d-a8bb-5ad192811c89","mtu":1500,"name":"fm1.admin0","netmask":"255.255.255.0","services":["support"],"subnet":{"name":"net1","resource_type":"subnets"},"type":"vip","vlan":8},{"address":"2001:8::21","enabled":true,"gateway":"2001:8::1","id":"19153d72-f5b3-4b82-8408-3fe1ccabc99f","mtu":1500,"name":"fm1.admin0.1","netmask":"ffff:ffff:ffff:ffff::","services":["support"],"subnet":{"name":"net3","resource_type":"subnets"},"type":"vip","vlan":8},{"address":"10.255.8.22","enabled":true,"gateway":"10.255.8.1","id":"e9cac6f0-867d-4418-8bd3-e9f67ade7955","mtu":1500,"name":"fm2.admin0","netmask":"255.255.255.0","services":["support"],"subnet":{"name":"net1","resource_type":"subnets"},"type":"vip","vlan":8},{"address":"2001:8::22","enabled":true,"gateway":"2001:8::1","id":"07521c03-81c5-43fc-b845-e991c0992ac8","mtu":1500,"name":"fm2.admin0.1","netmask":"ffff:ffff:ffff:ffff::","services":["support"],"subnet":{"pagination_info":{"continuation_token":null,"total_item_count":6}}}]}'
    }
    if($Request.Method -eq "PATCH"){
        if($Request.Query.names){
            $name = $Request.Query.names
            $status = [HttpStatusCode]::OK
            #extract response to variables.
            $address = $Request.Body.address
            if($Request.Body.type){$type = $Request.Body.type}else{$type = "vip"}
            #get ntp_servers in an array
            #build the json reponse to show that it worked.
            $body = '{"items":[{"address":"'+$address+'","enabled":true,"gateway":"10.255.8.1","id":"d0eef7af-af94-7647-5f8e-af34895d1fed","mtu":1500,"name":"'+$name+'","netmask":"255.255.255.0","services":["Data"],"subnet":{"name":"net1","resource_type":"subnets"},"type":"'+$type+'","vlan":8}]}'
        }
        else{
            $status = [HttpStatusCode]::BadRequest
            $body = "you must provide a names as aURI query parameter."
        }
    }
}
else{
    $status = [HttpStatusCode]::Unauthorized
    $body = "Unauthorized.  Make sure to use the following key and value in your header:`nx-auth-token 52a8163a-803b-475b-9c53-f99f6e7f4c22"
}

# Associate values to output bindings by calling 'Push-OutputBinding'.
Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
    headers = @{'content-type'='application\json'}
    StatusCode = $status
    Body = $body
})
