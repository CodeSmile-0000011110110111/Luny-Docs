# Anatomy of a Luny Script 

LunyScript is designed to minimize C# syntax exposure while enabling you to leverage the full power of C# at your discretion.

## LunyScript and C#

When you write regular C# code, it gets compiled into 'CPU instructions' (oversimplified). C# has the full breadth and depth of any high-level programming language: full freedom but enormous complexity.

LunyScript puts guardrails on that infinite freedom (read: complexity) to accomplish:

- Self-contained, user extensible code blocks - write once, re-use for years to come.
- Runtime failures won't crash, get logged, use placeholders where possible. That pink cube? A 'missspeled' asset name.  
- Asset and object queries are cached/pooled. It runs more efficiently than typical beginner-level code.
- Execution is observable without a highly technical code debugger: Visualize script execution, not visual scripting.
- Problematic operations are detected or prevented, depriving users of the fun of dealing with common runtime behaviour issues.
- Best practices applied internally. Not the cargo cult repeated by tutorials for the past two decades.
- Encouraging experimentation, enabling code sharing - learn AND create, safely.

## How to create a Luny Script

A Luny script always inherits from `LunyScript.Script`:

```csharp
public partial class Player : LunyScript.Script
{
}
```

Observations:
- There are no `using` statements required - though you'll likely need a few eventually.
- The `partial` keyword will be required to support Roslyn code injection of custom API extensions.
- The above example won't compile: It's missing the implementation of the abstract `Build()` method.

This version of the script implements the required `Build()` method and will compile:
```csharp
public partial class Player : LunyScript.Script
{
    public override void Build(ScriptBuildContext context)
    {
        // This Build() method is called once for each object the script runs on.
    }
}
```

The [`ScriptBuildContext`](xref:LunyScript.ScriptBuildContext) has a two-fold use:
- It provides input data to the script, for instance Inspector-assigned values and references.
- It provides configurable options to influence how the script is interpreted and executed.

## When Does `Build()` Run?

It runs when an object associated with the script is created. This can happen when a scene loads or when instantiating a new object, typically by using a prefab but even primitives and empty objects can run Luny scripts. 

Currently, a Luny script will run `Build()` for objects whose name matches the script's class.

> [!NOTE]
> In the future there will options to directly assign a script, and to pattern match script names, or match layers and tags.

To reduce the cost of calling `Build()` in the middle of play, LunyScript implements a pooling strategy. Objects and their scripts are primarily intended to be re-used instead of re-created. To that end LunyScript will provide a lifecycle (and matching events) that makes pooling feel natural.

Typical Object lifecycle:

`Create -> [Spawn <=> Despawn] -> Destroy`

## What happens when `Build()` Runs?

`Build()` is a regular C# method that can run any C# code. You'll use it to write block-based code, such as these log statements that run every time the object gets enabled or disabled:

```csharp
public override void Build(ScriptBuildContext context)
{
    On.Enabled(Debug.Log("I'm back!"));
    
    On.Disabled(Debug.Log("I'll be back!"));
}
```

To see these logs, change the active checkbox of the object running the script during playmode. Or use an engine-native script to toggle its active state.

## Same Event, Multiple Blocks

In regular game engine code you can only have one event method per class or script, for example `Start()` or `_ready()`. 

This is not the case with LunyScript: You can have multiple events of the same type. Events will run their blocks in the same order they appear in the script. 

This example complements the dialog by duplicating the `On.Enabled` and `On.Disabled` event runners:

```csharp
public override void Build(ScriptBuildContext context)
{
    On.Enabled(Debug.Log("I'm back!"));
    On.Enabled(Debug.Log("I told you so!"));
    
    On.Disabled(Debug.Log("I'll be back!"));
    On.Disabled(Debug.Log("Nooooo.... (sinks into hotlava)"));
}
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

Use whichever version best suits your style and workflow, focus on readability and maintainability. The gain in performance and memory usage are marginal, and future optimizations may make both styles equal anyway.

## How Do Blocks Execute At Runtime?

That is an interesting question! 

Without going into too much detail, this is mostly handled by [LunyEngine](xref:Luny.LunyEngine) and [LunyObject](xref:Luny.Engine.Bridge.LunyObject). LunyEngine receives the usual engine lifecycle events (frame processing) and uses them to drive [engine observers](xref:Luny.ILunyEngineObserver) of which LunyScript is but one. This fixes any shortcomings an engine may have. For example, missing "Late Update" or "Application Quit" events.

For the object lifecycle events, like OnEnable/OnDestroy, all engine objects are wrapped in a LunyObject instance. This then raises the corresponding events. The benefit: it'll work exactly at the same way, in the same order, for every engine. It also "fixes" any shortcomings an engine may have. A missing "Object Destroyed" event for example, , or non-deterministic lifecycle event execution.
