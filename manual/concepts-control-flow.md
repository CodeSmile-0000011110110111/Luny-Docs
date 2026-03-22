# Control Flow

LunyScript has two types of blocks:
- [`ActionBlock`](xref:LunyScript.Blocks.ActionBlock) types execute/run something, typically changing state.
- [`ConditionBlock`](xref:LunyScript.Blocks.ConditionBlock) types evaluate a logical expression for being either `true` or `false`.

We use them together to create logic via control flow blocks.

## If().Then()

The simplemost control flow statement is the `If().Then()` pattern: 

```csharp
On.Ready(
    If(Object.IsVisible())
        .Then(Debug.Log("potentially visible"))
);
```

## If().Then().ElseIf().Then()

Of course you can have multiple branches with `ElseIf().Then()`:

```csharp
On.Heartbeat(
    If(Rigidbody.Speed() < 10)
        .Then(Debug.Log("going slow"))
    .ElseIf(Rigidbody.Speed() < 20)
        .Then(Debug.Log("running"))
    .ElseIf(Rigidbody.Speed() < 30)
        .Then(Debug.Log("running fast"))
);
```

## If().Then().ElseIf().Then().Else()

You can have a final `Else()` block which runs when no other branch is true:

```csharp
On.Heartbeat(
    If(Rigidbody.Speed() < 10)
        .Then(Debug.Log("going slow"))
    .ElseIf(Rigidbody.Speed() < 20)
        .Then(Debug.Log("running"))
    .ElseIf(Rigidbody.Speed() < 30)
        .Then(Debug.Log("running fast"))
    .Else(Debug.Log("going really fast"))
);
```

## While().Do()

You can execute blocks for as long as conditions are true with the `While().Do()` pattern:

```csharp
On.Heartbeat(
    While(Rigidbody.Speed() < 10)
        .Do(Rigidbody.AddForce(LunyVector3.one))
);
```
> [!WARNING]
> It is trivial to create infinite loops with `While()`. Internally it is safeguarded against potential infinite loops, 
> but the editor/build may remain frozen for several seconds. If it happens to you, give it some time. 
> Unlike C# infinite loops it will unfreeze eventually. Note: The safeguard is inactive in RELEASE builds.

## For().Do()

The `For().Do()` loop should also seem familiar, except it's simplified to a single numeric value:

```csharp
On.Ready(
    For(10)
        .Do(Debug.Log("for loop iterating"))
);
```

This will log ten times. Note that internally this counts from 1 to 10, just like Lua.

If you need a custom step other than `+1` you can specify the step as the second parameter:

```csharp
On.Ready(
    For(10, 2)
        .Do(Debug.Log("for loop iterating"))
);
```

This will log five times because the increment step is 2 (default: 1).

## For().Do() Backwards

Sometimes, you need to iterate backwards. You can do this by passing a negative step value:

```csharp
On.Ready(
    For(10, -1)
        .Do(Debug.Log("for loop iterating"))
);
```

This will log ten times but will decrement from 10 to 1.

> [!TIP]
> The loop counter value is useful to use in the actions the `For()` loop runs. It will be exposed in the future.
> In the meantime you can manually `Inc()` or `Dec()` a variable in the `Do()` block.

## Loop With Variables

What good are loop expressions without variables? Of course you can use variables in `For()` and `While()` loops:

```csharp
var enemyCount = Var.Define("enemyCount", 3);
var createEnemy = Object.Create("enemy").With("Assets/Prefabs/Enemy");

On.Enabled(
    For(enemyCount).Do(createEnemy),
    enemyCount.Add(3)
);
```

This will create three enemies the first time the object gets enabled. The next time it will create six, then nine, and so forth.

## Logical Operators

The default combination of multiple conditions is an implicit `AND` where all conditions must be true for the check to pass:

```csharp
On.Ready(
    If(c1, c2, c3) // all three must be true
        .Then(Debug.Log("check passed"))
);
```

But sometimes you may need to use other logical expressions ...

The C# expression `c1 && (c2 || c3)` is in plain english `c1 AND (c2 OR c3)`. Its block equivalent is:

```csharp
If(c1, OR(c2, c3)).Then(..)
```

The C# expression `c1 || (c2 && c3)` is in plain english `c1 OR (c2 AND c3)`. Its block equivalent is:

```csharp
If(OR(c1, AND(c2, c3))).Then(..)
```

The C# expression `!(c1 || (c2 && c3))` is in plain english `NOT (c1 OR (c2 AND c3))`. Its block equivalent is:

```csharp
If(NOT(OR(c1, AND(c2, c3)))).Then(..)
```

As usual, you can pull out those checks into C# variables to keep your blocks readable, and maintainable:

```csharp
var check = NOT(OR(c1, AND(c2, c3)));

On.Ready(If(check).Then(Debug.Log("check passed")));
```

> [!WARNING]
> Every logical operator, every additional condition increases [cognitive load](https://en.wikipedia.org/wiki/Cognitive_load)! 
> One condition is trivial. Two conditions easy. Three conditions take a moment.
> Add NOT, OR, AND in between and repeat the conditions several times, with variations? 😵‍💫🫨🤯
> 
> It's easy to create unmanageable messes with complex logical expressions!
> #1 Rule of Programming: [KEEP IT SIMPLE, STUPID!](https://en.wikipedia.org/wiki/KISS_principle) 😊


> [!NOTE]
> Other logical operators will be added later. I know some of you would love to do intricate logic puzzles.
> That's when you might need to `XNOR` the `NAND` out of conditions. 🤓
