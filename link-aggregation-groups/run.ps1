using namespace System.Net

# Input bindings are passed in via param block.
param($Request, $TriggerMetadata)

# Write to the Azure Functions log stream.
Write-Host "PowerShell HTTP trigger function processed a request."
#key:  2PDoD5iaokKDwGh9uNqt1jpDTNpgshfiOzO643z5ch92Mwycl7veBA==
# Write to the Azure Functions log stream.
Write-Host $Request.Body.add_ports.value
if($Request.Headers."x-auth-token" -eq "52a8163a-803b-475b-9c53-f99f6e7f4c22"){

    # Interact with query parameters or the body of the request.
    if($Request.Method -eq "GET"){
        $status = [HttpStatusCode]::OK
        $body = '{"items":[{"id":"4c89a8f3-16e4-b1ec-4bba-9edaf497908b","lag_speed":0,"mac":"52:02:05:e1:20:52","name":"uplink","port_speed":40000000000,"ports":[{"id":null,"name":"CH1.FM1.ETH1","resource_type":"hardware"},{"id":null,"name":"CH1.FM1.ETH2","resource_type":"hardware"},{"id":null,"name":"CH1.FM1.ETH3","resource_type":"hardware"},{"id":null,"name":"CH1.FM1.ETH4","resource_type":"hardware"},{"id":null,"name":"CH1.FM2.ETH1","resource_type":"hardware"},{"id":null,"name":"CH1.FM2.ETH2","resource_type":"hardware"},{"id":null,"name":"CH1.FM2.ETH3","resource_type":"hardware"},{"id":null,"name":"CH1.FM2.ETH4","resource_type":"hardware"}],"status":"healthy"}],"pagination_info":{"continuation_token":null,"total_item_count":1}}'
    }
    if($Request.Method -eq "DELETE"){
        if($Request.Query.names){
            $status = [HttpStatusCode]::OK
            $body = "{}  *You would have deleted the groups with names: "+$Request.Query.names
        }
        elseif($Request.Query.ids){
            $status = [HttpStatusCode]::OK
            $body = "{}  *You would have deleted the groups with names: "+$Request.Query.ids
        }
        else{
            $status = [HttpStatusCode]::BadRequest
            $body = '"Please pass either "names" or "ids" as a parameter in the URI query string.  Note: This api only supports one query parameter value at this time..."'
        }
    }
    if($Request.Method -eq "PATCH"){
        $status = [HttpStatusCode]::OK
        #extract response to variables. todo add back in query for ids
        if($Request.Query.names){
            if($Request.Body.name){$name = $Request.Body.name}elseif($Request.Query.names){$name = $Request.Query.names}else{$name = "FM1.ETH1"}
            if($Request.Body.id){$id = $Request.Body.id}else{$id = "787108d5-85ea-1169-a6a7-788d5bc7598b"}
            if($Request.Body.port_speed){$port_speed = $Request.Body.port_speed}else{$port_speed = "40000000000"}
            if($Request.Body.lag_speed){$lag_speed = $Request.Body.lag_speed}else{$lag_speed = "160000000000"}
            if($Request.Body.mac){$mac = $Request.mac}else{$mac = "42:33:0d:30:44:26"}
            $status1 = "healthy"
            if($Request.Body.remove_ports){
                $count = 0
                if($Request.Body.remove_ports.count -gt 1){
                    foreach($s in $Request.Body.remove_ports){$count += 1}
                    for($i = 0; $i -lt $count; $i++){
                        $ports += '{"name":"'+$Request.Body.remove_ports.name[$i]+'","resource_type":"hardware"}'
                        if($i -lt ($count -1)){$ports += ','}
                    }
                }
                else{$ports = '{"name":"'+$Request.Body.remove_ports.name+'"}'}
                #build the json reponse to show that it worked.
                $body = '{"items":[{"id":"'+$id+'","lag_speed":'+$lag_speed+',"mac":"'+$mac+'","name":"'+$name+'","port_speed":'+$port_speed+',"ports":['+$ports+'],"status":"'+$status1+'"}],"pagination_info":{"continuation_token":null,"total_item_count":1}}'
            }
            elseif($Request.Body.add_ports){
                $count = 0
                if($Request.Body.add_ports.count -gt 1){
                    #write-host "ports " $ports2
                    foreach($s in $Request.Body.add_ports){$count += 1}
                    for($i = 0; $i -lt $count; $i++){
                        $ports += '{"name":"'+$Request.Body.add_ports.name[$i]+$i+'"}'
                        if($i -lt ($count -1)){$ports += ','}
                    }
                }
                else{$ports = '{"name":"'+$Request.Body.add_ports.name+'"}'}
                write-host "ports " $ports
                #build the json reponse to show that it worked.
                $body = '{"items":[{"id":"'+$id+'","lag_speed":'+$lag_speed+',"mac":"'+$mac+'","name":"'+$name+'","port_speed":'+$port_speed+',"ports":['+$ports+'],"status":"'+$status1+'"}],"pagination_info":{"continuation_token":null,"total_item_count":1}}'
            }
            elseif($Request.Body.ports){
                $count = 0
                if($Request.Body.ports.count -gt 1){
                    foreach($s in $Request.Body.ports){$count += 1}
                    for($i = 0; $i -lt $count; $i++){
                        $ports += '{"name":"'+$Request.Body.ports.name[$i]+'","resource_type":"hardware"}'
                        if($i -lt ($count -1)){$ports += ','}
                    }
                }
                else{$ports = '{"name":"'+$Request.Body.ports.name+'"}'}
                #build the json reponse to show that it worked.
                $body = '{"items":[{"id":"'+$id+'","lag_speed":'+$lag_speed+',"mac":"'+$mac+'","name":"'+$name+'","port_speed":'+$port_speed+',"ports":['+$ports+'],"status":"'+$status1+'"}],"pagination_info":{"continuation_token":null,"total_item_count":1}}'
            }
            else{
                #$ports = '{"name":"CH3.FM1.ETH1","resource_type":"hardware"},{"name":"CH3.FM1.ETH2","resource_type":"hardware"},{"name":"CH3.FM1.ETH3","resource_type":"hardware"},{"name":"CH3.FM1.ETH4","resource_type":"hardware"'
                $status = [HttpStatusCode]::BadRequest
                $body = '"You must provide a add_ports or remove_ports entry in the body."'
            }
            }
            else{
                $status = [HttpStatusCode]::BadRequest
                $body = '"Please pass either "names" as a parameter in the URI query string.  Note: This api only supports one query parameter value at this time..."'
            }
        }
    if($Request.Method -eq "POST"){
    $status = [HttpStatusCode]::OK
    #extract response to variables. todo add back in query for ids
    if($Request.Query.names){
        if($Request.Body.name){$name = $Request.Body.name}elseif($Request.Query.names){$name = $Request.Query.names}else{$name = "FM1.ETH1"}
        if($Request.Body.id){$id = $Request.Body.id}else{$id = "787108d5-85ea-1169-a6a7-788d5bc7598b"}
        if($Request.Body.port_speed){$port_speed = $Request.Body.port_speed}else{$port_speed = "40000000000"}
        if($Request.Body.lag_speed){$lag_speed = $Request.Body.lag_speed}else{$lag_speed = "160000000000"}
        if($Request.Body.mac){$mac = $Request.Body.mac}else{$mac = "42:33:0d:30:44:26"}
        $status1 = "healthy"
        if($Request.Body.ports){
            $count = 0
            foreach($s in $Request.Body.ports){$count += 1}
            for($i = 0; $i -lt $count; $i++){
                $ports += '{"name":"'+$Request.Body.ports.name[$i]+'","resource_type":"hardware"}'
                if($i -lt ($count -1)){$ports += ','}
            }
            #build the json reponse to show that it worked.
            $body = '{"items":[{"id":"'+$id+'","lag_speed":'+$lag_speed+',"mac":"'+$mac+'","name":"'+$name+'","port_speed":'+$port_speed+',"ports":['+$ports+'],"status":"'+$status1+'"}],"pagination_info":{"continuation_token":null,"total_item_count":1}}'
        
        }
        else{
            #$ports = '{"name":"CH3.FM1.ETH1","resource_type":"hardware"},{"name":"CH3.FM1.ETH2","resource_type":"hardware"},{"name":"CH3.FM1.ETH3","resource_type":"hardware"},{"name":"CH3.FM1.ETH4","resource_type":"hardware"'
            $status = [HttpStatusCode]::BadRequest
            $body = '"You must provide a ports entry."'
        }
        
        }
        else{
            $status = [HttpStatusCode]::BadRequest
            $body = '"Please pass either "names" as a parameter in the URI query string.  Note: This api only supports one query parameter value at this time..."'
        }
    }
}
else{
    $status = [HttpStatusCode]::Unauthorized
    $body = "Unauthorized.  Make sure to use the following key and value in your header:`nx-auth-token 52a8163a-803b-475b-9c53-f99f6e7f4c22"
}

write-host $body
# Associate values to output bindings by calling 'Push-OutputBinding'.
Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
    headers = @{'content-type'='application\json'}
    StatusCode = $status
    Body = $body
    
})
