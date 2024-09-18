# Stop Docker Desktop service if it's running
$serviceName = "com.docker.service"
$service = Get-Service -Name $serviceName -ErrorAction SilentlyContinue

if ($service -and $service.Status -eq 'Running') {
    Stop-Service -Name $serviceName -Force
    Write-Output "Stopped Docker Desktop service."
}

# Define the path to the Docker Desktop installer
$installerPath = "C:\Program Files\Docker\Docker\Docker Desktop Installer.exe"

# Check if the installer exists
if (Test-Path $installerPath) {
    # Uninstall Docker Desktop
    Start-Process -FilePath $installerPath -ArgumentList "uninstall" -Wait
    Write-Output "Docker Desktop has been uninstalled."

    # Remove residual files and directories
    $pathsToRemove = @(
        "C:\ProgramData\Docker",
        "C:\ProgramData\DockerDesktop",
        "C:\Program Files\Docker",
        "$env:USERPROFILE\AppData\Local\Docker",
        "$env:USERPROFILE\AppData\Roaming\Docker",
        "$env:USERPROFILE\AppData\Roaming\Docker Desktop",
        "$env:USERPROFILE\.docker"
    )

    foreach ($path in $pathsToRemove) {
        if (Test-Path $path) {
            Remove-Item -Path $path -Recurse -Force
            Write-Output "Removed $path"
        }
    }

    Write-Output "All Docker Desktop files have been removed."
} else {
    Write-Output "Docker Desktop Installer not found at $installerPath"
}
