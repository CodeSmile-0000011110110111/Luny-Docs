# Your first Luny Script in Godot

**Goal**: You want to create a controllable capsule as your first "Player" in a blank scene. This time you'll try Godot.

## Status Quo: Godot 4.6

If you're already familiar with the Godot editor workflows, [skip to the GDScript](#the-gdscript). <br/>
Everyone else: brace yourselves.

### Create the 3D Scene

To create a usable 3D scene in Godot, you will have to perform these steps:

- **FileSystem**: `Right-click -> New Scene`.
    - In the modal dialog: Select `3D Scene`, enter scene name.
    - Click `OK`.
- **Scene**: `Right-click: Add Child Node`.
    - **Node Dialog**: Select `Camera3D`. 
    - Click `Create`.
- **Scene**: Select root node.
- **Scene**: `Right-click: Add Child Node`.
    - **Node Dialog**: Select `DirectionalLight3D`. 
    - Click `Create`.
- **Scene**: Select root node.
- **Scene**: `Right-click: Add Child Node`.
    - **Node Dialog**: Select `WorldEnvironment`. 
    - Click `Create`.
- **Inspector**, with `WorldEnvironment` selected:
    - `Environment -> New Environment`.
    - Click `Environment`. 
      - `Background -> Mode -> Sky`.
      - `Sky -> New Sky`.
        - Click `Sky`. 
        - `Sky Material -> New ProceduralSkyMaterial`.

This accomplishes three things Godot doesn't provide out of the box:

- The 3D scene renders via the `Camera3D`. Without it you'd just get a solid color window. 
- The objects will be lit and will cast shadows via the `DirectionalLight3D`. Without it, everything would look dim and flat.
- A color gradient resembles the horizon via the `WorldEnvironment` sky. Without it, it wouldn't feel three-dimensional due to a solid-color backdrop. 

### Create the Player Object

To create a player capsule character with a script in the 3D scene, you will need to perfom these steps:

- **Scene**: Select root node.
- **Scene**: `Right-click: Add Child Node`.
    - **Node Dialog**: Select `CharacterBody3D`. 
    - Click `Create`.
- **Scene**: `Right-click: CharacterBody3D -> Add Child Node`.
    - **Node Dialog**: Select `CollisionShape3D`. 
    - Click `Create`.
- **Inspector** with `CollisionShape3D` selected:
  - Click `Shape -> CapsuleShape3D`.
- **Scene**: `Right-click: CharacterBody3D -> Add Child Node`.
    - **Node Dialog**: Select `MeshInstance3D`. 
    - Click `Create`.
- **Inspector** with `MeshInstance3D` selected:
  - Click `Mesh -> CapsuleMesh`.
- **Scene**: `Right-click: CharacterBody3D -> Attach Script`.
  - **Attach Node Script Dialog**: Browse or enter path and file name. 
  - Click `Create`.

Now you have a capsule character with a GDScript attached.

### Create the Input Map

Godot projects start with an empty Input Map. You will have to set it up yourself:

- **Menu**: `Project -> Project Settings`.
- **Project Settings**: Click the `Input Map` tab.
- **Input Map**, in the `Action` field:
    - Type "MoveLeft". 
    - Click `Add`.
    - Click the `+` icon next to "MoveLeft" action -> **Event Configuration for..**:
        - Press the desired key or mouse button (or select it from the list). 
        - Click `OK`.
    - Click the `+` icon next to "MoveLeft" action -> **Event Configuration for..**:
        - Press the desired gamepad button (or select it from the list). 
        - Click `OK`.
    - Click the `+` icon next to "MoveLeft" action -> **Event Configuration for..**:
        - Press the desired joystick button (or select it from the list). 
        - Click `OK`.
    - **Repeat the above steps five additional times:**
      - .. for the "MoveRight", "MoveUp", "MoveDown", "Jump", and "Crouch" input actions.

Now you can use these input mappings in your code. 

You could skip the gamepad and joystick setup for now if you prefer, but keep in mind: **players do expect common input devices to be supported!**

### Why So Many Extra Steps?

Compared to Unity, there's an egregious amount of extra steps to be done in the Godot editor before you even get to scripting.

Godot deliberately provides _clean slates_ for everything, no _meaningful templates_, and lacks _sensible defaults_. Its user experience centers on _deeply hierarchical_ (procedural) user interfaces and an abundance of _modal dialogs_. This results in higher-than-usual UI interactions. 

While Unreal editor's highly complex UI with many uniquely designed windows will shock beginners and challenges even experienced developers, Godot's design provides a consistent UI experience that's easy to pick up. Thanks to the higher number of _successful interactions_ it is rewarding and it feels productive.

### The GDScript

With all those editor setup steps out of the way, at least now you need to write **much less code** in GDScript:

```gdscript
extends Node3D

func _process(delta: float):
    var move_input = Input.get_vector("MoveLeft", "MoveRight", "MoveDown", "MoveUp")
    var jump_input_value = Input.get_action_strength("Jump")
    var crouch_input_value = Input.get_action_strength("Crouch")

    var moveX = move_input.x
    var moveZ = move_input.y

    var movementDirection = Vector3(0, 0, 0)
    movementDirection.x = moveX
    movementDirection.z = moveZ

    if jump_input_value > 0.1:
        movementDirection.y = 1.0
    else:
        if crouch_input_value > 0.1:
            movementDirection.y = -1.0
        else:
            movementDirection.y = 0.0

    var movementSpeed = 4.0
    var finalMovement = movementDirection * delta * movementSpeed

    translate(finalMovement)
```

That's **ten lines** you're saving compared to the [Unity MonoBehaviour implementation](getting-started-first-script-unity.md). 

However, the savings derive solely from inlining the Input map strings, thus avoiding field declarations (instance variables). The code looks strikingly familiar: its complexity remains exactly the same, with only minor syntax reduction (braces, semicolons).

> [!NOTE]
> | 🤔 Hey, wait! This GDScript is 26 lines but Unity's code snippet was 52 lines!<br/> 
> Correct, but in all fairness we should stop counting _empty lines_ and _structural lines_ with only a `{` or `}` character. 
> That makes Unity's solution 30 and the GDScript version 20 _actual lines of code_.

## With LunyScript

Here's the LunyScript C# implementation once again for reference - identical to its Unity version since Luny scripts represent portable code:

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

**At 7 _actual lines of code_ it is merely a third of the GDScript! 😎**

> [!NOTE]
> LunyScript, when ported to Godot, will remain in C#. GDScript is a proprietary language 
> that entrenches lock-in - a polar opposite of LunyScript's vision. 
