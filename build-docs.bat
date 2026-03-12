@echo off
xcopy "..\..\..\Library\ScriptAssemblies\Luny*" "..\..\..\Library\XmlDocs\" /Y /I /Q
REM del "..\..\..\Library\XmlDocs\*SmokeTests*" /Q
mkdir api > nul
xcopy api-index.md api\index.md /Y /-I /Q
docfx metadata docfx.json
docfx build docfx.json
