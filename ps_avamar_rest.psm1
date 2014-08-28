##
#
# EMC - vElemental.com -  @clintonskitson
# 07/07/2014
# ps_avamar_rest.psm1 - module for implenting Avamar REST API
#
##


Function New-ObjectAvamar {
    [CmdletBinding()]
    param([parameter(Mandatory=$true)]
          [ValidateNotNull()]$type,[switch]$xml,[hashtable]$property,[hashtable]$XmlProperty,[switch]$NoOptional)
    Process {
        [xml]$DataProtectionResource = @"
<DataProtectionResource name="">
  <user>MCUser</user>
  <password>MCUser1</password>
  <protocol>https</protocol>
  <hostname>hostname</hostname>
  <path>/services/mcsdk10</path>
  <port>9443</port>
</DataProtectionResource>
"@

        [xml]$Folder = @"
<Folder name="">
  <description>none</description>
  <tenant/>
</Folder>
"@

        [xml]$ResourceShare = @"
<ResourceShare name="">
  <capacityInMB></capacityInMB>
  <dataProtectionResource/>
  <dataProtectionResource/>
  <tenant/>
  <resourcePool/>
  <folder/>
</ResourceShare>
"@

        [xml]$ResourcePool = @"
<ResourcePool name=""/>
"@

        [xml]$Tenant = @"
<Tenant name="">
  <description>tenant desc</description>
  <resourceShare/>
</Tenant>
"@

        [xml]$Client= @"
<Client name="">
  <description></description>
  <contact></contact>
  <phone></phone>
  <email></email>
  <location></location>
  <clientOS></clientOS>
</Client>
"@

        [xml]$Retention = @"
<Retention name="">
  <description></description>
  <retentionType>never</retentionType>
  <retentionDuration></retentionDuration>
  <expirationDate>2051-12-31T16:00:00.000-08:00</expirationDate>
  <mode>backup</mode>
</Retention>
"@

        [xml]$RetentionDuration = @"
<RetentionDuration>
<unit/>
<duration/>
</RetentionDuration>
"@

        [xml]$BackupRequest = @"
<BackupRequest>
  <dataSource><source></source></dataSource>
  <plugin/>
  <retention/>
  <pluginOption/>
  <dynamicOption/>
</BackupRequest>
"@

        [xml]$BackupSource = @"
<DataSource>
  <source>test</source>
  <source>test</source>
</DataSource>
"@

        [xml]$RestoreRequest = @"
<RestoreRequest>
  <destClient>
    <client href=""/>
  </destClient>
  <plugin/>
  <backupSource></backupSource>
  <backupSource></backupSource>
  <destinationPath>temp</destinationPath>
  <destinationPath>temp</destinationPath>
  <pluginOption/>
  <dynamicOption/>
  <fileLevelRestore/>
  <username/>
  <password/>
</RestoreRequest>
"@


        [xml]$destClient = @"
<destClient>
  <client href=""/>
</destClient>
"@

        [xml]$ReplicateRequest = @"
<replicateRequest>
  <dataset/>
  <retention/>
  <destination/>
</replicateRequest>
"@

        [xml]$Policy = @"
<Policy name="">
  <description>none</description>
  <dataset/>
  <schedule/>
  <retention/>
  <destination/>
  <enabled>true</enabled>
  <encryptionType>High</encryptionType>
  <overrideSchedule>NotOverridden</overrideSchedule>
</Policy>
"@

        [xml]$Dataset = @"
<Dataset name="">
  <description>none</description>
  <datasetItem name="datasetItem"/>
  <datasetItem name="datasetItem2"/>
  <mode>Backup</mode>
  <allDataLocalFileSystem>false</allDataLocalFileSystem>
</Dataset>
"@
        [xml]$DatasetItem = @"
<DatasetItem name="">
  <plugin href=""/>
  <datasetTarget name="datasetTarget1">
    <value></value>
  </datasetTarget>
  <datasetTarget name="datasetTarget2">
    <value></value>
  </datasetTarget>
  <datasetInclude name="datasetInclude1">
    <value></value>
  </datasetInclude>
  <datasetInclude name="datasetInclude2">
    <value></value>
  </datasetInclude>
  <datasetExclude name="datasetExclude1">
    <value></value>
  </datasetExclude>
  <datasetExclude name="datasetExclude2">
    <value></value>
  </datasetExclude>
  <datasetOption name="datasetOption1">
    <value></value>
  </datasetOption>
  <datasetOption name="datasetOption2">
    <value></value>
  </datasetOption>
</DatasetItem>
"@

    $DatasetItem_desc = @{
        "optional" = "DatasetInclude","DatasetTarget","DatasetExclude","DatasetOption"
    }

    [xml]$DatasetInclude = @"
  <datasetInclude name="">
    <value></value>
  </datasetInclude>
"@

        [xml]$DatasetVMware = @"
    <dataset name="">
        <description></description>
        <datasetItem name ="linux">
            <plugin href=""/>
            <datasetTarget name="target1">
                <value>/</value>
            </datasetTarget>
            <datasetTarget name="target2">
                <value>/</value>
            </datasetTarget>
        </datasetItem>
        <datasetItem name ="windows">
            <plugin href=""/>
            <datasetTarget name="target1">
                <value>/</value>
            </datasetTarget>
            <datasetTarget name="target2">
                <value>/</value>
            </datasetTarget>
        </datasetItem>
        <mode>backup</mode>
    </dataset>
"@


        [xml]$Schedule = @"
<Schedule name="">
  <description>none</description>
  <timezone>GMT</timezone>
  <recurrenceType>Daily</recurrenceType>
  <dailySchedule/>
  <weeklySchedule/>
  <monthlySchedule/>
  <expirationDate/>
  <commenceDate>1970-12-31T16:00:00.000-08:00</commenceDate>
</Schedule>
"@

        [xml]$DailySchedule = @"
<dailySchedule>
  <maxRunHour/>
  <timeOfDays/>
</dailySchedule>
"@

        [xml]$WeeklySchedule = @"
<weeklySchedule>
  <dayOfWeek/>
  <beforeTime/>
  <afterTime/>
</weeklySchedule>
"@

        [xml]$MonthlySchedule = @"
<monthlySchedule>
  <dayOfMonth/>
  <weekOfMonth/>
  <beforeTime/>
  <afterTime/>
</monthlySchedule>
"@

        [xml]$ReferenceList = @"
<ReferenceList>
  <reference href=""/>
  <reference href=""/>
</ReferenceList>
"@

        [xml]$Destination = @"
<destination name="">
  <description>nodesc</description>
  <host/>
  <user/>
  <password/>
  <port>27000</port>
  <encryptionType>High</encryptionType>
  <byteCap/>
</destination>
"@

        [xml]$Reference = @"
<Reference href=""/>
"@

        [xml]$ClientBrowseRequest = @"
<clientBrowseRequest>
<plugin href=""/>
<path></path>
</clientBrowseRequest>
"@

        [xml]$BackupBrowseRequest = @"
<backupBrowseRequest>
    <granularBrowse>true</granularBrowse>
    <path></path>
</backupBrowseRequest>
"@

        [xml]$HypervisorManager = @"
<hypervisorManager name="">
    <description></description>
    <hostname></hostname>
    <port>443</port>
    <username></username>
    <password></password>
    <hypervisorManagerType>vCenter</hypervisorManagerType>
</hypervisorManager>
"@

        [xml]$ClientVM = @"
<client name="">
    <clientExtensionType>VmClient</clientExtensionType>
    <vmClientExt>
        <dataCenter></dataCenter>
        <vmUUID></vmUUID>
        <changedBlockTracking>true</changedBlockTracking>
    </vmClientExt>
    <description></description>
    <contact></contact>
    <phone></phone>
    <email></email>
    <location></location>
</client>
"@

        [xml]$VmClientExt = @"
<vmClientExt>
    <vmUUID></vmUUID>
    <changedBlockTracking>true</changedBlockTracking>
</vmClientExt>
"@

        [xml]$ClientVmProxy = @"
<client name="">
    <description></description>
    <contact></contact>
    <phone></phone>
    <email></email>
    <location></location>
    <clientExtensionType>VmProxyClient</clientExtensionType>
    <dataProtectionResource/>
</client>
"@


[xml]$VmDatastoreList = @"
<vmDatastoreList>
  <vmDatastore url=""/>
  <vmDatastore url=""/>
</vmDatastoreList>
"@
        $typeOut = Invoke-Expression "`$$($type)" 
        if($XmlProperty) {
            $XmlProperty.keys | %{ 
                $propName = $_
                if($XmlProperty.$_ -is [array]) {
                    $splitPropName = $propName.split('.')[-1]
                    $unsplitPropName = $propName -replace ".$($splitPropName)",''
                    [array]$arrChildNodes = Invoke-Expression "`$typeOut.`"$($typeOut.DocumentElement.ToString())`".ChildNodes | where {`$_.Name -eq `$splitPropName}"
                    $cloneNode = $arrChildNodes[0].CloneNode($true)
                    $arrChildNodes | %{ Invoke-Expression "[void]`$typeOut.`"$($typeOut.DocumentElement.ToString())`".RemoveChild(`$_)" }
                    $XmlProperty.$propName | %{
                        $value = $_
                        [void]$cloneNode.set_InnerText("$($value)")
                        Invoke-Expression "[void]`$typeOut.`"$($typeOut.DocumentElement.ToString())`".AppendChild(`$cloneNode.CloneNode(`$true))"
                    }
                } else {
                    Invoke-Expression "`$typeOut.`"$($typeOut.DocumentElement.ToString())`".$($propName) = `"`$(`$XmlProperty.`$propName)`""
                    
                }
            }
        }

        if($xml) {
            $typeOut
        } else {
            $typeOutPs = $typeOut | ConvertTo-JsonFromXml | ConvertFrom-Json
            if($Property) {
                $Property.keys | %{ 
                    $propName = $_
                    if($typeOutPs.$propName -is [array]) {
                        [System.Collections.ArrayList]$typeOutPs.$_ = @($Property.$_)
                    }else {
                        $typeOutPs.$_ = $Property.$_
                    }
                }
            }
            $optional = Invoke-Expression "`$$($type)_desc.optional"
            if($optional -and !$NoOptional) {
                $newHash = @{}
                $typeOutPs.psobject.properties | %{ $newHash.($_.name) = $_.value }
                $typeOutPs = New-Object -type Psobject -property $newHash
                $optional | %{ if($Property.keys -notcontains $_) { [void]$typeOutPs.psobject.properties.Remove($_) } }
            }
            $typeOutPs
        }
    }
}

Function New-ObjectArray {
    [CmdletBinding()]
        param($Type,$Property)
        Process {
            $translated = ,@($Property) | ConvertTo-Json | ConvertFrom-Json | Select Value
            $translated | Add-Member -MemberType AliasProperty -name $Type -value value -passthru | Select -property $Type
        }
}


Function Invoke-GenericREST {
    [CmdletBinding()] 
        param([uri]$href = $(throw "missing -href"),
            $ContentType = $(throw "missing -ContentType"),
            $Accept= $(throw "missing -Accept"),
            $httpType="GET",$username,$password,
            $content,$timeout=60000,$GlobalVarName,
            [boolean]$ignoreSsl=$true,$normalResponse,$HeaderAuthName,$authId)
        Process {
                if(!([system.uri]$Href).Host) { Write-Verbose "Missing host in href, likely missing input to cmdlet.";return @{response=""} }
                Write-Verbose "$($HttpType): $($Href)"
                $webRequest = [System.Net.WebRequest]::Create($Href)
                $webRequest.ContentType = $ContentType
                Write-Verbose "ContentType: $($ContentType)"
                $webRequest.Accept = $Accept
                Write-Verbose "Accept: $($Accept)"
                $webRequest.Timeout = $timeout
                $webRequest.Method = $httpType
                $webRequest.KeepAlive = $False
                $webRequest.UserAgent = "Invoke-GenericREST (.NET)"
                if($username -and $password) {
                    $userpass = "$($username):$($password)".ToCharArray()
                    $webRequest.Headers.Add('Authorization',("Basic $([System.Convert]::ToBase64String($userpass))"))
                }elseif($authId) {
                    Write-Verbose "$($HeaderAuthName): $($AuthId)"
                    $webRequest.Headers.Add($HeaderAuthName,$AuthId)
                }else {
                    Throw "Missing Username and Password OR previous `$global:$($GlobalVarName).authId"
                } 
                
                if($ignoreSsl) { 
                    [System.Net.ServicePointManager]::ServerCertificateValidationCallback = {$true}
                }


                if($content) {
                    Write-Verbose ("Content: $($content)")
                    $contentBytes = [System.Text.Encoding]::UTF8.GetBytes($content)
                    try {
                        $requestStream = $webRequest.GetRequestStream()
                        $requestStream.Write($contentBytes, 0,$contentBytes.length)
                        $requestStream.Flush()
                        $requestStream.Close()
                    } catch {}
                }
                                       
                $errorRawResponse = try { $rawResponse = $webRequest.GetResponse() } catch { 
                    $rawResponse = $_.Exception.InnerException.Response
                    $rawResponse
                    $webRequest.Abort()
                }

                if($ignoreSsl) { 
                    [System.Net.ServicePointManager]::ServerCertificateValidationCallback = {$false}
                }

                if([int]$rawResponse.statusCode -ne 204) {
                    $streamReader = New-Object System.IO.StreamReader($rawResponse.GetResponseStream())
                    $response = $streamReader.ReadToEnd()
                    $streamReader.Close()
                    Write-Debug ("response: $($response)")
                }else { $response = $null }

                $webRequest.Abort()

                $auth = $rawResponse.headers.get_Item($HeaderAuthName)
                if($auth) {
                    Write-Verbose "Got $($HeaderAuthName): $($auth)"
                    try {
                        New-Variable -name $GlobalVarName -scope global -value @{authId=$auth} -ea stop | Out-Null
                    } catch {
                        $tmpVar = Get-Variable -name $GlobalVarName -scope global
                        $tmpVar.value.authId = $auth
                    }
                }

                write-verbose "Got a $([int]$rawResponse.statusCode) response code"
                Write-Verbose ($rawResponse | fl * | Out-String)

                if($errorRawResponse) {
                    if($rawResponse.ContentType -match "xml") {
                        [xml]$response = $response
                        Write-Host -fore red ($response | select * -expandproperty error | select message | Out-String)
                        Write-Debug ($response | select * -expandproperty error | fl * | Out-String)
                    }elseif($rawResponse.ContentType -match "json") {
                        $response = $response | ConvertFrom-Json
                        Write-Host -fore red ($response | select errorCode,Message | fl * | out-string)
                        Write-Debug ($response | fl * | Out-String)
                    }else {
                        Write-Host -fore red $response
                    }
                } else {
                    Write-Verbose ($response | fl * | Out-String)
                }


                if (($response -and $rawResponse -and $normalResponse -contains [int]$rawResponse.statusCode) -or 
                    ($rawResponse -and $normalResponse -contains [int]$rawResponse.statusCode -and [int]$rawResponse.statusCode -eq 204)) {
                    return @{rawResponse=$rawResponse;response=$response}
                }else {
                    Throw ("Got $($rawResponse.statusCode) and $([int]$rawResponse.statusCode) HTTP status code")
                }                        
                
        }
}

#Invoke-AvamarBaseREST -href "https://brm-01.brsvlab.local:8543/rest-api/login" -httpType "POST" -username "admin" -password "changeme"
Function Invoke-AvamarBaseREST {
    [CmdletBinding()] 
        param([uri]$href,$apiCall,
            $ContentType = "application/json;version=1.0",
            $Accept="application/json;version=1.0",
            $httpType="GET",$username,$password,
            [array]$normalResponse=200,$content,$timeout=60000)
        Process {
                if($apiCall -and !$Href) { $href = $global:DefaultAvamarServer.server + $apiCall }
                if(!$href) { throw "Missing `$href OR `$apiCall" }
                Write-Verbose "apiCall: $($apiCall)"
                $GlobalVarName = "DefaultAvamarServer"
                $HeaderAuthName = "X-Concerto-Authorization"
                $AuthId = (Invoke-Expression "`$global:$($globalVarName)").authId
                $result = Invoke-GenericREST -href $href -ContentType $ContentType -Accept $Accept -HttpType $HttpType -Username $Username -Password $Password `
                    -content $content -timeout $timeout -GlobalVarName $GlobalVarName -normalResponse $normalResponse -HeaderAuthName $HeaderAuthName -AuthId $AuthId
                $result.response = $result.response | where{$_} | ConvertFrom-Json
                return $result
                
        }
}

Function Invoke-AvamarREST {
    [CmdletBinding()]
    param([Parameter(Mandatory=$False, Position=0, ValueFromPipeline=$true)]
        [psobject]$InputObject,[string]$name,[string]$id,[ScriptBlock]$FilterScript={$_},$httpType="GET",
        [Boolean]$XmlObject=$False,[Boolean]$References=$False,[boolean]$NoRecurse=$False,$NormalResponse=200,
        $DynamicApiCall,$ApiCall,$ReturnVarInPlace,$ReturnVar=".response",[string]$ReturnVarTask,$RunAsync,
        [string]$Content,[string]$ContentType="application/json;version=1.0",$postTaskLookupCmd)
    Process {
        if(!$ApiCall -and !$DynamicApiCall) {
            $result = $InputObject
            [array]$arrOutput = Invoke-Expression "`$result$($ReturnVarInPlace)"
            [array]$arrOutput2 = $arrOutput | %{
                if(!$References) { 
                     Invoke-AvamarBaseREST -href $_.Href -httpType $httpType -normalResponse $normalResponse -Content $Content -ContentType $ContentType | %{Invoke-Expression "`$_$($ReturnVar)"}
                } else {
                    $_
                }
            }
        } else {
            $Href = if($DynamicApiCall) {
                $InputObject.Href+"$($DynamicApiCall)"
            } elseif($ApiCall) {
                "$($ApiCall)"
            } else {$InputObject.Href} 

            $result = Invoke-AvamarBaseREST -href $Href -httpType $httpType -normalResponse $normalResponse -Content $Content -ContentType $ContentType 
            
            if($name) { $FilterScript = {$_.name -eq $name} }
            if($id) { $FilterScript = {$_.id -eq $id} }

            [array]$arrOutput = Invoke-Expression "`$result$($ReturnVar)" | where-object -filterscript $FilterScript 
            if($noRecurse) { return ($arrOutput) }
            
            

            [array]$arrOutput2 = $arrOutput | %{ 
                if(!$XmlObject) {
                    $_ | select name,id,href,@{n="object";e={
                        if(!$References) { 
                            Invoke-AvamarBaseREST -href $_.Href | %{Invoke-Expression "`$_.response"}  
                        } 
                    } }
                } else {$_}
            }
        }
         
        if($RunAsync -is [boolean] -and !$RunAsync) {
            $Task = (Invoke-Expression "`$arrOutput2$($ReturnVarTask)")
            $Task = $Task | Wait-AvamarTask
            if($postTaskLookupCmd) { Invoke-Expression "$($postTaskLookupCmd) $($Task.Result.Id)" }
        } else {

            $arroutput2 | export-clixml arroutput2.clixml
            $return = $arrOutput2 | %{ if($_.object) { $_.object } else { $_ } } | where-object -filterscript $FilterScript
            return $return
        }
    }

}





