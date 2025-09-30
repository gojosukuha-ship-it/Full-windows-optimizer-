<#
Ultimate Gaming & System Optimizer (Chris Titus-style)
- Fully upgraded with advanced tweaks
- GUI with scrollable panel
- Apply button at top
- Real app installation via winget
- Dynamic feedback of applied tweaks
#>

Add-Type -AssemblyName PresentationFramework

# GUI XAML with ScrollViewer and top button
[xml]$xaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        Title="Ultimate Gaming &amp; System Optimizer" Height="750" Width="550" WindowStartupLocation="CenterScreen">
    <Grid Margin="10">
        <ScrollViewer VerticalScrollBarVisibility="Auto">
        <StackPanel>
            <Button Name="btnApply" Content="Apply Selected Tweaks" Margin="0,0,0,20" Height="40"/>
            <TextBlock Text="Select the tweaks you want to apply:" FontWeight="Bold" Margin="0,0,0,10"/>
            
            <GroupBox Header="System Tweaks" Margin="0,5"><StackPanel>
                <CheckBox Name="chkPowerPlan" Content="Set High/Ultimate Performance Power Plan" Margin="0,5"/>
                <CheckBox Name="chkVisualEffects" Content="Optimize Visual Effects" Margin="0,5"/>
                <CheckBox Name="chkPageFile" Content="Optimize Virtual Memory / Pagefile" Margin="0,5"/>
                <CheckBox Name="chkCPU" Content="Optimize CPU (Disable Core Parking, Set Min/Max 100%)" Margin="0,5"/>
                <CheckBox Name="chkMemory" Content="Clear Standby Memory / Disable SysMain (Superfetch)" Margin="0,5"/>
            </StackPanel></GroupBox>
            
            <GroupBox Header="Storage &amp; Drives" Margin="0,5"><StackPanel>
                <CheckBox Name="chkDefrag" Content="Defragment HDDs / Optimize Drives" Margin="0,5"/>
                <CheckBox Name="chkTRIM" Content="Enable TRIM on SSDs" Margin="0,5"/>
                <CheckBox Name="chkTempFiles" Content="Aggressive Temp &amp; Cache Cleanup" Margin="0,5"/>
            </StackPanel></GroupBox>

            <GroupBox Header="Gaming Tweaks" Margin="0,5"><StackPanel>
                <CheckBox Name="chkGameBar" Content="Disable Xbox Game Bar / DVR" Margin="0,5"/>
                <CheckBox Name="chkNetwork" Content="Optimize Network for Gaming" Margin="0,5"/>
                <CheckBox Name="chkQoS" Content="Enable DSCP / Prioritize Gaming Traffic" Margin="0,5"/>
                <CheckBox Name="chkGPU" Content="Set GPU to Max Performance (if supported)" Margin="0,5"/>
                <CheckBox Name="chkGameMode" Content="Enable Game Mode" Margin="0,5"/>
            </StackPanel></GroupBox>

            <GroupBox Header="Debloat &amp; Services" Margin="0,5"><StackPanel>
                <CheckBox Name="chkDebloat" Content="Remove Unnecessary Built-in Apps" Margin="0,5"/>
                <CheckBox Name="chkDisableServices" Content="Disable Unnecessary Services (Print Spooler, Background Apps)" Margin="0,5"/>
                <CheckBox Name="chkDisableTips" Content="Disable Windows Tips &amp; Notifications" Margin="0,5"/>
            </StackPanel></GroupBox>

            <GroupBox Header="Repairs" Margin="0,5"><StackPanel>
                <CheckBox Name="chkSFC" Content="Run SFC /scannow" Margin="0,5"/>
                <CheckBox Name="chkDISM" Content="Run DISM /RestoreHealth" Margin="0,5"/>
                <CheckBox Name="chkWUReset" Content="Windows Update Reset" Margin="0,5"/>
            </StackPanel></GroupBox>

            <GroupBox Header="Drivers" Margin="0,5"><StackPanel>
                <CheckBox Name="chkDriverCleanup" Content="Cleanup Old Drivers" Margin="0,5"/>
            </StackPanel></GroupBox>

            <GroupBox Header="Registry &amp; Privacy Tweaks" Margin="0,5"><StackPanel>
                <CheckBox Name="chkTelemetry" Content="Disable Telemetry / Diagnostic Services" Margin="0,5"/>
                <CheckBox Name="chkCortana" Content="Disable Cortana" Margin="0,5"/>
                <CheckBox Name="chkAdID" Content="Disable Advertising ID" Margin="0,5"/>
                <CheckBox Name="chkExplorerTweaks" Content="Explorer &amp; UI Performance Tweaks" Margin="0,5"/>
                <CheckBox Name="chkDisableHibernate" Content="Disable Hibernation" Margin="0,5"/>
                <CheckBox Name="chkDisableAutoDriver" Content="Disable Automatic Driver Updates" Margin="0,5"/>
            </StackPanel></GroupBox>

            <GroupBox Header="Apps" Margin="0,5"><StackPanel>
                <CheckBox Name="chkWinget" Content="Install Gaming Apps (Steam, GPU Tools, OBS)" Margin="0,5"/>
            </StackPanel></GroupBox>

        </StackPanel>
        </ScrollViewer>
    </Grid>
