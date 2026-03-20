# String Variables

String variables can be _added together_ (concatenated) and tested for equality/inequality.

## Adding Strings

Concatenating strings is the only allowed arithmetic operation on string variables.

```csharp
var str1 = Var.Define("str1", "A long, long time ago ...");
var str2 = Var.Define("str2", " in a galaxy far, far away.");

On.Ready(str1.Add(str2), Debug.Log(str1));
```

This will log:

> _A long, long time ago ... in a galaxy far, far away._

## Comparing Strings

String variables can also be tested for equality and inequality:

```csharp
var message = Var.Define("peace", "We come in peace!");

On.Ready(If(message != "We come in peace!")
        .Then(Debug.Log("You'll leave in pieces!"))
        .Else(Debug.Log("Welcome, friends!"))
);
```

## Other Operations: ERROR

> [!CAUTION]
> Other arithmetic operations and comparisons on string variables are not meaningful and will log an error.
