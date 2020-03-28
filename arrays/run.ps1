using namespace System.Net

# Input bindings are passed in via param block.
param($Request, $TriggerMetadata)

# Write to the Azure Functions log stream.
Write-Host "PowerShell HTTP trigger function processed a request."
Write-Host $Request.Body.ntp_servers
#key:  2PDoD5iaokKDwGh9uNqt1jpDTNpgshfiOzO643z5ch92Mwycl7veBA==

if($Request.Headers."x-auth-token" -eq "52a8163a-803b-475b-9c53-f99f6e7f4c22"){

    # Interact with query parameters or the body of the request.
    if($Request.Method -eq "GET"){
        $status = [HttpStatusCode]::OK
        $body = '{"items":[{"_as_of":"1551226695696","id":"00000000-0000-4000-8000-000000000000","name":"array_01","ntp_servers":["time.ntp.org"],"os":"Purity//FB","revision":"2019.01.31_280cf546","time_zone":"America/Los_Angeles","version":"2.3.4"}],"pagination_info":{"continuation_token":null,"total_item_count":1}}'
    }
    if($Request.Method -eq "PATCH"){
        $status = [HttpStatusCode]::OK
        #extract response to variables.
        $name = $Request.Body.name
        $timezone = "America/Los_Angeles"
        #get ntp_servers in an array
        $count = 0
        foreach($ntpserver in $Request.Body.ntp_servers){$count += 1}
        for($i = 0; $i -lt $count; $i++){
            $ntp_servers += '"'+$Request.Body.ntp_servers[$i]+'"'
            if($i -lt ($count -1)){$ntp_servers += ','}
        }   
        #build the json reponse to show that it worked.
        $body = '{"name":"'+$name+'","ntp_servers":['+$ntp_servers+',],"Time_zone":"'+$timezone+'",}'
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
