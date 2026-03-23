# Your first Luny Script in Unity

**Goal**: You want to create a controllable capsule as your first "Player" in a blank scene, using LunyScript.

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
    public override void Build(ScriptBuildContext context)
    {
        On.FrameUpdate(
            Transform.MoveBy(Input.Direction("Move"), 4),
            Transform.MoveUp(Input.Button("Jump").Strength, 4),
            Transform.MoveDown(Input.Button("Crouch").Strength, 4)
        );
    }
}
```

**At 13 lines, it is 4 times less than its [MonoBehaviour](getting-started-first-script-unity.md) implementation!** 😎

Enter playmode and try it.

## Notes

Inspector assignment of Luny scripts is optional. 

By default, a Luny script will run for any object in the active scene that matches the script's class name.
A LunyScript class named "Player" will run for the object named "Player".

There will be options to directly assign scripts and relax the name matching.
