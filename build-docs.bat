xcopy "..\..\..\Library\ScriptAssemblies\Luny*" "..\..\..\Library\XmlDocs\" /Y /I
del "..\..\..\Library\XmlDocs\*SmokeTests*"
xcopy api-index.md api\index.md /Y /-I
docfx metadata docfx.json
docfx build docfx.json
