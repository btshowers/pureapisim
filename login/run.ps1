using namespace System.Net

# Input bindings are passed in via param block.
param($Request, $TriggerMetadata)
#key:  2PDoD5iaokKDwGh9uNqt1jpDTNpgshfiOzO643z5ch92Mwycl7veBA==
# Write to the Azure Functions log stream.
Write-Host "PowerShell HTTP trigger function processed a request."
if($api = $Request.Headers."api-token" -eq "2PDoD5iaokKDwGh9uNqt1jpDTNpgshfiOzO643z5ch92Mwycl7veBA=="){

    # Interact with query parameters or the body of the request.
    if($Request.Method -eq "POST"){
        $status = [HttpStatusCode]::OK
        $body = 'username: "pureuser"'+"`n"+ 'Response headers: x-auth-token: "52a8163a-803b-475b-9c53-f99f6e7f4c22"'
    }
}
else{
    $status = [HttpStatusCode]::Unauthorized
    $body = "Unauthorized.  Make sure to use the following key and value in your header:`napi-token 2PDoD5iaokKDwGh9uNqt1jpDTNpgshfiOzO643z5ch92Mwycl7veBA=="
}
# Associate values to output bindings by calling 'Push-OutputBinding'.
Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
    headers = @{'content-type'='application\json'}
    StatusCode = $status
    Body = $body
})
