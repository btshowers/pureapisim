using namespace System.Net

# Input bindings are passed in via param block.
param($Request, $TriggerMetadata)

# Write to the Azure Functions log stream.
Write-Host "PowerShell HTTP trigger function processed a request."

# Interact with query parameters or the body of the request.


#if(Request.Body.alert_emails){$Request.Body.alert_emails[0]}

if($Request.Method -eq "PATCH"){
    $status = [HttpStatusCode]::OK
    $count = 0
    foreach($entry in $Request.Body.alert_emails){$count += 1}

    for($i = 0; $i -lt $count; $i++){
        $alert_emails += '"'+$Request.Body.alert_emails[$i]+'"'
        if($i -lt ($count -1)){$alert_emails += ','}
    }

    $count = 0
    foreach($dns in $Request.Body.dns.nameservers){$count += 1}

    for($i = 0; $i -lt $count; $i++){
        $dns_servers += '"'+$Request.Body.dns.nameservers[$i]+'"'
        if($i -lt ($count -1)){$dns_servers += ','}
    }

    $count = 0
    foreach($ntpserver in $Request.Body.ntp_servers){$count += 1}

    for($i = 0; $i -lt $count; $i++){
        $ntp_servers += '"'+$Request.Body.ntp_servers[$i]+'"'
        if($i -lt ($count -1)){$ntp_servers += ','}
    }    
    
    #foreach ($email in $Request.Body.alert_emails){
    #    $alert_emails += '"'+$email+'",'
    #}
      
    
    $body = '{"status": "initializing","array_id": "","ct0.eth0": {"netmask": "'+$Request.Body."ct0.eth0".netmask+'","address": "'+$Request.Body."ct0.eth0".address+'","gateway": "'+$Request.Body."ct0.eth0".gateway+'","mac_address": "24:a9:37:00:34:33"},"smtp": {"relay_host": "'+$Request.Body.smtp.relay_host+'","sender_domain": "'+$Request.Body.smtp.sender_domain+'"},"vir0": {"netmask": "'+$Request.Body.vir0.netmask+'","address": "'+$Request.Body.vir0.address+'","gateway": "'+$Request.Body.vir0.gateway+'","mac_address": "24:a9:37:00:34:36"},"alert_emails": ['+$alert_emails+'],"ct1.eth0": {"netmask": "'+$Request.Body."ct1.eth0".netmask+'","gateway": "'+$Request.Body."ct1.eth0".gateway+'","address": "'+$Request.Body."ct1.eth0".address+'"},"ntp_servers": ['+$ntp_servers+'],"version": "5.2.4","eula_acceptance": {"accepted_by": {"organization": "'+$Request.Body.eula_acceptance.accepted_by.organization+'","full_name":  "'+$Request.Body.eula_acceptance.accepted_by.full_name+'","job_title": "'+$Request.Body.eula_acceptance.accepted_by.job_title+'"},"accepted": '+$Request.Body.eula_acceptance.accepted.toString().toLower()+'},"progress": 0.01,"dns": {"nameservers": ['+$dns_servers+'],"domain": "'+$Request.Body.dns.domain+'"},"timezone": "'+$Request.Body.timezone+'","serial_number": "PCHFL17320104","os": "Purity//FA","array_name": "'+$Request.Body.array_name+'"}'
}


if($Request.Method -eq "GET"){
    $status = [HttpStatusCode]::OK
    $body = '{"status":"uninitialized","array_id":"","ct0.eth0":{"netmask":"255.255.255.0","address":"10.21.1.171","gateway":"10.21.1.1","mac_address":"24:a9:37:00:34:33"},"smtp":{"relay_host":"","sender_domain":""},"vir0":{"netmask":"","mac_address":"","gateway":"","address":""},"alert_emails":[],"ct1.eth0":{"netmask":"255.255.255.0","mac_address":"24:a9:37:00:34:39","gateway":"10.21.1.1","address":"10.21.1.212"},"ntp_servers":[],"version":"5.2.4","eula_acceptance":{"accepted_by":{"organization":"","full_name":"","job_title":""},"accepted":false},"progress":0,"dns":{"nameservers":[],"domain":""},"serial_number":"PCHFL17320104","timezone":"America/Los_Angeles","os":"Purity//FA","array_name":"tmefa10"}'
}


# Associate values to output bindings by calling 'Push-OutputBinding'.
Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
    headers = @{'content-type'='application\json'}
    StatusCode = $status
    Body = $body

})