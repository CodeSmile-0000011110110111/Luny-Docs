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

## Define A Script Variable 

Before use, a variable should be defined. Optionally, an initial value can be set. Otherwise variables default to the value 0.

```csharp
var zero = Var.Define("variable with default value 0");
var integer = Var.Define("integer variable", 123);
```

The type of a variable is defined by its initial value:

```csharp
var number = Var.Define("integer variable", 123.456);
var boolean = Var.Define("integer variable", true);
var text = Var.Define("integer variable", "Hello, Goodbye");
```

> [!TIP]
> Script variables support duck typing: A variable's type changes based on what you assign to it.

The [`Luny.Variable`](xref:Luny.Variable) type supports these types:

- `System.String`
- [`Luny.Number`](xref:Luny.Number)
 
The [`Luny.Number`](xref:Luny.Number) type uses a `System.Double` as its internal representation, modeled after Lua's established `number` type. It implicitly converts to/from all integer and floating point types. This avoids compiler warnings/errors (eg "loss of data") which are largely irrelevant in game scripting.

> [!NOTE]
> A generic [`Luny.Variable<T>`](xref:Luny.Variable`1) type also exists to support any type (eg [`Luny.LunyVector3`](xref:Luny.Engine.Bridge.LunyVector3)). It is planned to be integrated in LunyScript.

## Access A Script Variable

Index `Var` or `GVar` with a variable name to access the variable:

```csharp
var theNumber = Var["integer variable"];
LunyLogger.LogInfo(theNumber.Value == Var["integer variable"].Value); // logs "true"
```

This will also work if the variable has not been defined. In this case the returned variable will have a default value of 0:

```csharp
// will return a new variable with the value 0 
var newVar = Var["not defined"];
```

> [!TIP]
> Prefer to use `Define()`. Be explicit about the variable definition, particularly the variable's type (`number`, `boolean`, `string`) matters. Arithmetic operations or comparisons may behave unexpectedly when the types mismatch: `"hello" > 10` or `true * 0.5`. 🤔

## Define A Constant Value

Constants disallow changes at runtime, the value can only be set once via the `Constant()` method:

```csharp
var lightspeed = Var.Constant("speed of light in vacuum (m/s)", 299792458);
```

Other than being read-only, constants and variables function identically.

> [!NOTE]
> Constant variables and modifiable variables are commonly subsumed under the term 'variable' in this documentation, even though "variable" suggests modifiability.

## Setting Variable Value Immediately

To set a variable during build time, use `SetImmediate()`: 

```csharp
var newVar = Var["does not exist yet"];
newVar.SetImmediate(959.697);
newVar.Set(137.248); // returns a runnable block, won't change value until block runs!

LunyLogger.LogInfo(Var["does not exist yet"]); // logs "959.697"!
```

> [!IMPORTANT]
> Arithmetic functions returning a `ActionBlock` instance like `Set()` will need to execute at runtime for the value to change.
> The `SetImmediate()` method executes during `Build()` time (immediately) and cannot be used like a block.
