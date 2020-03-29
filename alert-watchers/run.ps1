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
        $body = '{"items":[{"enabled":true,"id":"cab236f4-49b3-10ef-72ff-de41287838cd","name":"administrator@fbqa.purestorage.com"},{"enabled":true,"id":"3eb75823-a13f-f94b-9e38-fee594acff6a","name":"pureuser@fbqa.purestorage.com"},{"enabled":true,"id":"1f2f575a-d555-0bc0-c293-df260cd0b8ab","name":"pandas@purestorage.com"},{"enabled":true,"id":"7aecb72d-22bd-bc71-06be-3ac5e0aeb490","name":"test@example.com"}],"pagination_info":{"continuation_token":null,"total_item_count":4}}'
    }

    if($Request.Method -eq "DELETE"){
        $status = [HttpStatusCode]::OK
        #extract response to variables. todo add back in query for ids
        if($Request.Query.names){
            $name = $Request.Query.names
            #build the json reponse to show that it worked.
            $body = '{}  You would have deleted the alert-watcher named: ' +$name
        }
        elseif($Request.Query.ids){
            $id = $Request.Query.ids
            #build the json reponse to show that it worked.
            $body = '{}  You would have deleted the alert-watcher with the ID: ' +$id
        }
        else{
            #$ports = '{"name":"CH3.FM1.ETH1","resource_type":"hardware"},{"name":"CH3.FM1.ETH2","resource_type":"hardware"},{"name":"CH3.FM1.ETH3","resource_type":"hardware"},{"name":"CH3.FM1.ETH4","resource_type":"hardware"'
            $status = [HttpStatusCode]::BadRequest
            $body = '"You must provide a either an ids or names URI parameter."'
        }
    }
    if($Request.Method -eq "PATCH"){
        $status = [HttpStatusCode]::OK
        #extract response to variables. todo add back in query for ids
        if($Request.Query.names){
            $name = $Request.Query.names
            $enabled = $Request.Body.enabled
            #build the json reponse to show that it worked.
            $body = '{"items":[{"enabled":'+$enabled.ToString().ToLower()+',"id":"73f29a11-1cd1-45d6-f86f-8a03246ca38e","name":"'+$name+'"}]}'
        }
        elseif($Request.Query.ids){
            $id = $Request.Query.ids
            $enabled = $Request.Body.enabled
            #build the json reponse to show that it worked.
            $body = '{"items":[{"enabled":'+$enabled.ToString().ToLower()+',"id":"'+$id+'","name":"puritan4@example.com "}]}'
        }
        else{
            #$ports = '{"name":"CH3.FM1.ETH1","resource_type":"hardware"},{"name":"CH3.FM1.ETH2","resource_type":"hardware"},{"name":"CH3.FM1.ETH3","resource_type":"hardware"},{"name":"CH3.FM1.ETH4","resource_type":"hardware"'
            $status = [HttpStatusCode]::BadRequest
            $body = '"You must provide a either an ids or names URI parameter."'
        }
    }
   
    if($Request.Method -eq "POST"){
    $status = [HttpStatusCode]::OK
    #extract response to variables. todo add back in query for ids
        if($Request.Query.names){
            if($Request.Body.name){$name = $Request.Body.name}elseif($Request.Query.names){$name = $Request.Query.names}else{$name = "FM1.ETH1"}
                #build the json reponse to show that it worked.
                $body = '{"items":[{"enabled": true,"id":"73f29a11-1cd1-45d6-f86f-8a03246ca38e","name":"'+$name+'"}]}'
        }
        else{
            #$ports = '{"name":"CH3.FM1.ETH1","resource_type":"hardware"},{"name":"CH3.FM1.ETH2","resource_type":"hardware"},{"name":"CH3.FM1.ETH3","resource_type":"hardware"},{"name":"CH3.FM1.ETH4","resource_type":"hardware"'
            $status = [HttpStatusCode]::BadRequest
            $body = '"You must provide a names uri parameter in the form of an email address."'
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
