@echo off
REM We mount in /workspace because there is not a direct way to convert a Windows path to a WSL (wslpath don't work without a distro)

if [%XSERVER_IP%] equ [""] set XSERVER_IP=
if [%XSERVER_IP%] equ [] (
for /f "tokens=3 delims=: " %%i  in ('netsh interface ip show config name^="vEthernet (WSL)" ^| findstr /R /C:"^ *IP[v4]* Address"') do set XSERVER_IP=%%i
)

if [%ISE14_IMAGE%] equ [""] set ISE14_IMAGE=
if [%ISE14_IMAGE%] equ [] set ISE14_IMAGE="ise:14.7"

if [%XILINX_LICENSE%] equ [""] set XILINX_LICENSE=
if [%XILINX_LICENSE%] equ [] set XILINX_LICENSE="/opt/Xilinx/Xilinx.lic"

if [%LICENSE_MAC%] equ [""] set LICENSE_MAC=
if [%LICENSE_MAC%] equ [] set LICENSE_MAC="08:00:27:68:c9:35"

echo XSERVER_IP: %XSERVER_IP%  
echo ISE14_IMAGE: %ISE14_IMAGE%
echo WORKPLACE: %CD%
echo LICENSE_MAC: %LICENSE_MAC%

set DISPLAY=%XSERVER_IP%:0.0

docker run --rm ^
--mac-address %LICENSE_MAC% ^
-e DISPLAY=%DISPLAY% ^
-e PATH=/bin:/sbin:/opt/Xilinx/14.7/ISE_DS/ISE/bin/lin64 ^
-e LD_LIBRARY_PATH=/opt/Xilinx/14.7/ISE_DS/ISE/lib/lin64:/opt/Xilinx/14.7/ISE_DS/common/lib/lin64 ^
-e XILINXD_LICENSE_FILE=%XILINX_LICENSE% ^
-v "%CD%:/workspace" ^
-w /workspace ^
-ti %ISE14_IMAGE% %*
