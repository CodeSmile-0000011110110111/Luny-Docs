# Your first Luny Script in Unity

**Goal**: You want to create a controllable capsule as your first "Player" in a blank scene.

## LunyScript Implementation

The setup process for our LunyScript in Unity:

- **Project**: `Right-click: Create -> Scene -> Scene`.
- **Project**: `Right-click: Create -> Luny Script`. Name it "Player".
- **Hierarchy**: `Right-click: 3D Object -> Capsule`. Name it "Player".
- **Edit** the `Player.cs` script and add this to its `Build()` method:

```csharp
using LunyScript;

public partial class Player : Script
{
    public override void Build(ScriptContext context)
    {
        On.FrameUpdate(
            Transform.MoveBy(Input.Direction("Move"), 4),
            Transform.MoveUp(Input.Button("Jump").Strength, 4),
            Transform.MoveDown(Input.Button("Crouch").Strength, 4)
        );
    }
}
```

**That's just 13 lines! 😎** It's 4 times less than MonoBehaviour, and 2.77 times less than GDScript.

Enter playmode and try it.

## Notes

Inspector assignment of Luny scripts is optional. 

By default, a Luny script will run for any object in the active scene that matches the script's class name.
A LunyScript class named "Player" will run for the object named "Player".

In future there will be options to:

- Relax the class name vs object name match:
  - disable strict upper-/lowercase matching (eg runs on "player")
  - match start/end of name (eg runs on "Player 1" and "Player 2")  
- Directly assign one or more Luny scripts to an object
