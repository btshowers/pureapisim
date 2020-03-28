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
        $body = '{"items":[{"connector_type":"QSFP","id":"b3a04094-fbad-ee7e-6585-8a54a44c8b33","lane_speed":10000000000,"name":"array1","port_count":1,"supported_speed":null,"transceiver_type":"AUTO"},{"connector_type":"QSFP","id":"80ba5278-9ed1-d309-c455-1e94df2dfbfb","lane_speed":10000000000,"name":"array2","port_count":1,"supported_speed":null,"transceiver_type":"AUTO"},{"connector_type":"QSFP","id":"a5e65240-ae98-e7c6-f236-e96f5e4556c5","lane_speed":10000000000,"name":"array3","port_count":1,"supported_speed":null,"transceiver_type":"AUTO"},{"connector_type":"QSFP","id":"713844f1-5e9c-616f-6c53-31f0f15d1f2b","lane_speed":10000000000,"name":"array4","port_count":1,"supported_speed":null,"transceiver_type":"AUTO"},{"connector_type":"RJ-45","id":"787108d5-85ea-1169-a6a7-788d5bc7598b","lane_speed":1000000000,"name":"array5","port_count":1,"supported_speed":null,"transceiver_type":"AUTO"}],"pagination_info":{"continuation_token":null,"total_item_count":5}}'
    }
    if($Request.Method -eq "PATCH"){
        $status = [HttpStatusCode]::OK
        #extract response to variables.
        if($Request.Query.names -or $Request.Query.ids){
            if($Request.Body.connector_type){$connector_type = $Request.Body.connector_type}else{$connector_type = "QSFP"}
            if($Request.Body.id){$id = $Request.Body.id}elseif($Request.Query.ids){$id = $Request.Query.ids}else{$id = "787108d5-85ea-1169-a6a7-788d5bc7598b"}
            if($Request.Body.name){$name = $Request.Body.name}elseif($Request.Query.names){$name = $Request.Query.names}else{$name = "FM1.ETH1"}
            if($Request.Body.port_count){$port_count = $Request.Body.port_count}else{$port_count = "4"}
            if($Request.Body.lane_speed){$lane_speed = $Request.Body.lane_speed}else{$lane_speed = "2500000000"}
            if($Request.Body.supported_speed){$supported_speed = $Request.Body.supported_speed}else{$supported_speed = "null"}
            if($Request.Body.transceiver_type){$transceiver_type = $Request.Body.transceiver_type}else{$transceiver_type = "AUTO"}
    
            #build the json reponse to show that it worked.
            $body = '{"items":[{"connector_type":"'+$connector_type+'","id":"'+$id+'","lane_speed":'+$lane_speed+',"name":"'+$name+'","port_count":'+$port_count+',"supported_speed":'+$supported_speed+',"transceiver_type":"'+$transceiver_type+'"}]}'
            
        }
        else{
            $status = [HttpStatusCode]::BadRequest
            $body = '"Please pass either "names" or "ids" as a parameter in the URI query string.  Note: This api only supports one query parameter at a time..."'
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

