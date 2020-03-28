using namespace System.Net

# Input bindings are passed in via param block.
param($Request, $TriggerMetadata)

# Write to the Azure Functions log stream.
Write-Host "PowerShell HTTP trigger function processed a request."

if($Request.Headers."x-auth-token" -eq "52a8163a-803b-475b-9c53-f99f6e7f4c22"){

    # Interact with query parameters or the body of the request.
    if($Request.Method -eq "GET"){
        $status = [HttpStatusCode]::OK
        $body = '{"items":[{"name":"array_99","relay_host":"relay.purestorage.com","sender_domain":"mydomain.com"}],"pagination_info":{"continuation_token":null,"total_item_count":1}}'
    }
    if($Request.Method -eq "PATCH"){
        $status = [HttpStatusCode]::OK
        $relay_host = $Request.Body.relay_host
        $sender_domain = $Request.Body.sender_domain
        #build the json reponse to show that it worked.
        $body = '{"items":[{"relay_host":"'+$relay_host+'","sender_domain":"'+$sender_domain+'"}]}'
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

