using namespace System.Net

# Input bindings are passed in via param block.
param($Request, $TriggerMetadata)

# Write to the Azure Functions log stream.
Write-Host "PowerShell HTTP trigger function processed a request."
write-host $Request.Query.names
#key:  2PDoD5iaokKDwGh9uNqt1jpDTNpgshfiOzO643z5ch92Mwycl7veBA==
# Write to the Azure Functions log stream.
if($Request.Headers."x-auth-token" -eq "52a8163a-803b-475b-9c53-f99f6e7f4c22"){

    # Interact with query parameters or the body of the request.
    if($Request.Method -eq "GET"){
        $status = [HttpStatusCode]::OK
        $body = '{"items":[{"api_token":{"created":1510700307554,"expires":null,"token":"T-888888888-zzz8-88z8-8888-z8zzz888z888"},"id":"32480b53-776a-5523-2c5b-1cdd86e7e6de","name":"pureadmin1"},{"api_token":{"created":1510770288163,"expires":1542405334234,"token":"T-99999999-zzz9-99z9-9999-z9zzz999z999"},"id":"f1ee2576-0a5a-44a8-30e9-7e5fbe65b7da","name":"pureadmin2"}],"pagination_info":{"continuation_token":null,"total_item_count":2}}'
    }

    if($Request.Method -eq "PATCH"){
        $status = [HttpStatusCode]::OK
        #extract response to variables. todo add back in query for ids
        if($Request.Query.names){
            $name = $Request.Query.names
            #$create_api_token = $Request.Body.create_api_token
            #build the json reponse to show that it worked.
            $body = '{"items":[{"api_token":{"created":1510770288163,"expires":1542405334234,"token":"T-99999999-zzz9-99z9-9999-z9zzz999z999"},"id":"28d2f7cd-ea25-5a51-88bc-beb144d8b238","name":"'+$name+'"}]}'
        }
        else{
            #$ports = '{"name":"CH3.FM1.ETH1","resource_type":"hardware"},{"name":"CH3.FM1.ETH2","resource_type":"hardware"},{"name":"CH3.FM1.ETH3","resource_type":"hardware"},{"name":"CH3.FM1.ETH4","resource_type":"hardware"'
            $status = [HttpStatusCode]::BadRequest
            $body = '"You must provide a names URI parameter."'
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
    #Body = $body
    Body = $body
})