#Connect-Avamar -username admin -password changeme -loginUrl "https://brm-01.brsvlab.local:8543/api/login" 
Function Connect-Avamar {
    [CmdletBinding()]
    param($username,$password,$credential,[system.uri]$loginUrl,$server,$transport="https",$port="8543")
    Process {
        if(!$loginurl) { $loginUrl = "$($transport)://$($server):$($port)/rest-api/login" }
        try { 
            if(!$password -and !$credential) {
                $credential = Get-Credential
                $username = $credential.UserName
                $password = $credential.GetNetworkCredential().get_Password()
            }
            $result = Invoke-AvamarBaseREST -href $loginUrl -httpType "POST" -username $username -password $password -normalResponse 201
            $response = $result.response
            $tmpVar = Get-Variable -name DefaultAvamarServer -scope global
            $strServer = $loginUrl.OriginalString.replace($loginUrl.pathandquery,'')
            $strEndpoint = "$($strServer)/rest-api"
            $tmpVar.value = @{
                providerId=$response.accessPoint.Id
                authId=$tmpVar.Value.authId
                accessPoint=$response.accessPoint
                server=$loginUrl.OriginalString.replace($loginUrl.pathandquery,'')
                baseAccessPoint=@{"href"=$strEndpoint}
                adminAccessPoint=@{"href"="$($strEndpoint)/admin"}
            }                      
            Write-Host -fore green "Connected to $($loginUrl)"
        } catch {
            Write-Host -fore red "Problem connecting to $($loginUrl)"
            Throw $_
        }
    }
}

