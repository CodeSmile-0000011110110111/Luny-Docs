# Variable Arithmetics

Script variables representing numbers can perform arithmetic operations like Add, Subtract, Multiply, Divide.

## Using Operator Methods

Each variable has a set of operator methods where the variable is the 'left-hand' operand. 
The parameter of the method is the 'right-hand' operand.
The result is stored in the variable, thus changing the 'left-hand' operand's value.

These are the basic arithmetic operations:
```csharp
var num1 = Var.Define("num1", 1);
var num2 = Var.Define("num2", 2);

On.Ready(
    num1.Add(num2),  // num1 changes to: (1 + 2) = 3
    num2.Sub(num1),  // num2 changes to: (2 - 3) = -1
    num1.Mul(num2),  // num1 changes to: (3 * -1) = -3
    num2.Div(num1),  // num2 changes to: (-1 / -3) = 0.333333333333333
);
```

The value of `num1` changes in lines 1 and 3 while `num2` changes in lines 2 and 4 where they are the left-hand operand.
At the end, `num1` holds the value `-3` and `num2` holds the value `0.333333333333333`.

## Using Operator Overloads

Variables have overloaded operators, so you can also perform arithmetics _more naturally_ using the usual `+ - / *` operators.
This requires using the `Set()` method of a variable to perform the final assignment:

```csharp
var num1 = Var.Define("num1", 1);
var num2 = Var.Define("num2", 2);
var result = Var.Define("result");

On.Ready(
    result.Set((num2 - (num1 + num2)) / ((num1 + num2) * (num2 - (num1 + num2)))),
    Debug.Log(result) // prints '0.333333333333333' (same as above)
);
```

This performs the exact same arithmetics as above.

Since the `num1` and `num2` values don't change, we have to repeat certain operations like `num1 + num2` several times. This is the result of this contrived example, not a general problem. You can simplify the calculation by using an intermediate variable that holds the repeating value:

```csharp
var num1 = Var.Define("num1", 1);
var num2 = Var.Define("num2", 2);
var three = Var.Define("intermediate");
var result = Var.Define("result");

On.Ready(
    three.Set(num1 + num2),
    result2.Set((num2 - three) / (three * (num2 - three))),
    Debug.Log(result) // prints '0.333333333333333' (same as above)
);
```

## Increment and Decrement

As a shorthand for `Add(1)` and `Sub(1)` there are `Inc()` increment and `Dec()` decrement methods.
We'll use them to count to three (positive and negative) in this example:

```csharp
var increasing = Var.Define("inc");
var decreasing = Var.Define("dec");

On.Heartbeat(If(increasing < 3).Then(increasing.Inc(), decreasing.Dec());
```

## Flip A Boolean

Boolean variables can be flipped with the `Toggle()` method:

```csharp
var fact = Var.Define("fact", false);

On.Heartbeat(fact.Toggle(), Debug.Log(fact));
```

This will continuously change the value between `true` and `false`.

> [!WARNING]
> If the variable was a number type, it will convert to a Boolean type. Any non-zero number value is considered `true`. Internally a Boolean variable will set the number value to either 0 (`false`) or 1 (`true`).

## Aliases Shmaliases

The arithmetic operations all use 3-letter abbreviations of the mathematical operations they represent.
This is primarily to improve readability and making math operations less verbose. 

Aliases are provided for those who like to avoid cryptic abbreviations reminiscent of assembly language.

| Operation | Wordy Alias  |
|:----------|:-------------|
| `Add`   | _(same)_     |
| `Sub`   | `Subtract`   |
| `Mul`   | `Multiply`   |
| `Div`   | `Divide`     |
| `Inc`   | `Increment`  |
| `Dec`   | `Decrement`  |

> [!NOTE]
> This list is not exhaustive. More advanced arithmetic operations (eg `Sqrt`, `Cos`, `Exp`, `Abs`) will be added over time.
