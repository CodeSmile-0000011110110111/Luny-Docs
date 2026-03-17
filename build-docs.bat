@echo off

mkdir api > nul
xcopy api-index.md api\index.md /Y /-I /Q

docfx build docfx.json --maxParallelism 0
