using namespace System.Net

# Input bindings are passed in via param block.
param($Request, $TriggerMetadata)

# Write to the Azure Functions log stream.
Write-Host "PowerShell HTTP trigger function processed a request."

if($Request.Headers."x-auth-token" -eq "52a8163a-803b-475b-9c53-f99f6e7f4c22"){

    if($Request.Body.setup_completed -eq $true){
        $status = [HttpStatusCode]::OK
        $body = '{"items":[{"array_name_configured":true,"dns_configured":true,"smtp_configured":true,"admin_network_configured":true,"setup_completed":true}]}'
    }
    else{
        $status = [HttpStatusCode]::BadRequest
        $body = "Not sure what you're trying to do.  setup_completed requires bool true to proceed."
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
