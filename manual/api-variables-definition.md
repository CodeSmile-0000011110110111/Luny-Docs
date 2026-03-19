# Variable Definition

A `LunyScript.Script` subclass provides the `Var` and `GVar` properties to access script variable storage.

## Global vs Local Variables

Both global and local variables are the same type and share the same functionality.

- `GVar` provides access to **global** variables. 
- `Var` contains **local** (object-bound / instance) variables.

The `Var` variables can have different values for the same variable name where a script runs on multiple objects.

`Var` variables can only be modified by its own script, thereby protecting them against accidental external changes.
This is comparable to the `protected` / `private` access modifiers in C#.

> [!TIP]
> Prefer to use `Var`. Use `GVar` only when you need to read/write same variable in multiple scripts/objects.
> This reduces the risk of accidentally defining identically named global variables for different uses.

## Define A Variable Value

Before use, a variable should be defined. Optionally, an initial value can be set. Otherwise variables default to the value 0.

```
var zero = Var.Define("variable with default value 0");
var number = Var.Define("integer variable", 123);
```

## Get Or Create A Variable

Index `Var` or `GVar` with a variable name to access the variable:

```
var theNumber = Var["integer variable"];
LunyLogger.LogInfo(theNumber.Value == Var["integer variable"].Value); // logs "true"
```

This will also work if the variable has not been defined. In this case the returned variable will have a default value of 0:

```
// will return a new variable with the value 0 
var newVar = Var["not defined"];
```

> [!TIP]
> Prefer to use `Define()`. Be explicit about the variable definition, particularly the variable's type (`number`, `boolean`, `string`) matters. Arithmetic operations or comparisons may behave unexpectedly when the types mismatch: `"hello" > 10` or `true * 0.5`. 🤔

## Define A Constant Value

Constants disallow changes at runtime, the value can only be set once via the `Constant()` method:

```
var lightspeed = Var.Constant("speed of light in vacuum (m/s)", 299792458);
```

Other than being read-only, constants and variables function identically.

> [!NOTE]
> Constant variables and modifiable variables are commonly subsumed under the term 'variable' in this documentation, even though "variable" suggests modifiability.

## Setting Variable Value Immediately

To set a variable during build time, use `SetImmediate()`: 

```
var newVar = Var["does not exist yet"];
newVar.SetImmediate(959.697);
newVar.Set(137.248); // returns a runnable block, won't change value until block runs!

LunyLogger.LogInfo(Var["does not exist yet"]); // logs "959.697"!
```

> [!IMPORTANT]
> Arithmetic functions returning a `ActionBlock` instance like `Set()` will need to execute at runtime for the value to change.
> The `SetImmediate()` method executes during `Build()` time (immediately) and cannot be used like a block.
