# Variable Comparisons

Script variables can also be compared with literal values and other variables.

## Operators Only

Comparisons can be performed entirely with operators `< <= == != >= >`. There are no separate comparison methods.

## Where To Use Comparisons

A comparison creates a [`ConditionBlock`](xref:LunyScript.Blocks.ConditionBlock) which evaluates to either `true` or `false`.
Blocks that execute (make changes) are [`ActionBlock`](xref:LunyScript.Blocks.ActionBlock) types.

Block methods may accept one or the other. The most common blocks accepting a `ConditionBlock` are:

- `If(conditions).Then(actions)`
- `While(conditions).Do(actions)`
- Logical operators: `OR(conditions)`, `AND(conditions)`, `NOT(conditions)`

## Numerical Literal Comparison

This is true because `compare`'s value is `>= 0.1`:
```csharp
var compare = Var.Define("compare", 0.123456789);

On.Ready(If(compare >= 0.1)
        .Then(Debug.Log($"{compare.Value} is >= 0.1"))
        .Else(Debug.Log($"{compare.Value} is < 0.1"))
);
```

## Numerical Variable Comparison

This is true because `compare` is not equal to `other`:

```csharp
var compare = Var.Define("compare", 0.123456789);
var other = Var.Define("other", 0.1);

On.Ready(If(compare != other)
        .Then(Debug.Log($"{compare.Value} is != {other.Value}"))
        .Else(Debug.Log($"{compare.Value} is == {other.Value}"))
);
```

## Numerical Truth

This is true because `compare` is a non-zero value:

```csharp
var compare = Var.Define("compare", 0.001);

On.Ready(If(compare)
        .Then(Debug.Log($"{compare.Value} is true."))
        .Else(Debug.Log($"{compare.Value} is false.")),
);
```

## Boolean Comparison

This is true because `truth` is not false.

```csharp
var truth = Var.Define("another fact", true);

On.Ready(If(!truth)
        .Then(Debug.Log($"It's a fact. ({truth.Value})"))
        .Else(Debug.Log($"It's an alternative fact!! ({truth.Value})"))
);
```

> [!NOTE]
> This example uses the `!` negation operator and will therefore execute the `Else` branch.
