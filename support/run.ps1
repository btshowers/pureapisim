using namespace System.Net

# Input bindings are passed in via param block.
param($Request, $TriggerMetadata)

# Write to the Azure Functions log stream.
Write-Host "PowerShell HTTP trigger function processed a request."
write-host "test  " $Request.Body.phonehome_enabled
write-host "test  " $Request.Body.proxy

if($Request.Headers."x-auth-token" -eq "52a8163a-803b-475b-9c53-f99f6e7f4c22"){

    # Interact with query parameters or the body of the request.
    if($Request.Method -eq "GET"){
        $status = [HttpStatusCode]::OK
        $body = '{"items":[{"name":"FB007","phonehome_enabled":false,"proxy":null,"remote_assist_active":false,"remote_assist_expires":null,"remote_assist_opened":null,"remote_assist_paths":[{"component_name":"FM1","status":"disconnected"},{"component_name":"FM2","status":"disconnected"}],"remote_assist_status":"disconnected"}],"pagination_info":{"continuation_token":null,"total_item_count":1}}'
    }
    if($Request.Method -eq "PATCH"){
        $status = [HttpStatusCode]::OK
        if($Request.Body.phonehome_enabled){$phonehome_enabled = $Request.Body.phonehome_enabled}else{$phonehome_enabled = "false"}
        if($Request.Body.proxy){$proxy = $Request.Body.proxy}else{$proxy = ""}
        if($Request.Body.remote_assist_active){$remote_assist_active = $Request.Body.remote_assist_active}else{$remote_assist_active = "false"}
        #build the json reponse to show that it worked.
        $body = '{"items":[{"name":"FB007","phonehome_enabled":'+$phonehome_enabled.ToString().ToLower()+',"proxy":"'+$proxy+'","remote_assist_active":'+$remote_assist_active.toString().toLower()+',"remote_assist_expires":null,"remote_assist_opened":1540875451640,"remote_assist_paths":[{"component_name":"FM1","status":"connected"},{"component_name":"FM2","status":"connected"}],"remote_assist_status":"connected"}],"pagination_info":{"continuation_token":null,"total_item_count":1}}'
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