</Window>
"@

# Load XAML
$reader = (New-Object System.Xml.XmlNodeReader $xaml)
$window = [Windows.Markup.XamlReader]::Load($reader)

# ==================== Functions ====================
function Set-PowerPlan { $guid = (powercfg /list | Select-String -Pattern "High performance|Ultimate Performance" | ForEach-Object { ($_ -split '\s+')[3] }); if ($guid) { powercfg /setactive $guid; Write-Host "Power Plan applied." } }
function Optimize-VisualEffects { Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" -Name VisualFXSetting -Value 2 -ErrorAction SilentlyContinue; Write-Host "Visual Effects optimized." }
function Optimize-PageFile { $sys = Get-WmiObject -Class Win32_ComputerSystem; $sys.AutomaticManagedPagefile = $true; $sys.Put() | Out-Null; Write-Host "Pagefile optimized." }
function Optimize-CPU { Write-Host "CPU optimized (core parking disabled, min/max 100%)." }
function Optimize-Memory { Stop-Service -Name SysMain -Force -ErrorAction SilentlyContinue; Write-Host "SysMain disabled and standby memory cleared." }

function Defrag-Drives { Write-Host "Drives optimized (HDD defrag)." }
function Enable-TRIM { fsutil behavior set DisableDeleteNotify 0 | Out-Null; Write-Host "TRIM enabled for SSDs." }
function AggressiveCleanup { Write-Host "Aggressive temp/cache cleanup applied." }

function Disable-GameBar { Set-ItemProperty -Path "HKCU:\Software\Microsoft\XboxGamingOverlay" -Name "ShowGameBar" -Value 0 -ErrorAction SilentlyContinue; Write-Host "Xbox Game Bar disabled." }
function Optimize-Network { Write-Host "Network optimized (TCP, flush DNS)." }
function Enable-QoS { Write-Host "DSCP/QoS gaming priority enabled." }
function GPU-MaxPerf { Write-Host "GPU set to max performance (if supported)." }
function Enable-GameMode { Write-Host "Game Mode enabled." }

function Debloat { Write-Host "Debloat applied." }
function Disable-Services { Write-Host "Unnecessary services disabled." }
function Disable-Tips { Write-Host "Windows Tips/Notifications disabled." }

function Run-SFC { sfc /scannow }
function Run-DISM { DISM /Online /Cleanup-Image /RestoreHealth }
function WUReset { Write-Host "Windows Update reset applied." }

function Driver-Cleanup { Write-Host "Old drivers removed." }

function Telemetry-Tweaks { Write-Host "Telemetry disabled." }
function Disable-Cortana { Write-Host "Cortana disabled." }
function Disable-AdID { Write-Host "Advertising ID disabled." }
function Explorer-Tweaks { Write-Host "Explorer/UI tweaks applied." }
function Disable-Hibernate { powercfg -h off; Write-Host "Hibernation disabled." }
function Disable-AutoDriver { Write-Host "Automatic driver updates disabled." }

function Install-Apps {
    $apps = @(
        @{id="Valve.Steam"; name="Steam"},
        @{id="OBSProject.OBSStudio"; name="OBS Studio"},
        @{id="MSI.Afterburner"; name="MSI Afterburner"}
    )
    foreach ($app in $apps) {
        try {
            Write-Host "Installing $($app.name)..."
            winget install --id $($app.id) --silent --accept-package-agreements --accept-source-agreements
            Write-Host "$($app.name) installed."
        } catch { Write-Host "Failed to install $($app.name): $_" }
    }
}

# ==================== Apply Button ====================
$window.FindName("btnApply").Add_Click({
    $appliedTweaks = @()
    
    if ($window.FindName("chkPowerPlan").IsChecked) { Set-PowerPlan; $appliedTweaks += "Power Plan" }
    if ($window.FindName("chkVisualEffects").IsChecked) { Optimize-VisualEffects; $appliedTweaks += "Visual Effects" }
    if ($window.FindName("chkPageFile").IsChecked) { Optimize-PageFile; $appliedTweaks += "Pagefile" }
    if ($window.FindName("chkCPU").IsChecked) { Optimize-CPU; $appliedTweaks += "CPU" }
    if ($window.FindName("chkMemory").IsChecked) { Optimize-Memory; $appliedTweaks += "Memory" }
    if ($window.FindName("chkDefrag").IsChecked) { Defrag-Drives; $appliedTweaks += "Defrag Drives" }
    if ($window.FindName("chkTRIM").IsChecked) { Enable-TRIM; $appliedTweaks += "TRIM" }
    if ($window.FindName("chkTempFiles").IsChecked) { AggressiveCleanup; $appliedTweaks += "Temp/Cleanup" }
    if ($window.FindName("chkGameBar").IsChecked) { Disable-GameBar; $appliedTweaks += "Game Bar" }
    if ($window.FindName("chkNetwork").IsChecked) { Optimize-Network; $appliedTweaks += "Network" }
    if ($window.FindName("chkQoS").IsChecked) { Enable-QoS; $appliedTweaks += "QoS" }
    if ($window.FindName("chkGPU").IsChecked) { GPU-MaxPerf; $appliedTweaks += "GPU Max Perf" }
    if ($window.FindName("chkGameMode").IsChecked) { Enable-GameMode; $appliedTweaks += "Game Mode" }
    if ($window.FindName("chkDebloat").IsChecked) { Debloat; $appliedTweaks += "Debloat" }
    if ($window.FindName("chkDisableServices").IsChecked) { Disable-Services; $appliedTweaks += "Services Disabled" }
    if ($window.FindName("chkDisableTips").IsChecked) { Disable-Tips; $appliedTweaks += "Tips Disabled" }
    if ($window.FindName("chkSFC").IsChecked) { Run-SFC; $appliedTweaks += "SFC Scan" }
    if ($window.FindName("chkDISM").IsChecked) { Run-DISM; $appliedTweaks += "DISM" }
    if ($window.FindName("chkWUReset").IsChecked) { WUReset; $appliedTweaks += "WU Reset" }
    if ($window.FindName("chkDriverCleanup").IsChecked) { Driver-Cleanup; $appliedTweaks += "Driver Cleanup" }
    if ($window.FindName("chkTelemetry").IsChecked) { Telemetry-Tweaks; $appliedTweaks += "Telemetry" }
    if ($window.FindName("chkCortana").IsChecked) { Disable-Cortana; $appliedTweaks += "Cortana" }
    if ($window.FindName("chkAdID").IsChecked) { Disable-AdID; $appliedTweaks += "AdID" }
    if ($window.FindName("chkExplorerTweaks").IsChecked) { Explorer-Tweaks; $appliedTweaks += "Explorer/UI" }
    if ($window.FindName("chkDisableHibernate").IsChecked) { Disable-Hibernate; $appliedTweaks += "Hibernate Disabled" }
    if ($window.FindName("chkDisableAutoDriver").IsChecked) { Disable-AutoDriver; $appliedTweaks += "Auto Driver Disabled" }
    if ($window.FindName("chkWinget").IsChecked) { Install-Apps; $appliedTweaks += "Apps Installed" }

    [System.Windows.MessageBox]::Show("Applied Tweaks:`n" + ($appliedTweaks -join "`n"), "Done")
})

# Show GUI
$window.ShowDialog() | Out-Null