#Get-AvamarResourcePool
#Get-AvamarResourcePool | Get-AvamarResourcePoolDetail
#Get-AvamarResourcePool | Get-AvamarResourcePoolDetail | Get-DataProtectionResource
#Get-AvamarResourcePool | Get-AvamarResourcePoolDetail | Get-DataProtectionResource | Get-DataProtectionResourceDetail
#Get-AvamarResourcePool | Get-AvamarResourcePoolDetail | Get-ResourceShare
#Get-AvamarResourcePool | Get-AvamarResourcePoolDetail | Get-ResourceShare | Get-ResourceShareDetail
#Get-Tenant
#Get-Tenant | Get-TenantDetail
#Get-Tenant | Get-TenantDetail | Get-ResourceShare
#Get-Tenant | Get-TenantDetail  | Get-folder
#Get-Tenant | Get-TenantDetail  | Get-folder | get-folderdetail
#Get-Tenant | Get-TenantDetail  | Get-Avamarfolder | get-Avamarfolderdetail | get-client
#Get-Tenant | Get-TenantDetail  | Get-folder | get-folderdetail | get-client | get-clientdetail
#Get-Tenant | Get-TenantDetail  | Get-folder | get-folderdetail | Get-Schedule
#Get-Tenant | Get-TenantDetail  | Get-folder | get-folderdetail | Get-Schedule | Get-ScheduleDetail
#Get-Tenant | Get-TenantDetail  | Get-folder | get-folderdetail | Get-Retention
#Get-Tenant | Get-TenantDetail  | Get-folder | get-folderdetail | Get-Retention | Get-RetentionDetail
#Get-Tenant | Get-TenantDetail  | Get-folder | get-folderdetail | Get-Dataset
#Get-Tenant | Get-TenantDetail  | Get-folder | get-folderdetail | Get-Dataset | Get-DatasetDetail
#Get-ClientPlugin
#Get-ClientPlugin | Get-ClientPluginDetail
#Get-Tenant | Get-TenantDetail  | Get-Folder | Get-Policy
#Get-Tenant | Get-TenantDetail  | Get-Folder | Get-Policy | Get-PolicyDetail
#$folder.policy[1] | Get-AvamarTask | Get-AvamarTaskDetail
#$folder.policy[1] | Get-AvamarJob | Get-AvamarJobDetail
#Get-ClientPlugin | where {$_.name -eq "Windows File System"} | Get-ClientPluginDetail | Get-ClientPluginInstance
@{name="AvamarResourcePool";apiCall="`$(`$DefaultAvamarServer.accessPoint.href)/detail/resourcePool";returnVar=".response.resourcePool";apiIdCall="`$(`$DefaultAvamarServer.baseAccessPoint.href)/resourcePool/";noRecurse=$true},
@{name="DataProtectionResource";dynamicApiCall="/dataProtectionResource";returnVar=".response.dataProtectionResource";apiIdCall="`$(`$DefaultAvamarServer.adminAccessPoint.href)/dataProtectionResource/"},
@{name="ResourceShare";dynamicApiCall="/detail/resourceShare";returnVar=".response.resourceShare";apiIdCall="`$(`$DefaultAvamarServer.baseAccessPoint.href)/resourceShare/";XmlObject=$true},
@{name="Tenant";apiCall="`$(`$DefaultAvamarServer.accessPoint.href)/detail/tenant";returnVar=".response.tenant";apiIdCall="`$(`$DefaultAvamarServer.baseAccessPoint.href)/tenant/";noRecurse=$true},
@{name="AvamarFolder";dynamicApiCall="/detail/folder";returnVar=".response.folder";apiIdCall="`$(`$DefaultAvamarServer.baseAccessPoint.href)/folder/";XmlObject=$true},
@{name="Retention";dynamicApiCall="/detail/retention";returnVar=".response.retention";apiIdCall="`$(`$DefaultAvamarServer.baseAccessPoint.href)/retention/";XmlObject=$true},
@{name="Schedule";dynamicApiCall="/detail/schedule";returnVar=".response.schedule";apiIdCall="`$(`$DefaultAvamarServer.baseAccessPoint.href)/schedule/";XmlObject=$true},
@{name="Dataset";dynamicApiCall="/detail/dataset";returnVar=".response.dataset";apiIdCall="`$(`$DefaultAvamarServer.baseAccessPoint.href)/dataset/";XmlObject=$true},
@{name="HypervisorManager";dynamicApiCall="/detail/hypervisorManager";returnVar=".response.hypervisorManager";apiIdCall="`$(`$DefaultAvamarServer.baseAccessPoint.href)/hypervisorManager/";XmlObject=$true},
@{name="ClientPlugin";apiCall="`$(`$DefaultAvamarServer.accessPoint.href)/plugin";expectInputId=$false;returnVar=".response.plugin";XmlObject=$true},
@{name="ClientPluginDetail";apiCall="`$(`$InputObject.href)";returnVar=".response";XmlObject=$true},
@{name="ClientPluginInstance";returnVar="`$InputObject.pluginInstance";apiIdCall="`$(`$DefaultAvamarServer.baseAccessPoint.href)/pluginInstance/";XmlObject=$true},
@{name="Client";dynamicApiCall="/detail/client";returnVar=".response.client";apiIdCall="`$(`$DefaultAvamarServer.baseAccessPoint.href)/client/";XmlObject=$true},
@{name="ClientBackup";dynamicApiCall="/detail/backup";returnVar=".response.backup"},
@{name="ClientActivity";dynamicApiCall="/detail/job";returnVar=".response.job"},
@{name="Destination";dynamicApiCall="/detail/destination";returnVar=".response.destination";apiIdCall="`$(`$DefaultAvamarServer.baseAccessPoint.href)/destination/";XmlObject=$true},
@{name="Policy";dynamicApiCall="/detail/policy";returnVar=".response.policy";apiIdCall="`$(`$DefaultAvamarServer.baseAccessPoint.href)/policy/";XmlObject=$true},
@{name="AvamarTask";apiCall="`$(`$DefaultAvamarServer.accessPoint.href)/task";dynamicApiCall="/detail/task";returnVar=".response.task";apiIdCall="`$(`$DefaultAvamarServer.baseAccessPoint.href)/task/";NormalResponse="200,202";noRecurse=$true},
@{name="AvamarTaskDetail";apiCall="`$(`$InputObject.href)";returnVar=".response";XmlObject=$true;NormalResponse=202},
@{name="AvamarJob";dynamicApiCall="/job";returnVar=".response.job"},
@{name="AvamarSession";apiCall="/rest-api/session";returnVar=".response"} | %{
    $strCmdlet = @"
Function Get-$($_.Name) {
    [CmdletBinding()]
    param([Parameter(Mandatory=`$$([boolean]"$($_.expectInput)"), Position=0, ValueFromPipeline=`$true)]
        [psobject]`$InputObject,[string]`$name,[string]`$id,[ScriptBlock]`$FilterScript={`$_},
        [boolean]`$XmlObject =`$$([boolean]"$($_.XmlObject)"),
        [boolean]`$References =`$$([boolean]"$($_.References)"),
        [boolean]`$NoRecurse =`$$([boolean]"$($_.NoRecurse)"))
    Process {
        `$normalResponse = if(`"$($_.normalResponse)") { $($_.normalResponse) } else { 200 }
        `$returnVar = if(`"$($_.returnVar)`") { `"$($_.returnVar)`" }
        if(`$id -and "$($_.apiIdCall)") {
            `$apiCall = `"$($_.apiIdCall)`"+`$id.split(':')[-1]
            `$dynamicApiCall = `$null
            `$noRecurse = `$true
            `$returnVar = ".response"
        } elseif(!`"$($_.apiCall)`" -and !`"$($_.dynamicApiCall)`") {
            return $($_.returnVar)
        } elseif(`"$($_.apiCall)`" -and `"$($_.dynamicApiCall)`" -and !`$InputObject) {
            `$apiCall = `"$($_.apiCall)`"
            `$dynamicApiCall = `$null
        } elseif(`"$($_.apiCall)`" -and `"$($_.dynamicApiCall)`" -and `$InputObject) {
            `$apiCall = `$null
            `$dynamicApiCall = `"$($_.dynamicApiCall)`"
        } else {
            if(!"$($_.apiIdCall)" -and !"$($_.expectInputId)" -and `!`$InputObject) { throw "Missing -InputObject" }  
            `$apiCall = `"$($_.apiCall)`"
            `$dynamicApiCall = `"$($_.dynamicApiCall)`"
        }
        `$InputObject | Invoke-AvamarREST -Name `$name -id `$id -FilterScript `$FilterScript ``
            -XmlObject:([boolean]`$XmlObject) -References:([boolean]`$References) -NoRecurse:([boolean]`$NoRecurse) ``
            -NormalResponse `$NormalResponse ``
            -DynamicApiCall `$dynamicApiCall -ApiCall `$apiCall ``
            -ReturnVarInPlace `"$($_.ReturnVarInPlace)`" -ReturnVar `"`$returnVar`"
    }
}
"@
    Invoke-Expression $strCmdlet
}





@{name="DataProtectionResource";apiCall="`$null";returnVar=".response";normalResponse=202;runAsyncCapable=$true},
@{name="AvamarFolder";apiCall="`$null";returnVar=".response";normalResponse=202;runAsyncCapable=$true},
@{name="ResourceShare";apiCall="`$null";returnVar=".response";normalResponse=202;runAsyncCapable=$true},
@{name="AvamarResourcePool";apiCall="`$null";returnVar=".response";normalResponse=202;runAsyncCapable=$true},
@{name="Tenant";apiCall="`$null";returnVar=".response";normalResponse=202;runAsyncCapable=$true},
@{name="Client";apiCall="`$null";returnVar=".response";normalResponse=202;runAsyncCapable=$true},
@{name="Policy";apiCall="`$null";returnVar=".response";normalResponse=202;runAsyncCapable=$true},
@{name="Dataset";apiCall="`$null";returnVar=".response";normalResponse=202;runAsyncCapable=$true},
@{name="Schedule";apiCall="`$null";returnVar=".response";normalResponse=202;runAsyncCapable=$true},
@{name="Retention";apiCall="`$null";returnVar=".response";normalResponse=202;runAsyncCapable=$true},
@{name="Destination";apiCall="`$null";returnVar=".response";normalResponse=202;runAsyncCapable=$true},
@{name="HypervisorManager";apiCall="`$null";returnVar=".response";normalResponse=202;runAsyncCapable=$true},
@{name="PolicyClient";apiCall="`$null";dynamicApiCall="/action/removeClient";param="ReferenceList";httpType="PUT";returnVar=".response";normalResponse=200} | %{
    if($_.param) {
        $dynamicVar = New-ObjectAvamar -type $_.param -xml
        [array]$params = $dynamicVar.DocumentElement.Attributes.Name | where {$_} | %{ "`$$($_)" } | select -unique
        $params += $dynamicVar.DocumentElement.ChildNodes.Name | where {$_} | %{ "`$$($_)" } | select -unique
    }
    $strParams = if($_.param -and $params) { ","+($params -join ",") }
    $strRunAsync = if($_.runAsyncCapable) { ",[boolean]`$runAsync" }
    $strCmdlet = @"
Function Remove-$($_.Name) {
    [CmdletBinding()]
    param([Parameter(Mandatory=`$false, Position=0, ValueFromPipeline=`$true)]
        [psobject]`$InputObject$strParams
        $strRunAsync)
    Process {
        if("$($_.param)") {
            `$param = New-ObjectAvamar -type $($_.param) -xml
            `$psParam = `$param | ConvertTo-JsonFromXml | ConvertFrom-Json
            `$psParam.psobject.properties.name | %{
                if(`$psboundparameters.keys -contains "`$(`$_)") { 
                    `$psParam.`$_ = `$psboundparameters.`$_ 
                } elseif(`"$($_.removeBlankParams)`".split(',') -contains `$_ -and `$psboundparameters.keys -notcontains "`$(`$_)") {
                    [void]`$psParam.psobject.properties.remove(`$_)
                } 
            }
            Write-Host (`$psParam | fl * | Out-String)
            `$jsonParam = `$psParam | ConvertTo-Json -depth 10
        }
        try {
            if(!`$$($_.ContainsKey("apiCall")) -and !`$$($_.ContainsKey("dynamicApiCall"))) {
                `$result = `$InputObject
            } else {
                `$Href = if(`$$($_.ContainsKey("dynamicApiCall"))) { `$InputObject.Href+`"$($_.dynamicApiCall)`" } else {`$InputObject.Href} 
                write-verbose (`$href | Out-String)
                `$httpType = if(`"$($_.httpType)`") { `"$($_.httpType)`" } else { "DELETE" }
                `$normalResponse = if(`"$($_.normalResponse)") { $($_.normalResponse) } else { 204 }
                `$result = Invoke-AvamarBaseREST -href `$Href -apiCall $($_.apiCall) -httpType `$httpType -normalResponse `$normalResponse -content `$jsonParam
            }
            `$return = `$result$($_.returnVar)
            
        } catch {
            Write-Host -fore red "Problem with REST call"
            Throw `$_
        }

        `$return = if(`$myinvocation.mycommand.parameters.keys -contains "runAsync" -and !`$runAsync) { 
            `$return | Wait-AvamarTask
        } else {
            `$return
        }

        return (`$return)
    }
}
"@
    Invoke-Expression $strCmdlet
}


#$folder | get-client -name "192.168.1.250" | start-clientbackup -datasource (New-ObjectAvamar -type BackupSource -property @{source="c:\wmg.txt"}) -retention $retention -plugin $plugin -verbose
#$clientbackup =$folder.client[0] | Get-ClientBackup
#$clientbackup | Start-ClientRestore -destClient @{client=$clientbackup.client} -plugin $clientbackup.plugin -destinationPath "c:\restore\"  -verbose
#$clientbackup | Start-ClientRestore -destClient @{client=$clientbackup.client} -plugin $clientbackup.plugin -backupSource "c:\wmg.txt" -destinationPath "c:\restore\"  -verbose
#$clientbackup | Start-ClientRestore -destClient @{client=@{href=$clientbackup.client.href}} -plugin $clientbackup.plugin -backupSource @("[sda2]/etc/pythonstart") -destinationPath @("/tmp") -fileLevelRestore "true" -username root -password changeme -verbose
#$client  | Start-ClientBackup -dataSource @{"source"=@("c:\wmg.txt")} -plugin (Get-ClientPlugin -name "Windows File System") -retention ($folder | get-retention -name retention05) -verbose
#$client  | Start-ClientBackup -dataSource @{"dataset"=@("c:\wmg.txt")} -plugin $plugin -retention ($folder | get-retention -name retention01) -verbose
@{name="ClientBackup";dynamicApiCall="/action/backup";param="BackupRequest";httpType="POST";normalResponse=202;returnVar=".response";runAsync=$false;removeBlankParams="dynamicOption,pluginOption";xmlObject=$true},
@{name="ClientRestore";dynamicApiCall="/action/restore";param="RestoreRequest";httpType="POST";normalResponse=202;returnVar=".response";runAsync=$false;removeBlankParams="dynamicOption,pluginOption,backupSource,fileLevelRestore,username,password,destinationPath";XmlObject=$true},
@{name="ClientReplicate";dynamicApiCall="/action/replicate";param="ReplicateRequest";httpType="POST";normalResponse=202;returnVar=".response";runAsync=$false;xmlObject=$true},
@{name="PolicyBackup";dynamicApiCall="/action/backup";httpType="POST";normalResponse=202;returnVar=".response";runAsync=$false;xmlObject=$true} | %{
    if($_.param) {
        $dynamicVar = New-ObjectAvamar -type $_.param -xml
        [array]$params = $dynamicVar.DocumentElement.Attributes.Name | where {$_} | %{ "`$$($_)" } | select -unique
        $params += $dynamicVar.DocumentElement.ChildNodes.Name | where {$_} | %{ "`$$($_)" } | select -unique
    }    
    $strParams = if($_.param -and $params) { ","+($params -join ",") }
    
    $strRunAsync = if($_.runAsync -is [boolean] -and $_.runAsync) { ",[boolean]`$runAsync=`$True" } elseif($_.runAsync -is [boolean] -and !$_.runAsync) { ",[boolean]`$runAsync=`$False" }
    $strCmdlet = @"
Function Start-$($_.Name) {
    [CmdletBinding()]
    param([Parameter(Mandatory=`$false, Position=0, ValueFromPipeline=`$true)]
        [psobject]`$InputObject$strParams
        $strRunAsync)
    Process {
        
        if("$($_.param)") {
            `$ExpectedParam = New-ObjectAvamar -type $($_.param) -xml
            `$param = `$ExpectedParam.clone()
            `$psParam = `$param | ConvertTo-JsonFromXml | ConvertFrom-Json
            `$psParam.psobject.properties.name | %{
                if(`$psboundparameters.keys -contains "`$(`$_)" -and `$psboundparameters.`$_) { 
                    `$psParam.`$_ = `$psboundparameters.`$_ 
                    [array]`$arrParamArrays = `$ExpectedParam.DocumentElement.get_ChildNodes() | group LocalName | where {`$_.count -gt 1} | %{ `$_.Name }
                    if(`$arrParamArrays -contains `$_) { 
                        `$psParam.`$_ = @(`$psParam.`$_) | %{ if(`$_.href) { `$_ | select href } else { `$_ }}
                        [System.Collections.ArrayList]`$psParam.`$_ = @(`$psParam.`$_)
                    } else {
                        if(`$psParam.`$_.href) { `$psParam.`$_ = `$psParam.`$_ | select href }
                    }
                } elseif(`"$($_.removeBlankParams)`".split(',') -contains `$_ -and !`$psboundparameters.`$_) {
                    [void]`$psParam.psobject.properties.remove(`$_)
                } 
            }
            Write-Verbose "SENDING OBJECT:"
            Write-Verbose (`$psParam | fl * | Out-String)
            `$jsonParam = `$psParam | ConvertTo-Json -depth 10
        }

    
        if(!`$$($_.ContainsKey("apiCall")) -and !`$$($_.ContainsKey("dynamicApiCall"))) {
            `$result = `$InputObject
        } else {
            `$httpType = if(`"$($_.httpType)`") { "$($_.httpType)" } else { "PUT" }
            `$normalResponse = if(`"$($_.normalResponse)") { $($_.normalResponse) } else { 204 }
            if(`$RunAsync -isnot [boolean]) { `$RunAsync = `$true }
            `$apiCall = `"$($_.apiCall)`"
            `$dynamicApiCall = `"$($_.dynamicApiCall)`"
            `$XmlObject = if("$($_.XmlObject)") { "`$$($_.XmlObject)" }
            `$References = if("$($_.References)") { `$true }
            `$NoRecurse = if("$($_.NoRecurse)") { `$true }

            `$result = `$InputObject | Invoke-AvamarREST ``
                -XmlObject:([boolean]`$XmlObject) -References:([boolean]`$References) -NoRecurse:([boolean]`$NoRecurse) ``
                -NormalResponse `$NormalResponse -httpType `$httpType -content `$jsonParam ``
                -DynamicApiCall `$dynamicApiCall -ApiCall `$apiCall -RunAsync:`$RunAsync ``
                -ReturnVarInPlace `"$($_.ReturnVarInPlace)`" -ReturnVar `"$($_.ReturnVar)`"

        }
        `$return = `$result
       

        return (`$return)
    }
}
"@
    Invoke-Expression $strCmdlet
}

#Get-VM lguest-01 | Get-VMClient -folder ($folder | Get-HypervisorManagerFolder -path "/$($global:DefaultVIServer.name)/VirtualMachines")
Function Get-VMClient {
    [CmdletBinding()]
    param([Parameter(Mandatory=$true, Position=0, ValueFromPipeline=$true)]
          [VMware.VimAutomation.ViCore.Impl.V1.Inventory.InventoryItemImpl[]]$VM,$folder)
    Begin {
        $arrVM = @()
    } Process {
        $arrVM += $VM
    } End {
        [array]$arrClient = $folder | Get-Client
        $arrClient | where {$arrVM.extensiondata.summary.config.instanceuuid -contains $_.vmClientExt.vmUUID}
    }
    
}

#Get-VM lguest-01 | Get-VMClientMissing -folder ($folder | Get-HypervisorManagerFolder -path "/$($global:DefaultVIServer.name)/VirtualMachines")
Function Get-VMClientMissing {
    [CmdletBinding()]
    param([Parameter(Mandatory=$true, Position=0, ValueFromPipeline=$true)]
          [VMware.VimAutomation.ViCore.Impl.V1.Inventory.InventoryItemImpl[]]$VM,$folder)
    Begin {
        $arrVM = @()
    } Process {
        $arrVM += $VM
    } End {
        [array]$arrClient = $folder | Get-Client
        $arrVM | where {$arrClient.vmClientExt.vmUUID -notcontains $_.extensiondata.summary.config.instanceuuid}
    }
    
}

#Get-AvamarFolder -id $hvfolder.id | new-retention -name retention01 
#Get-AvamarFolder -id $hvfolder.id | get-client -name lguest-01 | Start-ClientVMBackup -retention $retention
#Get-AvamarFolder -id $hvfolder.id | get-client -name lguest-01 | Start-ClientVMBackup -retention (get-avamarfolder -id $hvfolder.id | get-retention -name retention01) -dataset (Get-AvamarFolder -id $hvfolder.id | get-dataset  -name vmdataset13-dd) -verbose
#Get-VM lguest-01 | Get-VMClient -folder ($folder | Get-HypervisorManagerFolder -path "/$($global:DefaultVIServer.name)/VirtualMachines") | Start-ClientVMBackup -retention (get-avamarfolder -id $hvfolder.id | get-retention -name retention01) -dataset (Get-AvamarFolder -id $hvfolder.id | get-dataset  -name vmdataset13-dd) -verbose
Function Start-ClientVMBackup {
    [CmdletBinding()]
    param([Parameter(Mandatory=$true, Position=0, ValueFromPipeline=$true)]
        [psobject]$InputObject,$retention=$(throw "missing -retention"),$pluginOption,$dynamicOption,$datasource=@{source=@("ALL")},$dataset
        ,[boolean]$runAsync=$False)
    Process {
        $pluginInstance = Get-ClientPluginInstance -id $InputObject.pluginInstance.id
        if(!$pluginInstance) { throw "missing Plugin Instance for client" }
        if($dataset) { $dataSource = @{dataset = $dataset | select href } }
        $InputObject | Start-ClientBackup -plugin $pluginInstance.plugin -dataSource $dataSource `
            -pluginOption $pluginOption -dynamicOption $dynamicOption -retention $retention -runAsync:$runAsync
    }
}

#$ClientBackup | Start-ClientVMRestoreFLR -backupSource @("[sda2]/etc/pythonstart") -destinationPath @("/tmp") -username root -password changeme
Function Start-ClientVMRestoreFLR {
    [CmdletBinding()]
    param([Parameter(Mandatory=$true, Position=0, ValueFromPipeline=$true)]
        [psobject]$InputObject,$backupSource,$destinationPath,$username,$password)
    Process {
        $InputObject | Start-ClientRestore -destClient @{client=@{href=$InputObject.client.href}} -plugin $InputObject.plugin -backupSource $backupSource `
            -destinationPath @($destinationPath) -fileLevelRestore "true" -username $username -password $password 
    }
}


#$clientbackup | Start-ClientVMRestore -inplace
#$ClientBackup | Start-ClientVMRestore -outofplace -name linux-12 -hypervisorManager $hm -datacenter brsvlab-datacenter -datastore nfs-01-ds -esxhost esx02.brsvlab.local -vmFolder test -verbose
Function Start-ClientVMRestore {
    [CmdletBinding()]
    param([Parameter(Mandatory=$true, Position=0, ValueFromPipeline=$true)]
        [psobject]$InputObject,[switch]$inPlace,[switch]$outOfPlace,$name,
        $hypervisorManager,$datacenter,$esxHost,$datastore,$vmFolder,$changedBlockTracking=$true)
    Process {
        if($inPlace) {
            $Client = Get-Client -id $ClientBackup.Client.id
            $destClient = @{vmIdentification=@{
                    name=$Client.name
                    hypervisorManager=@{href=$Client.vmClientExt.hypervisorManager.href}
                    datacenter=$Client.vmClientExt.datacenter
                    esxHost=$Client.vmClientExt.esxHost
                    datastore=@($Client.vmClientExt.datastore)
                    changedBlockTracking=$changedBlockTracking.toString().toLower()
                    vmFolder=$Client.vmClientExt.vmFolder
                }
            }
        }elseif($outOfPlace) {
            $destClient = @{vmIdentification=@{
                    name=$name
                    hypervisorManager=@{href=$hypervisorManager.href}
                    datacenter=$datacenter
                    esxHost=$esxHost
                    datastore=@($datastore)
                    changedBlockTracking=$changedBlockTracking.toString().toLower()
                    vmFolder=$vmFolder
                }
            }
        }else{
            Throw "must specify either -inPlace or -outOfPlace"
        }
        $InputObject | Start-ClientRestore -destClient $destclient -plugin $InputObject.plugin
    }
}




#New-AvamarResourcePool -name rp01
#Get-AvamarResourcePool -name rp01 | New-DataProtectionResource -name ave-03 -user MCUser -password 'MCUser1' -hostname ave-03.brsvlab.local
#Get-AvamarResourcePool -name rp01 | New-ResourceShare -name rs01 -dataprotectionresource @(Get-AvamarResourcePool -name rp01 | Get-DataProtectionResource -name ave-03) -tenant (Get-Tenant -name tenant01) -capacityInMB (1TB/1MB)
#Get-AvamarResourcePool -name rp01 | Get-ResourceShare -name rs01 | New-AvamarFolder -name folder01
#Get-AvamarResourcePool -name rp01 | Get-ResourceShare -name rs01 | Get-AvamarFolder -name folder01 | New-Tenant -name tenant01 
#Get-tenant -name tenant01 | get-avamarfolder -name folder01 | New-Client -name 
#
#Get-tenant -name tenant01 | get-avamarfolder -name folder01 | new-retention -name retention01 
#New-ObjectAvamar -type retentionduration -property @{unit="days";duration=60}
#Get-tenant -name tenant01 | get-avamarfolder -name folder01 | new-retention -name retention03 -retentionduration (New-ObjectAvamar -type retentionduration -property @{unit="days";duration=60})
#Get-tenant -name tenant01 | get-avamarfolder -name folder01 | new-retention -name retention01 
#get-tenant -name tenant01 | get-avamarfolder -name folder01 | new-dataset -name dataset03 -datasetitem (New-ObjectAvamar datasetitem -property @{name="datasetItem01";datasetInclude=(New-ObjectAvamar datasetinclude -Property @{name="include";value="ALL"});plugin=(Get-ClientPlugin -name "Windows File System");datasetTarget=@(@{name="target";value="ALL"})}) -verbose
#get-tenant -name tenant01 | get-avamarfolder -name folder01 | new-dataset -name dataset02 -datasetitem (New-ObjectAvamar datasetitem -property @{name="datasetItem01";datasetInclude=(New-ObjectAvamar datasetinclude -Property @{name="test";value="test2"});plugin=(Get-ClientPlugin -name "Windows File System");datasetOption=@(@{name="ddr";value="true"},@{name="ddr-index";value=1});datasetTarget=@(@{name="target";value="ALL"})}) -verbose

#get-tenant -name tenant01 | get-avamarfolder -name folder01 | new-dataset -name dataset02 -datasetitem (New-ObjectAvamar datasetitem -property @{name="datasetItem01";datasetInclude=(New-ObjectAvamar datasetinclude -Property @{name="test";value="test2"});plugin=(Get-ClientPlugin -name "Windows File System")}) -verbose
#get-tenant -name tenant01 | get-avamarfolder -name folder01 | New-Schedule -name schedule01 -dailySchedule (new-objectAvamar -type dailyschedule -property @{timeOfDays=@("00:00:00.000-07:00","01:00:00.000-07:00");maxRunHour=1}) -verbose
#$folder = get-tenant -name tenant01 | get-avamarfolder -name folder01
#get-tenant -name tenant01 | get-avamarfolder -name folder01 | New-Policy -name policy01 -dataset $folder.dataset[0] -schedule $folder.schedule[0] -retention $folder.retention[0]
#$folder.policy[0] | New-PolicyClient -Reference $folder.client[0] -verbose
#get-tenant -name tenant01 | get-avamarfolder -name folder01 | New-Policy -name policy01 -dataset ($hvmfolder | get-dataset -name vmdataset13-dd) -schedule ($hvmfolder | get-schedule -name schedule01) -retention ($hvmfolder | get-retention -name retention01)
#$hvmfolder | New-Policy -name policy01 -dataset ($hvmfolder | get-dataset -name vmdataset13-dd) -schedule ($hvmfolder | get-schedule -name schedule01) -retention ($hvmfolder | get-retention -name retention01)

#$hvmfolder | get-policy -name policy01 | New-PolicyClient -Reference (Get-VM lguest-01 | Get-VMClient -folder ($folder | Get-HypervisorManagerFolder -path "/$($global:DefaultVIServer.name)/VirtualMachines")) -verbose


#$folder | New-HypervisorManager -name master-vc.brsvlab.local -hostname master-vc.brsvlab.local -username root -password Password123!
#$folder | New-ClientVMProxy -name avproxy-03.brsvlab.local -dataProtectionResource ($folder.resourceShare | Get-DataProtectionResource -name ave-03) 

#$clientbackup | New-ClientBackupBrowse -path c: | ft * -autosize
#New-ObjectAvamar -type clientvm -Xmlproperty @{"vmclientext.changedblocktracking"="true";"vmclientext.vmuuid"="test"}

#$resourceShare | New-ResourceShareFromSplit -name testsplit -verbose -capacityInMB 20
#$resourceShare | update-resourceshareresize -capacityInMB 200 -verbose
@{name="DataProtectionResource";dynamicApiCall="/dataProtectionResource";param="DataProtectionResource";returnVar=".response";normalResponse=201;expectInput="true"},
@{name="ResourceShare";dynamicApiCall="/resourceShare";param="ResourceShare";returnVar=".response";normalResponse=201;removeBlankParams="tenant,resourcePool,folder";expectInput="true"},
@{name="AvamarFolder";dynamicApiCall="/folder";param="Folder";returnVar=".response";normalResponse=202;expectInput="true";runAsync=$false;XmlObject=$true;PostTaskLookupCmd="Get-AvamarFolder -id"},
@{name="Retention";dynamicApiCall="/retention";param="Retention";returnVar=".response";normalResponse=201;expectInput="true";removeBlankParams="expirationDate"},
@{name="Schedule";dynamicApiCall="/schedule";param="Schedule";returnVar=".response";normalResponse=201;expectInput="true"},
@{name="Dataset";dynamicApiCall="/dataset";param="Dataset";returnVar=".response";normalResponse=201;expectInput="true"},
@{name="Client";dynamicApiCall="/client";param="Client";returnVar=".response";normalResponse=202;expectInput="true";runAsync=$false;XmlObject=$true;PostTaskLookupCmd="Get-Client -id"},
@{name="ClientVMProxy";dynamicApiCall="/client";param="ClientVMProxy";returnVar=".response";normalResponse=202;expectInput="true";runAsync=$false;XmlObject=$true;removeBlankParams="dataProtectionResource";PostTaskLookupCmd="Get-Client -id"},
@{name="Destination";dynamicApiCall="/destination";param="Destination";returnVar=".response";normalResponse=201;expectInput="true"},
@{name="Policy";dynamicApiCall="/policy";param="Policy";returnVar=".response";normalResponse=201;expectInput="true"},
@{name="PolicyClient";dynamicApiCall="/action/addClient";param="ReferenceList";httpType="PUT";returnVar=".response";normalResponse=200;expectInput="true"},
@{name="AvamarResourcePool";apiCall="`$(`$DefaultAvamarServer.accessPoint.href)/resourcePool";param="ResourcePool";returnVar=".response";normalResponse=201},
@{name="ResourceShareFromSplit";dynamicApiCall="/action/split";param="ResourceShare";returnVar=".response";normalResponse=201;forceParams="name,capacityInMB";expectInput="true"},
@{name="Tenant";apiCall="`$(`$DefaultAvamarServer.accessPoint.href)/tenant";param="Tenant";returnVar=".response";normalResponse=201;removeBlankParams="resourceShare"},
@{name="AvamarBrowse";dynamicApiCall="/action/browse";param="ClientBrowseRequest";returnVar=".response.metadata";normalResponse=201;expectInput="true";XmlObject=$true},
@{name="ClientBackupBrowse";dynamicApiCall="/action/browse";param="BackupBrowseRequest";returnVar=".response.metadata | Format-AvamarBrowse";normalResponse=201;expectInput="true";XmlObject=$true},
@{name="HypervisorManager";dynamicApiCall="/hypervisorManager";param="HypervisorManager";returnVar=".response";normalResponse=202;expectInput="true";runAsync=$false;XmlObject=$true;PostTaskLookupCmd="Get-HypervisorManager -id"} | %{
    $funcParams = $_
    $dynamicVar = New-ObjectAvamar -type $_.param -xml
    [array]$params = $dynamicVar.DocumentElement.Attributes.Name | where {$_} | %{ "`$$($_)" } | select -unique
    $params += $dynamicVar.DocumentElement.ChildNodes.Name | where {$_} | %{ "`$$($_)" } | select -unique
    if($_.forceParams) { [array]$params = $params | where {@($funcParams.forceParams.split(',') | %{"`$$($_)"}) -contains $_ } }
    $strRunAsync = if($_.runAsync -is [boolean] -and $_.runAsync) { ",[boolean]`$runAsync=`$True" } elseif($_.runAsync -is [boolean] -and !$_.runAsync) { ",[boolean]`$runAsync=`$False" }
    $strParams = if($_.param -and $params) { ","+($params -join ",") }
    $strCmdlet = @"
Function New-$($_.Name) {
    [CmdletBinding()]
    param([Parameter(Mandatory=`$$([boolean]"$($_.expectInput)"), Position=0, ValueFromPipeline=`$true)]
        [psobject]`$InputObject,`$param$strParams
        $strRunAsync)
    Process {
        `$ExpectedParam = New-ObjectAvamar -type $($_.param) -xml
        if(!`$param) { 
            `$param = `$ExpectedParam.clone()
            `$psParam = `$param | ConvertTo-JsonFromXml | ConvertFrom-Json
        } else { `$psParam = `$param }
        `$psParam.psobject.properties.name | %{
            if(`$psboundparameters.keys -contains "`$(`$_)") { 
                `$psParam.`$_ = `$psboundparameters.`$_
                [array]`$arrParamArrays = `$ExpectedParam.DocumentElement.get_ChildNodes() | group LocalName | where {`$_.count -gt 1} | %{ `$_.Name }
                if(`$arrParamArrays -contains `$_) { 
                    `$psParam.`$_ = @(`$psParam.`$_) | %{ if(`$_.href) { `$_ | select href } else { `$_ }}
                    [System.Collections.ArrayList]`$psParam.`$_ = @(`$psParam.`$_)
                } else {
                    if(`$psParam.`$_.href) { `$psParam.`$_ = `$psParam.`$_ | select href }
                }
            } elseif(`"$($_.removeBlankParams)`".split(',') -contains `$_ -and `$psboundparameters.keys -notcontains "`$(`$_)") {
                if(!`$psParam.`$_) { [void]`$psParam.psobject.properties.remove(`$_) }
            } elseif(`"$($_.forceParams)`" -and `"$($_.forceParams)`".split(',') -notcontains `$_) {
                [void]`$psParam.psobject.properties.remove(`$_)
            }
        }

        write-verbose "`nSENDING OBJECT"
        write-verbose (`$psParam | fl * | out-string)

        `$jsonParam = `$psParam | ConvertTo-Json -depth 10
        `$httpType = if("$($_.httpType)") { "$($_.httpType)" } else { "POST" }
        if(`$RunAsync -isnot [boolean]) { `$RunAsync = `$true }
        `$XmlObject = if("$($_.XmlObject)") { "`$$($_.XmlObject)" }
        `$References = if("$($_.References)") { `$true }
        `$NoRecurse = if("$($_.NoRecurse)") { `$true }
        `$result = `$InputObject | Invoke-AvamarREST  ``
            -XmlObject:([boolean]`$XmlObject) -References:([boolean]`$References) -NoRecurse:([boolean]`$NoRecurse) ``
            -Content `$jsonParam ``
            -NormalResponse $($_.NormalResponse) -httpType `$httpType ``
            -DynamicApiCall `"$($_.DynamicApiCall)`" -ApiCall `"$($_.ApiCall)`" ``
            -ReturnVarInPlace `"$($_.ReturnVarInPlace)`" -ReturnVar `"$($_.ReturnVar)`" ``
            -RunAsync:`$RunAsync -ReturnVarTask "$($_.ReturnVarTask)" -PostTaskLookupCmd `"$($_.PostTaskLookupCmd)`"


        #`$return = `$result   
         #$($_.returnVar)



        return `$result
    }
}
"@
    Invoke-Expression $strCmdlet
}


#$client | New-ClientBrowse -verbose -plugin $plugin -path "/"
#$client | New-ClientBrowse -plugin $plugin -path c: | ft * -autosize
Function New-ClientBrowse {
    [CmdletBinding()]
    param([Parameter(Mandatory=$True, Position=0, ValueFromPipeline=$true)]
    [psobject]$InputObject,$param,$path,$pluginInstance)
    Process {
        if(!$InputObject.pluginInstance) { $InputObject = Get-Client -id $InputObject.id }
        $pluginInstanceId = if(!$pluginInstance) { $InputObject.pluginInstance.Id } else { $InputObject.pluginInstance | where {$_.name.split(':')[1] -eq $pluginInstance} | %{ $_.id } }
        $pluginInstance = Get-ClientPluginInstance -id $pluginInstanceId
        if(!$pluginInstance) { throw "missing Plugin Instance for client" }

        $InputObject | New-AvamarBrowse -plugin $pluginInstance.plugin -path $path | Format-AvamarBrowse
    }
}

#get-avamarfolder -id $hvfolder.id | Get-Client | New-ClientVMBrowse -path
Function New-ClientVMBrowse {
    [CmdletBinding()]
    param([Parameter(Mandatory=$True, Position=0, ValueFromPipeline=$true)]
    [psobject]$InputObject,$param)
    Process {
        $pluginInstance = Get-ClientPluginInstance -id $InputObject.pluginInstance.id
        if(!$pluginInstance) { throw "missing Plugin Instance for client" }

        $InputObject | New-AvamarBrowse -plugin $pluginInstance.plugin
    }
}

#$hvfolder | New-ClientVM -name linux-03 -vmUuid blah
#$hvfolder = $folder | get-hypervisormanagerfolder -path /master-vc.brsvlab.local/VirtualMachines
#$hvfolder | New-ClientVM -name lguest-01 -datacenter brsvlab-datacenter 
#$hvmfolder | New-ClientVM -vm (Get-VM | Get-VMClientMissing -folder $hvmfolder)
Function New-ClientVM {
    [CmdletBinding()]
    param([Parameter(Mandatory=$True, Position=0, ValueFromPipeline=$true)]
    [psobject]$InputObject,$param,$name,$vmUuid,$vmFolder="/",$dataCenter,[boolean]$changedBlockTracking=$True,
    $description,$contact,$phone,$email,$location,$clientOS,[VMware.VimAutomation.ViCore.Impl.V1.Inventory.InventoryItemImpl[]]$VM
    ,[boolean]$runAsync=$False)
    Process {
        
        if(!$param) {$param = New-ObjectAvamar -type ClientVM}

        if($VM) {
            $VM | %{
                $param.vmClientExt = New-ObjectAvamar -type vmclientext -XmlProperty @{changedBlockTracking=$changedBlockTracking.toString().toLower();vmUUID=$_.ExtensionData.summary.config.instanceUuid}
                $InputObject | New-Client -param $param -name $_.name -description $description `
                -contact $contact -phone $phone -email $email -location $location -clientos $clientos `
                -runAsync:$RunAsync
            }
            return
        }
        
        if($vmUuid) {
            $param.vmClientExt = New-ObjectAvamar -type vmclientext -XmlProperty @{changedBlockTracking=$changedBlockTracking.toString().toLower();vmUUID=$vmUuid}
        }elseif($VmFolder) {
            $param.vmClientExt = @{changedBlockTracking=$changedBlockTracking;dataCenter=$dataCenter;vmFolder=$VmFolder}
        }
        $InputObject | New-Client -param $param -name $name -description $description `
            -contact $contact -phone $phone -email $email -location $location -clientos $clientos `
            -runAsync:$RunAsync
  
    }

}

#$hvfolder | New-DatasetVMware -name vmdataset01 -verbose
#$hvfolder | New-DatasetVMware -name vmdataset01 -DataDomainIndex 1 -verbose
Function New-DatasetVMware {
    [CmdletBinding()]
    param([Parameter(Mandatory=$True, Position=0, ValueFromPipeline=$true)]
    [psobject]$InputObject,$name=$(throw "missing -name"),[string]$DataDomainIndex)
    Process {
        $ClientPlugin = Get-ClientPlugin
        $CPWindows = $ClientPlugin | where {$_.name -eq "Windows VMware Image"}
        $CPLinux = $ClientPlugin | where {$_.name -eq "Linux VMware Image"}
        $DatasetProperty = @{
            datasetItem=@(
                @{name="linuxvm";plugin=@{href=$CPLinux.href};datasetTarget=@(@{name="target";value="ALL"})},
                @{name="windowsvm";plugin=@{href=$CPWindows.href};datasetTarget=@(@{name="target";value="ALL"})};
                );
            
        }
        if($DataDomainIndex) {
            $DatasetProperty.datasetItem | %{ 
                $_.datasetOption = @(
                    @{name="ddr";value="true"},@{name="ddr-index";value=$DataDomainIndex}
                )
            }
        }
        $InputObject | New-Dataset -name $name -param (New-ObjectAvamar -type datasetvmware -property $DatasetProperty)
            
            

    }

}

#$folder | Get-HypervisorManagerFolder -Path "/master-vc.brsvlab.local/VirtualMachines"  | get-client
Function Get-HypervisorManagerFolder {
    [CmdletBinding()]
    param([Parameter(Mandatory=$True, Position=0, ValueFromPipeline=$true)]
        [psobject]$InputObject,[string]$Path=$(throw "missing -Path"))
    Process {
    #get-Avamarfolder -id ($folder | Get-HypervisorManager -name master-vc.brsvlab.local | %{$_.hypervisormanagerfolder.id}) | get-Avamarfolder -name "VirtualMachines" 
        [array]$arrPath = $path.split('/') | where {$_}
        $Folder = Get-AvamarFolder -id ($InputObject | Get-HypervisorManager -name $arrPath[0] | %{ $_.HypervisorManagerFolder.Id })
        for($i=1;$i -lt $arrPath.count;$i++) {
            Write-Verbose "Looking for $($arrPath[$i])"
            $Folder = Get-AvamarFolder -id $Folder.id | %{ $_.child } | where {$_.name -eq $arrPath[$i]}
        }
        return (Get-AvamarFolder -id $Folder.id)
    }
}

Function Get-HypervisorManagerFolderVM {
    [CmdletBinding()]
    param([Parameter(Mandatory=$True, Position=0, ValueFromPipeline=$true)]
        [psobject]$InputObject,[string]$Name=$(throw "missing -Name"))
    Process {
        $InputObject | Get-HypervisorManagerFolder -path "/$($name)/VirtualMachines"
    }
}

Function Format-AvamarBrowse {
    [CmdletBinding()]
    param([Parameter(Mandatory=$false, Position=0, ValueFromPipeline=$true)]
        [psobject]$Browse)
    Process {
        if($Browse) {
            $hashType=@{number="double";string="string";dateTime="dateTime";boolean="boolean";VMDISK="VMDISK"}
            Invoke-Expression "[pscustomobject]@{metadataType=`$Browse.metadataType;$($Browse.kv | %{"$($_.k)=[$($hashType.($_.v.vtype))]'$($_.v.value)';"});name=`$Browse.name}" `
                | select name,metadataType,protection,size,date,user,group,fstype,links,internal
        }        
    }
}

#Get-Tenant -name tenant | Get-TenantActivity | ft * -autosize
Function Get-TenantActivity {
[CmdletBinding()]
    param([Parameter(Mandatory=$false, Position=0, ValueFromPipeline=$true)]
        [psobject]$InputObject)
    Process {
        $InputObject | Get-AvamarJob | select jobtype,@{n="client";e={$_.client.name}},
            status,elapsedTime,progressBytes,newbytespercent,startTime,endTime | sort startTime -desc
    }
}

#
#$folder | get-client -name avproxy-03.brsvlab.local | update-vmproxydatastore -hypervisormanager ($folder | get-hypervisormanager -name master-vc.brsvlab.local) -adddatastore $datastore
#$folder | get-client -name avproxy-03.brsvlab.local | update-vmproxydatastore -hypervisormanager ($folder | get-hypervisormanager -name master-vc.brsvlab.local) -adddatastore (get-datasatore nfs-ds-01)
#$folder | get-client -name avproxy-03.brsvlab.local | update-vmproxydatastore -hypervisormanager ($folder | get-hypervisormanager -name master-vc.brsvlab.local) -removedatastore $datastore
#(new-object -type psobject -property @{url=(get-datastore nfs-01-ds).extensiondata.summary.url})
Function Update-VmProxyDatastore {
[CmdletBinding()]
    param([Parameter(Mandatory=$false, Position=0, ValueFromPipeline=$true)]
        [psobject]$InputObject,$hypervisorManager,[array]$addDatastore,[array]$removeDatastore)
    Process {
        [array]$addDatastore = $addDatastore | %{
            if($_ -is [VMware.VimAutomation.ViCore.Impl.V1.DatastoreManagement.DatastoreImpl]) { 
                New-Object -type psobject -property @{url=$_.extensiondata.summary.url}
            } else { $_ }
        }
        [array]$removeDatastore = $removeDatastore | %{
            if($_ -is [VMware.VimAutomation.ViCore.Impl.V1.DatastoreManagement.DatastoreImpl]) { 
                New-Object -type psobject -property @{url=$_.extensiondata.summary.url}
            } else { $_ }
        }

        if($addDatastore) {
            @{href="$($InputObject.href)/hypervisorManager/$($hypervisormanager.id)"} | Update-HypervisorManagerAddDatastore -vmDatastore @($addDatastore | select url)
        }elseif($removeDatastore) {
            @{href="$($InputObject.href)/hypervisorManager/$($hypervisormanager.id)"} | Update-HypervisorManagerRemoveDatastore -vmDatastore @($removeDatastore | select url)
        }
    }
}

#Get-AvamarResourcePool | Get-AvamarResourcePoolDetail | Get-ResourceShare | select -first 1 | Get-ResourceShareDetail | get-Avamarfolder  | Get-AvamarFolderDetail | get-client | ?{$_.name -eq "test4"} | start-clientinvite
#Get-AvamarResourcePool | Get-AvamarResourcePoolDetail | Get-ResourceShare | Get-ResourceShareDetail | select -last 1 | Update-ResourceShare -name test70
#$folder.schedule[0] | Update-ScheduleResume -verbose
#$folder.schedule[0] | Update-ScheduleSuspend -verbose
#$resourceShare | Update-ResourceShareSuspend
#$resourceShare | Update-ResourceShareResume
#$resourceShare | Update-ResourceShareExpand -capacityInMB "200" -dataProtectionResource @($dataProtectionResource)
#$dataProtectionResource | Update-DataProtectionResourceSuspend
#$dataProtectionResource | Update-DataProtectionResourceResume
#$resourcePool.resourceShare[0] | Update-ResourceShareCombine -href $resourcePool.resourceShare[1].href
#$folder = get-avamarfolder -id (get-avamarfolder -id $hvfolder.folder.id).folder.id
#$folder | Get-HypervisorManager | Update-HypervisorManagerAddDatastore -vmDatastore @{href=$datastore.url} -verbose
@{name="Client";param="Client";returnVar=".response";normalResponse=200},
@{name="ClientInvite";dynamicApiCall="/action/invite";returnVar=".response";normalResponse=204},
@{name="ClientRetire";dynamicApiCall="/action/retire";returnVar=".response";normalResponse=202;runAsync=$false;XmlObject=$true},
@{name="DataProtectionResource";param="DataProtectionResource";returnVar=".response";normalResponse=200},
@{name="DataProtectionResourceSuspend";dynamicApiCall="/action/suspend";returnVar=".response";normalResponse=200},
@{name="DataProtectionResourceResume";dynamicApiCall="/action/resume";returnVar=".response";normalResponse=200},
@{name="AvamarFolder";param="Folder";returnVar=".response";normalResponse=200},
@{name="Policy";param="Policy";returnVar=".response";normalResponse=200},
@{name="ResourceShare";param="ResourceShare";returnVar=".response";normalResponse=200},
@{name="ResourceShareSuspend";dynamicApiCall="/action/suspend";returnVar=".response";normalResponse=202;runAsync=$false;XmlObject=$true},
@{name="ResourceShareResume";dynamicApiCall="/action/resume";returnVar=".response";normalResponse=202;runAsync=$false;XmlObject=$true},
@{name="ResourceShareCombine";dynamicApiCall="/action/combine";param="Reference";httpType="POST";returnVar=".response";normalResponse=201;runAsync=$false;forceParams="href";XmlObject=$true},
@{name="ResourceShareResize";dynamicApiCall="/action/resize";param="ResourceShare";returnVar=".response";normalResponse=202;runAsync=$false;forceParams="capacityInMB";XmlObject=$true},
@{name="ResourceShareExpand";dynamicApiCall="/action/expand";param="ResourceShare";returnVar=".response";normalResponse=202;runAsync=$false;forceParams="capacityInMB,dataProtectionResource";XmlObject=$true},
@{name="AvamarResourcePool";param="ResourcePool";returnVar=".response";normalResponse=200},
@{name="Retention";param="Retention";returnVar=".response";normalResponse=200},
@{name="Destination";param="Destination";returnVar=".response";normalResponse=200},
@{name="Tenant";param="Tenant";returnVar=".response";normalResponse=200},
@{name="Dataset";param="Dataset";returnVar=".response";normalResponse=200},
@{name="HypervisorManager";param="HypervisorManager";returnVar=".response";normalResponse=200},
@{name="ScheduleSuspend";dynamicApiCall="/action/suspend";returnVar=".response";normalResponse=202;runAsync=$false;XmlObject=$true},
@{name="ScheduleResume";dynamicApiCall="/action/resume";returnVar=".response";normalResponse=202;runAsync=$false;XmlObject=$true},
@{name="HypervisorManagerRemoveDatastore";dynamicApiCall="/action/removeDatastore";param="VmDatastoreList";returnVar=".response";normalResponse=200},
@{name="HypervisorManagerAddDatastore";dynamicApiCall="/action/addDatastore";param="VmDatastoreList";returnVar=".response";normalResponse=200} | %{
    if($_.param) {
        $funcParams = $_
        $dynamicVar = New-ObjectAvamar -type $_.param -xml
        [array]$params = $dynamicVar.DocumentElement.Attributes.Name | where {$_} | %{ "`$$($_)" } | select -unique
        $params += $dynamicVar.DocumentElement.ChildNodes.Name | where {$_} | %{ "`$$($_)" } | select -unique
        if($_.forceParams) { [array]$params = $params | where {@($funcParams.forceParams.split(',') | %{"`$$($_)"}) -contains $_ } }
    }
    $strParams = if($_.param -and $params) { ","+($params -join ",") }
    $strRunAsync = if($_.runAsync -is [boolean] -and $_.runAsync) { ",[boolean]`$runAsync=`$True" } elseif($_.runAsync -is [boolean] -and !$_.runAsync) { ",[boolean]`$runAsync=`$False" }
    $strCmdlet = @"
Function Update-$($_.Name) {
    [CmdletBinding()]
    param([Parameter(Mandatory=`$$([boolean]"$($_.expectInput)"), Position=0, ValueFromPipeline=`$true)]
        [psobject]`$InputObject$strParams
        $strRunAsync)
    Process {
        if(`"$($_.param)`") {
            `$ExpectedParam = New-ObjectAvamar -type $($_.param) -xml
            `$validParam = New-ObjectAvamar -type $($_.param) 
            `$psParam = `$InputObject.psobject.copy()
            if(`"$($_.forceParams)`") {
                `$psParam.psobject.properties.name | %{ 
                    if(@(`"$($_.forceParams)`".split(',')) -notcontains `$_) { [void]`$psParam.psobject.properties.remove(`$_) } 
                }
            }
            [array]`$arrParamArrays = `$ExpectedParam.DocumentElement.get_ChildNodes() | group LocalName | where {`$_.count -gt 1} | %{ `$_.localName }
            `$psboundparameters.keys | %{ 
                if(`$validParam.psobject.properties.name -contains `$_) {
                    `$paramName = `$_
                    #`$paramValue = `$psboundparameters.`$_
                    if(`$arrParamArrays -contains `$_) { 
                        `$tmpArr = @(`$psboundparameters.`$_) | %{ if(`$_.href) { `$_ | select href } else { `$_ } }
                        [System.Collections.ArrayList]`$paramValue = @(`$tmpArr)
                    } elseif(`$psParam.`$_.href) { 
                        `$paramValue = `$psboundparameters.`$_ | select href 
                    } else { `$paramValue = `$psboundparameters.`$_ }

                    try { `$psParam.`$paramName = `$paramValue } catch { 
                        `$psParam | Add-Member -type noteproperty -name `$paramName -value `$paramValue
                    }
                } 
            }

            write-verbose "`nSENDING OBJECT"
            write-verbose (`$psParam | out-string)

            `$jsonParam = `$psParam | ConvertTo-Json -depth 10
        }


        
        `$httpType = if("$($_.httpType)") { "$($_.httpType)" } else { "PUT" }
        `$normalResponse = if(`"$($_.normalResponse)") { $($_.normalResponse) } else { 204 }
        if(`$RunAsync -isnot [boolean]) { `$RunAsync = `$true }
        `$XmlObject = if("$($_.XmlObject)") { "`$$($_.XmlObject)" }
        `$References = if("$($_.References)") { `$true }
        `$NoRecurse = if("$($_.NoRecurse)") { `$true }
        `$result = `$InputObject | Invoke-AvamarREST  ``
            -XmlObject:([boolean]`$XmlObject) -References:([boolean]`$References) -NoRecurse:([boolean]`$NoRecurse) ``
            -Content `$jsonParam ``
            -NormalResponse $($_.NormalResponse) -httpType `$httpType ``
            -DynamicApiCall `"$($_.DynamicApiCall)`" -ApiCall `"$($_.ApiCall)`" ``
            -ReturnVarInPlace `"$($_.ReturnVarInPlace)`" -ReturnVar `"$($_.ReturnVar)`" ``
            -RunAsync:`$RunAsync -ReturnVarTask "$($_.ReturnVarTask)" -PostTaskLookupCmd `"$($_.PostTaskLookupCmd)`"
        return (`$result)
    }
}
"@
    Invoke-Expression $strCmdlet
}


Function Wait-AvamarTask {
    [CmdletBinding()]
    param([Parameter(Mandatory=$false, Position=0, ValueFromPipeline=$true)]
        [psobject]$InputObject,$sleep=5)
    Process {
        $task = $InputObject
        Write-Host "$(Get-Date): $($task.operation) ($($task.state))"
        if("QUEUED","RUNNING" -contains $task.state) {
            do {
                sleep $sleep
                $task = Get-AvamarTask -id $task.id
                Write-Host "$(Get-Date): $($task.operation) ($($task.state))"
            } while("QUEUED","RUNNING" -contains $task.state)
        }
        if($task.state -eq "ERROR") {
            Write-Host -fore red ($task | select operation,errorCode,message,stackTrace | fl * -force | out-string)
            throw "Error in task"
        }
        $task
    }
}

#$xml | ConvertTo-JsonFromXml
Function ConvertTo-JsonFromXml {
    param([Parameter(Mandatory=$false, Position=0, ValueFromPipeline=$true)]
    $xml)
    Begin {
        Function Get-XmlRecursive {
            param([Parameter(Mandatory=$false, Position=0, ValueFromPipeline=$true)]
            $xml)
            Process {        
                $hashOut = @{}
                if($xml.LocalName -eq "#document") { $rootElement = $xml.DocumentElement.toString(); $hashOut.$rootElement = @{} } else {
                    $rootElement = $null
                }
                $xmlRootElement = if($rootElement) { $xml.$rootElement } else { $xml }
                $hashOutRootElement = if($rootElement) { $hashOut.$rootElement } else { $hashOut }
                $xmlRootElement.Attributes | %{ 
                    $hashOutRootElement.("$($_.name)") = $_."#text"
                }
                $xmlRootElement.ChildNodes | %{ 
                    if($_.ChildNodes.Name -eq "#text") {
                        if(!$hashOutRootElement.("$($_.name)")) { 
                            $hashOutRootElement.("$($_.name)") = $_."#text"
                        }else {
                            [array]$hashOutRootElement.("$($_.name)") += $_."#text"
                        }
                    } elseif($_.LocalName) {
                        if($_.childNodes.count -gt 0 -or $_.attributes.count -gt 0) {
                            if(!$hashOutRootElement.($_.LocalName)) { 
                                $hashOutRootElement.($_.LocalName) = $_ | Get-XmlRecursive
                            }else {
                                [array]$hashOutRootElement.($_.LocalName) += $_ | Get-XmlRecursive
                            }
                        } else { 
                            $hashOutRootElement.($_.LocalName) = $null 
                        }
                    } 
                }
                return ($hashOutRootElement)# | ConvertTo-Json )
            }
        }
    }
    Process {
        return ($Xml | Get-XmlRecursive | ConvertTo-Json -depth 10)
    }
}

