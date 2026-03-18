# Anatomy of a Luny Script 

LunyScript is designed to minimize C# syntax exposure while enabling you to leverage the full power of C# at your discretion.

## LunyScript and C#

When you write regular C# code, it gets compiled into 'CPU instructions' (oversimplified). C# has the full breadth and depth of any high-level programming language: full freedom but enormous complexity.

LunyScript puts guardrails on that infinite freedom to accomplish:

- Encouraging experimentation, enabling code sharing - learn AND create, the fun way.
- Self-contained, user extensible code blocks - write once, re-use for years to come.
- Runtime failures won't crash, get logged, use placeholders where possible. That pink cube? A 'missspeled' asset name.  
- Runs more efficiently than typical beginner-level code: Asset/Object queries are efficient and get cached/pooled.
- Observable execution without a technical code debugger: Visualize script execution, not scripting visually.
- Problematic operations are detected/prevented, depriving users the fun in dealing with widespread runtime quirks.
- Best practices applied internally: Not the cargo cult popularized by tutors decades ago.

## How to create a Luny Script

A Luny script always inherits from [`LunyScript.Script`](xref:LunyScript.Script):

```csharp
public partial class Player : LunyScript.Script
{
    public override void Build(ScriptBuildContext context)
    {
        // This Build() method is called once for each object the script runs on.
    }
}
```

Observations:
- There are no `using` statements required - though you'll likely need a few eventually.
- The `partial` keyword supports Roslyn code injection for custom API extensions that _feel native_.
- `Build()` is the only required method and the only method LunyScript will call.

The [`ScriptBuildContext`](xref:LunyScript.ScriptBuildContext) parameter of `Build()` has two uses:
- It provides input data to the script, e.g. Inspector-assigned values and references.
- It provides configurable options, e.g. to influence how the script is interpreted at runtime.

## When Does `Build()` Run?

It runs when an object associated with the script is created. This can happen when a scene loads or when instantiating a new object, typically by using a prefab. But even primitives or empty objects will run Luny scripts, thus enabling a code-centric workflow. 

Currently, a Luny script will run on any object whose name matches the script's class name.

> [!NOTE]
> In the future there will options to directly assign a script, and to pattern match script names, or match layers and tags.

To reduce the cost of calling `Build()` in the middle of play, LunyScript implements a pooling strategy. Objects and their scripts are primarily intended to be re-used instead of re-created. To that end LunyScript will provide a lifecycle (and matching events) that makes pooling feel natural.

Typical Object lifecycle:

`Create -> [Spawn <=> Despawn] -> Destroy`

## What happens when `Build()` Runs?

`Build()` is a regular C# method that runs any C# code. But primarily you'll use it to write block-based code, with the block builder APIs being provided by the `LunyScript.Script` base class and through custom extensions injected during compilation. 

A simple example uses [`Debug.Log`](xref:LunyScript.Api.DebugApi) blocks that run every time the object gets enabled or disabled:

```csharp
public override void Build(ScriptBuildContext context)
{
    On.Enabled(Debug.Log("I'm back!"));
    
    On.Disabled(Debug.Log("I'll be back!"));
}
```

To see these logs, change the active checkbox of the object running the script during playmode. Or use an engine-native script to toggle its active state.

> [!NOTE]
> The Debug.Log blocks are not to be confused with the [UnityEngine.Debug.Log method](xref:UnityEngine.Debug). This won't cause a conflict, since the LunyScript API takes precedence within `Script` classes.

## Same Event, Multiple Blocks

In regular game engine code you can only have one event method per class/script, for example one `Start()` or one `_ready()` method. 

In LunyScript, you can use multiple events of the same type in the same script! 
Events will run their blocks in the same order they appear in the script. 

This example complements the dialog by duplicating the `On.Enabled` and `On.Disabled` event runners:

```csharp
public override void Build(ScriptBuildContext context)
{
    On.Enabled(Debug.Log("I'm back!"));
    On.Enabled(Debug.Log("I told you so!"));
    
    On.Disabled(Debug.Log("I'll be back!"));
    On.Disabled(Debug.Log("Nooooo.... (sinks into lava)"));
}
```

This will reliably log messages in that order:

```
(object created/enabled)
> I'm back!
> I told you so!

(object disabled)
> I'll be back!
> Nooooo.... (sinks into lava)
```

## Multiple Blocks Everywhere

You aren't restricted to one block per event runner either. The alternative style is to provide multiple blocks within the same event runner as a comma-separated list:

```csharp
public override void Build(ScriptBuildContext context)
{
    On.Enabled(Debug.Log("I'm back!"), Debug.Log("I told you so!"));
    
    On.Disabled(Debug.Log("I'll be back!"), Debug.Log("Nooooo.... (sinks into lava)"));
}
```

Use whichever version best suits your style and workflow. Prefer readability and maintainability over other concerns! 

## How Do Blocks Execute At Runtime?

That is an interesting question! Without going into too much detail, this is mostly handled by [LunyEngine](xref:Luny.LunyEngine) and [LunyObject](xref:Luny.Engine.Bridge.LunyObject). 

LunyEngine receives the usual engine lifecycle events (frame processing) and uses them to drive [engine observers](xref:Luny.ILunyEngineObserver) of which LunyScript is but one. This fixes any shortcomings an engine may have. For example, absent lifecycle events like "Late Update" or "Application Quit".

For the object events, like OnEnable/OnDestroy, all engine objects are wrapped in a LunyObject instance. This then raises the corresponding events. It does not hook into or piggyback onto existing engine object/node/actor infrastructure to avoid the many, many lifecycle pitfalls this has. Instead, LunyEngine manages the lifetime of engine objects itself. That is how even a Godot Node will run the `On.Destroyed` event.

The benefit: LunyScript (and LunyEngine) work exactly the same in any engine. Even event execution order will be deterministic across engines.

In summary:
![LunyEngine_Engine_On_Engines.jpg](../images/LunyEngine_Engine_On_Engines.jpg)
