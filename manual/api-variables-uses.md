# Using Variables

Variables and literals can be used interchangeably, with few exceptions (which may be possible oversights). 

## Variables As Block Parameters

Variables can be passed as parameters to any block that expects either a number, boolean or string type.
This hinges only on whether the variable converts to the type, eg passing a string variable to a number parameter will fail.

This will scale the object by a factor of 2x:
```
public override void Build(ScriptBuildContext context)
{
    var scale = Var.Define("scale", 2);
    On.Ready(Transform.SetLocalScale(scale));
}
```

## Parameter Variables Reflect Runtime Changes

Variables as block parameters make most sense when their value actually changes at runtime.

Let's use a variable to scale the object bigger over time:

```
public override void Build(ScriptBuildContext context)
{
    var scale = Var.Define("scale", 0.01);
    On.FrameUpdate(Transform.SetLocalScale(scale), scale.Add(0.01));
}
```

This object grows bigger and bigger during playmode.
