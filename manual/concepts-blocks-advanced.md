# Advanced Block Uses 

LunyScript's block-based nature provides scripting opportunities which may not be immediately obvious. We can leverage basic C# functionality to take block-based scripting to the next level. 


## Assigning Blocks To Variables

You can create a block and assign it to a variable, and then use the variable:

```csharp
public override void Build(ScriptBuildContext context)
{
    var createEnemy = Object.Create("Enemy").With("Assets/Prefabs/Enemy");
    
    // this will run the createEnemy block
    On.Ready(createEnemy);
}
```

This also helps to keep the script more readable. It allows you to use the same block in multiple runners:

```csharp
public override void Build(ScriptBuildContext context)
{
    var createEnemy = Object.Create("Enemy").With("Assets/Prefabs/Enemy");
    
    // Caution: this is going to create a looooot of enemies!
    On.Ready(createEnemy);
    On.Heartbeat(createEnemy);
    On.FrameUpdate(createEnemy);
    On.Destroyed(createEnemy);
}
```

A variable can also hold multiple blocks, for instance the `ActionBlock[]` arrays returned from the methods above can be assigned to a variable and used multiple times.

## Re-Using vs Re-Creating Blocks

There is an important distinction: once a block has been created, you can use it multiple times. But you can no longer modify the block without modifying all uses of that block.

If you need individual block behaviour (eg different names) you will have to create separate block instances instead. This is what we'll be doing next, but cleverly so.

## Using Loops To Create Blocks

**Question**: What if I wanted to create ten enemies, each with a unique name?

**Dumb Answer**: You'll copy-paste the line ten times. <-- _This is not maintainable!_

**Clever Answer**: You'll use a loop!

```csharp
public override void Build(ScriptBuildContext context)
{
    var prefabPath = "Assets/Prefabs/Enemy";
    for (var i = 1; i <= 10; i++)
    {
        var name = "Enemy_" + i;
        var createEnemy = Object.Create(name).With(prefabPath);
        
        On.Ready(createEnemy);
    }
}
```

This will instantiate `Enemy_1` to `Enemy_10` with the `Assets/Prefabs/Enemy.prefab` asset.

## Using Runtime Loops

What if the number of enemies needs to change over time? A wave spawning system perhaps.

This is why LunyScript provides logic flow constructs as blocks themselves, so that we can run the loop at runtime instead of during `Build()`:

```csharp
public override void Build(ScriptBuildContext context)
{
    // Create ten enemies every time we get enabled
    var createEnemy = Object.Create("Enemy").With(prefabPath);
    On.Enabled(For(10).Do(createEnemy));
}
```

This creates 10 enemies every time the object gets enabled. You could write that with a C# for loop just as well. We don't change the number of enemies yet.

To do that, we use a LunyScript runtime variable holding the current number of enemies to spawn:

```csharp
public override void Build(ScriptBuildContext context)
{
    // define the runtime variable, 3 is the initial value
    var enemyCount = Var.Define("num enemies to spawn", 3);

    // Create an increasing number of enemies by adding 2 to enemyCount
    var createEnemy = Object.Create("Enemy").With(prefabPath);
    On.Enabled(For(enemyCount).Do(createEnemy), enemyCount.Add(2));
}
```

Now we initially create 3 enemies, and on every subsequent enable we'll create two more: 5, 7, 9 and so forth.

## Methods Returning Blocks

You can extract the creation of blocks into reusable methods. This also keeps the `Build()` method clean and readable:

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

This adds several syntax elements to the script we wouldn't usually write. Thus this strategy is for advanced users, not something you would teach to absolute beginners right away.

## Caution: Blocks Outside Runnable Events Won't Run

Creating a block outside of a block runner will silently discard that block:

```csharp
public override void Build(ScriptBuildContext context)
{
    // Nothing will run this block ... it gets discarded
    Object.Create("Enemy").With("Assets/Prefabs/Enemy");
}
```

Block instances won't run by themselves. If a block isn't assigned to a "block runner" such a stray block won't run. Block runners are containers that hold on to blocks and execute them at runtime. Most commonly the `On.*` and `When.*` event handlers.

> [!TIP]
> I found a way to detect such 'unused' blocks. This may log a warning or error in the future. 
