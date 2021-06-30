# We mount in /workspace because there is not a direct way to convert a Windows path to a WSL (wslpath don't work without a distro)

$ISE14_IMAGE = if ($env:ISE14_IMAGE) {$env:ISE14_IMAGE} else {"ise:14.7"}
$LICENSE_MAC = if ($env:LICENSE_MAC) {$env:LICENSE_MAC} else {"08:00:27:68:c9:35"}
$XILINXD_LICENSE_FILE = if ($env:XILINXD_LICENSE_FILE) {$env:XILINXD_LICENSE_FILE} else {"/opt/Xilinx/Xilinx.lic"}

$local=(Get-Location).Path

$alias="vEthernet (WSL)"
$XSERVER_IP = if ($env:XSERVER_IP) `
  {$env:XSERVER_IP} else `
  {(Get-NetIPAddress -AddressFamily IPV4 -InterfaceAlias $alias).IPAddress}

Write-Host "XSERVER_IP: $XSERVER_IP"
Write-Host "ISE14_IMAGE: $ISE14_IMAGE"
Write-Host "WORKPLACE: $local"

#$args[0] = ("/opt/Xilinx/14.7/ISE_DS/ISE/bin/lin64/{0}" -f $args[0])

& "docker" @("run", "--rm", `
"--mac-address", "08:00:27:68:c9:35", `
"-e", ("DISPLAY={0}:0.0" -f $XSERVER_IP), `
"-e", "PATH=/bin:/sbin:/opt/Xilinx/14.7/ISE_DS/ISE/bin/lin64", `
"-e", "LD_LIBRARY_PATH=/opt/Xilinx/14.7/ISE_DS/ISE/lib/lin64:/opt/Xilinx/14.7/ISE_DS/common/lib/lin64", `
"-e", "XILINXD_LICENSE_FILE=/opt/Xilinx/Xilinx.lic", `
"-v", ("{0}:/workspace" -f $local), `
"-w", "/workspace", `
"-ti", $ISE14_IMAGE + $args)
