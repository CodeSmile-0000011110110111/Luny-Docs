# Anatomy of a Luny Script 

LunyScript is designed to minimize C# syntax exposure while enabling you to leverage the language's full power.

## LunyScript and C#

When you write regular C# code, this code is compiled into 'CPU instructions'. C# has the full breadth and depth of any high-level programming language: full freedom but enormous complexity.

LunyScript adds guardrails to programming with C#:

- Self-contained, battle-tested, user extensible code blocks - write once, re-use for years to come.
- Runtime failures don't crash, they are logged and use placeholders where possible. That pink cube? A 'missspeled' asset name.  
- Expensive operations are optimized, references are cached/pooled. It runs more efficiently than typical beginner-level code.
- Execution is observable without a highly technical code debugger: Visualize code execution, not crafting code visually.
- Invalid or incompatible operations are detected early, avoiding subtle runtime behaviour issues.
- Best practices applied internally to prevent common issues plaguing those without deep field expertise.

## How to create a Luny Script

A Luny script is a C# class which inherits from `LunyScript.Script`:

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
- It provides input to the script, for instance Inspector-assigned values and references.
- It provides configurable options to influence how the script is interpreted and executed.

## When Does Build() Run?

It runs when an object associated with the script is created. This can happen when a scene loads or when instantiating a new object, typically by using a prefab but even primitives and empty objects can run Luny scripts. 

Currently, a Luny script will Build() for objects whose name matches the script's class.

> [!NOTE]
> In the future there will options to directly assign a script, and to pattern match scripts with names, layers, or tags.

To reduce the cost of calling Build() in the middle of play, LunyScript implements a pooling strategy. Objects and their scripts are primarily intended to be re-used instead of re-created. To that end LunyScript will provide a lifecycle (and matching events) that makes pooling feel natural: `Create -> [Spawn <=> Despawn] -> Destroy`.

## What happens when Build() Runs?

Build() is a regular C# method that can run any C# code. 

Primarily you'll be writing block-based code, such as these log statements that run when the object gets enabled and disabled:

```csharp
public override void Build(ScriptBuildContext context)
{
    On.Enabled(Debug.Log("I'm back!"));
    
    On.Disabled(Debug.Log("I'll be back!"));
}
```

To see these logs, change the active checkbox of the object in the Hierarchy during playmode.

## Same Event, Multiple Blocks

Contrary to what you might expect, these events are not once-only. You can register multiple sequences of blocks on the same type of event. These will run in the same order they appear in the script. This example complements the dialog:

```csharp
public override void Build(ScriptBuildContext context)
{
    On.Enabled(Debug.Log("I'm back!"));
    On.Enabled(Debug.Log("I told you so!"));
    
    On.Disabled(Debug.Log("I'll be back!"));
    On.Disabled(Debug.Log("Nooooo.... (sinks into hotlava)"));
}
```

Of course you aren't restricted to one block per event. The alternative way of writing the above is to provide multiple blocks for the same event as a comma-separated list (like method parameters):

```csharp
public override void Build(ScriptBuildContext context)
{
    On.Enabled(Debug.Log("I'm back!"), Debug.Log("I told you so!"));
    
    On.Disabled(Debug.Log("I'll be back!"), Debug.Log("Nooooo.... (sinks into lava)"));
}
```

Use whichever version best suits your style and workflow.

## Advanced Uses

Since we are using regular C#, you can also bundle blocks into method calls which provides you with re-usable block sequences and a clean, readable `Build()` method:

```csharp
public override void Build(ScriptBuildContext context)
{
    On.Enabled(EnableMessages());
    
    On.Disabled(DisableMessages());
}

private ActionBlock[] EnableMessages() => new[]
{
    Debug.Log("I'm back!"),
    Debug.Log("I told you so!"),
};
private ActionBlock[] DisableMessages() => new[]
{
    Debug.Log("I'll be back!"), 
    Debug.Log("Nooooo.... (sinks into lava)"),
};
```

## How Do Blocks Execute At Runtime?





- block based builder pattern
- load-time build vs runtime execution
- utilizing c#
  - methods
  - loops
  - 
