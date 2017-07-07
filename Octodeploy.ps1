
$apiKey = "" #Octopus API Key
$OctopusURL = "http://kwanzaabot/" #Octopus URL

$ProjectName = "m2metrics" #project name
$EnvironmentName = "Test" #environment name

#$MachineName = "" #Machine name in Octopus. Accepts only 1 Machine.

$ReleaseVersion = "Latest" #Version of the release you want to deploy.


##PROCESS##

$Header =  @{ "X-Octopus-ApiKey" = $apiKey }

#Getting Project
Try{
    $Project = Invoke-WebRequest -Uri "$OctopusURL/api/projects/$ProjectName" -Headers $Header -ErrorAction Ignore| ConvertFrom-Json
    }
Catch{
    Write-Error $_
    Throw "Project not found: $ProjectName"
}

#
Write-Host " The Project is: $ProjectName"


#Getting environment
$Environment = Invoke-WebRequest -Uri "$OctopusURL/api/Environments/all"  -Headers $Header| ConvertFrom-Json



$Environment = $Environment | ?{$_.name -eq $EnvironmentName}

If($Environment.count -eq 0){
    throw "Environment not found: $EnvironmentName"
}
Write-Host " The Environment is $EnvironmentName"

#Getting Release

If($ReleaseVersion -eq "Latest"){
    $release = ((Invoke-WebRequest "$OctopusURL/api/projects/$($Project.Id)/releases" -Headers $Header).content | ConvertFrom-Json).items | select -First 1
    If($release.count -eq 0){
        throw "No releases found for project: $ProjectName"
    }
}
else{
    Try{
    $release = (Invoke-WebRequest "$OctopusURL/api/projects/$($Project.Id)/releases/$ReleaseVersion" -UseBasicParsing ) #-Headers $Header).content | ConvertFrom-Json
    }
    Catch{
        Write-Error $_
        throw "Release not found: $ReleaseVersion"
    }
}

Write-Host " Release: $ReleaseVersion"


#Creating deployment
$DeploymentBody = @{
            ReleaseID = $release.Id
            EnvironmentID = $Environment.id
            #SpecificMachineIDs = @($machine.id)
          } | ConvertTo-Json

$d = Invoke-WebRequest -Uri $OctopusURL/api/deployments -Method Post -Headers $Header -Body $DeploymentBody

Write-Host $d
