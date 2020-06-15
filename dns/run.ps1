using namespace System.Net

# Input bindings are passed in via param block.
param($Request, $TriggerMetadata)

# Write to the Azure Functions log stream.
Write-Host "PowerShell HTTP trigger function processed a request."
#key:  2PDoD5iaokKDwGh9uNqt1jpDTNpgshfiOzO643z5ch92Mwycl7veBA==
# Write to the Azure Functions log stream.
Write-Host "PowerShell HTTP trigger function processed a request."
if($Request.Headers."x-auth-token" -eq "52a8163a-803b-475b-9c53-f99f6e7f4c22"){

    # Interact with query parameters or the body of the request.
    if($Request.Method -eq "GET"){
        $status = [HttpStatusCode]::OK
        $body = '{"domain":"dns_example.org","name":"PURE","nameservers":["10.64.12.6"],"search":["restapi_example.org","pure_example.org"]}'
    }
    if($Request.Method -eq "PATCH"){
        $status = [HttpStatusCode]::OK
        #extract response to variables.
        $domain = $Request.Body.domain
        #get search entries in array
        if($Request.Body.search){
            $count = 0
            foreach($s in $Request.Body.search){$count += 1}
            for($i = 0; $i -lt $count; $i++){
                $search += '"'+$Request.Body.search[$i]+'"'
                if($i -lt ($count -1)){$search += ','}
            }
        }
        else{$search = '"restapi_example.org","pure_example.org"'}
        #get dns servers in an array restapi_example.org","pure_example.org
        $count = 0
        foreach($nameserver in $Request.Body.nameservers){$count += 1}
        for($i = 0; $i -lt $count; $i++){
            $nameservers += '"'+$Request.Body.nameservers[$i]+'"'
            if($i -lt ($count -1)){$nameservers += ','}
        }   
        #build the json reponse to show that it worked.
        $body = '{"items":[{"domain":"'+$domain+'","nameservers":['+$nameservers+'],"search":['+$search+'],"pagination_info":{"continuation_token":null,"total_item_count":1}}]}'
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

