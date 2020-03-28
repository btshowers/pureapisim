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
        $body = '{"items":[{"enabled":true,"gateway":"10.255.9.1","id":"367b5319-d1b4-5c26-8953-1711b6fddce5","interfaces":[{"id":"99937846-889h-3hn4-d87b-1i66fwg55yh3","name":"vip1.ct0","resource_type":"network-interfaces"}],"link_aggregation_group":{"id":"48308843-105e-3fe3-c52b-0987c3ec4142","name":"uplink","resource_type":"link-aggregation-groups"},"mtu":1500,"name":"subnet_700","prefix":"10.255.9.0/24","services":[],"vlan":9},{"enabled":true,"gateway":"2001:8::1","id":"64f98cad-1328-9451-08ff-61e11f197652","interfaces":[{"id":"37dh6654-111k-jj34-q8q7-1118hjd778sd","name":"vip2.ct1","resource_type":"network-interfaces"}],"link_aggregation_group":{"id":"b91c692e-be09-5ec5-839f-c7cb425f199d","name":"uplink","resource_type":"link-aggregation-groups"},"mtu":1500,"name":"subnet_800","prefix":"2001:8::/64","services":["support"],"vlan":8}],"pagination_info":{"continuation_token":null,"total_item_count":2}}'
    }
    if($Request.Method -eq "DELETE"){
        if($Request.Query.names){
            $status = [HttpStatusCode]::OK
            $body = "{}  *You would have deleted the subnets with names: "+$Request.Query.names
        }
        elseif($Request.Query.ids){
            $status = [HttpStatusCode]::OK
            $body = "{}  *You would have deleted the subnets with ids: "+$Request.Query.ids
        }
        else{
            $status = [HttpStatusCode]::BadRequest
            $body = '"Please pass either "names" or "ids" as a parameter in the URI query string.  Note: This api only supports one query parameter value at this time..."'
        }
    }
    
    if(($Request.Method -eq "POST") -or ($Request.Method -eq "PATCH")){
        $status = [HttpStatusCode]::OK
        #extract response to variables. todo add back in query for ids
        if($Request.Query.names -or $Request.Query.ids){
            if($Request.Body.names){$name = $Request.Body.names}elseif($Request.Query.names){$name = $Request.Query.names}else{$name = "subnet_100"}
            if($Request.Body.ids){$id = $Request.Body.ids}else{$id = "787108d5-85ea-1169-a6a7-788d5bc7598b"}
            if($Request.Body.enabled){$enabled = $Request.Body.enabled}else{$enabled = $true}
            if($Request.Body.link_aggrigation_group.name){$link_aggrigation_group = $Request.Body.link_aggrigation_group.name}else{$link_aggrigation_group = "uplink"}
            if($Request.Body.mtu){$mtu = $Request.Body.mtu}else{$mtu = 1500}
            if($Request.Body.prefix){$prefix = $Request.Body.prefix}else{$prefix = "10.255.8.0/24"}
            if($Request.Body.vlan){$vlan = $Request.Body.vlan}else{$vlan = 8}
            if($Request.Body.gateway){$gateway = $Request.Body.gateway}else{$gateway = "10.255.8.1"}
            if($Request.Body.interfaces.name){$interface = $Request.Body.interfaces.name}else{$interfaces = "10.255.8.1"}
            if($Request.Body.services){
                $count = 0
                foreach($s in $Request.Body.services){$count += 1}
                for($i = 0; $i -lt $count; $i++){
                    $services += '"'+$Request.Body.services[$i]+'"'
                    if($i -lt ($count -1)){$services += ','}
                }
            }
            #build the json reponse to show that it worked.
            $body = '{"items":[{"enabled":'+$enabled.toString().toLower()+',"gateway":"'+$gateway+'","id":"'+$id+'","interfaces":[{"id":"88876hhg-123k-8765-8n8n-hunt1234kk87","name":"'+$interfaces+'","resource_type":"network-interfaces"}],"link_aggregation_group":{"id":"563hdy66-jjkd-87uh-33jn-hee84032pp12","name":"'+$link_aggrigation_group+'","resource_type":"link-aggregation-groups"},"mtu":'+$mtu+',"name":"'+$name+'","prefix":"'+$prefix+'","services":['+$services+'],"vlan":'+$vlan+'}],"pagination_info":{"continuation_token":null,"total_item_count":1}}'
            
                
            #else{
            #    #$ports = '{"name":"CH3.FM1.ETH1","resource_type":"hardware"},{"name":"CH3.FM1.ETH2","resource_type":"hardware"},{"name":"CH3.FM1.ETH3","resource_type":"hardware"},{"name":"CH3.FM1.ETH4","resource_type":"hardware"'
            #    $status = [HttpStatusCode]::BadRequest
            #    $body = '"You must provide a names or ids entry."'
            #}
            
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


# Associate values to output bindings by calling 'Push-OutputBinding'.
Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
    headers = @{'content-type'='application\json'}
    StatusCode = $status
    #Body = $body
    Body = $body
})
