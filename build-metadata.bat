@echo off

REM Tip Unity to recompile, if necessary ..
echo > ..\..\..\.request-refresh
echo Waiting for Unity to compile...
:wait
timeout /t 1 /nobreak >nul
if exist ..\..\..\.request-refresh goto wait
if exist ..\..\..\.refresh-in-progress goto wait

echo Unity: Refresh() finished

dotnet build "..\..\..\LunyScript_Examples_Unity.sln"

xcopy "..\..\..\Library\ScriptAssemblies\*" "..\..\..\Library\XmlDocs\" /Y /I /Q
xcopy "C:\Program Files\Unity\Hub\Editor\6000.3.11f1\Editor\Data\netcorerun\*" "..\..\..\Library\XmlDocs\" /Y /I /Q /D
REM del "..\..\..\Library\XmlDocs\*SmokeTests*" /Q

docfx metadata docfx.json
