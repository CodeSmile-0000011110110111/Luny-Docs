# Scripting API

## LunyEngine

- @Luny
  - **[LunyEngine](xref:Luny.LunyEngine)** - Luny Engine singleton
  - **[LunyObject](xref:Luny.Engine.Bridge.LunyObject)** - Wrapper handling engine objects' lifecycle, preventing NullReferenceException
  - @Luny.Engine.Bridge - Engine-agnostic bridge/proxy types
  - @Luny.Engine.Services - Engine-agnostic feature services
  - Luny.Unity.* - Unity implementations of [Bridge types](xref:Luny.Unity.Bridge) and [Services](xref:Luny.Unity.Services)

## LunyScript

- @LunyScript
  - **[Script](xref:LunyScript.Script)** - Base class for custom Luny scripts
  - **[ScriptEngine](xref:LunyScript.ScriptEngine)** - LunyScript singleton
  - @LunyScript.Api - Script API implementations (Builders)
  - @LunyScript.Blocks - Executable Blocks 
  - LunyScript.Unity.* - Unity-specific [Blocks](xref:LunyScript.Unity.Blocks) (not portable) 
