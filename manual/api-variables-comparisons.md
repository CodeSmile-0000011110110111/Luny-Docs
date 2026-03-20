# Variable Comparisons

Script variables can be compared with literal values and other variables.

## Variables Are Conditions

Variables and their comparison operators are naturally usable in conditions:

```csharp
var alive = Var.Define("Is Alive", true);
On.Ready(If(alive).Then(Debug.Log("I live, therefore I must!")));
```

## Operators Only

Comparisons can be performed entirely with operators `< <= == != >= > ! ++ --`.

## Where To Use Comparisons

Variables and their comparison operators can be used as conditions whereever a [`ConditionBlock`](xref:LunyScript.Blocks.ConditionBlock) is accepted. For example:

- `If(conditions).Then(actions)`
- `While(conditions).Do(actions)`
- `OR(conditions)`
- `AND(conditions)`
- `NOT(conditions)`
- ...

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

This is true because `compare`'s value is not equal to `other`'s value:

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

This example uses the `!` negation operator and will execute the `Else` branch because `truth` is true.

```csharp
var truth = Var.Define("a fact", true);

On.Ready(If(!truth)
        .Then(Debug.Log($"It's a fact. (True)"))
        .Else(Debug.Log($"It's an alternative fact!! (False)"))
);
```
