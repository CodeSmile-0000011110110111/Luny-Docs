xcopy "..\..\..\Library\ScriptAssemblies\Luny*" "..\..\..\Library\XmlDocs\" /Y /I
xcopy api-index.md api\index.md /Y /-I
docfx metadata docfx.json
docfx build docfx.json
