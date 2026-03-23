# Using Variables

Script variables and literals can be used interchangeably, with few exceptions. 

## Variables As Block Parameters

Variables can be passed as parameters to any block that expects either a number, boolean or string type.

This will scale the object by a factor of 2x:

```csharp
public override void Build(ScriptBuildContext context)
{
    var scale = Var.Define("scale", 2);
    On.Ready(Transform.SetLocalScale(scale));
}
```

> [!WARNING]
> Type conversion still matters. For instance, passing a string variable to a number parameter will be an error, 
> as will be performing arithmetics (Add, Sub, Div, Mul) on a variable type that isn't a number.

## Parameter Variables Reflect Runtime Changes

Variables as block parameters make most sense when their value actually changes at runtime.

Let's use a variable to scale the object bigger over time:

```csharp
public override void Build(ScriptBuildContext context)
{
    var scale = Var.Define("scale", 0.1);
    On.FrameUpdate(Transform.SetLocalScale(scale), scale.Add(0.005));
}
```

This object grows bigger and bigger at runtime.
