@echo off
dotnet build "..\..\..\LunyScript_Examples_Unity.sln"

xcopy "..\..\..\Library\ScriptAssemblies\*" "..\..\..\Library\XmlDocs\" /Y /I /Q
xcopy "C:\Program Files\Unity\Hub\Editor\6000.3.11f1\Editor\Data\netcorerun\*" "..\..\..\Library\XmlDocs\" /Y /I /Q /D
REM del "..\..\..\Library\XmlDocs\*SmokeTests*" /Q

mkdir api > nul
xcopy api-index.md api\index.md /Y /-I /Q

docfx metadata docfx.json
docfx build docfx.json --maxParallelism 0
