# Your first Luny Script in Godot

**Goal**: You want to create a controllable capsule as your first "Player" in a blank scene.

If you're already familiar with the technicalities of the Godot editor you can [skip to the GDScript](#the-gdscript).

## Status Quo: Godot

This time you're going to use Godot since it's so much easier to work with!

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

This accomplishes three things Godot doesn't provide out of the box (as of v4.6):

- The 3D scene renders via the `Camera3D`
- The objects will be lit and will cast shadows due to the `DirectionalLight3D`
- The world isn't just a flat, solid color but feels three-dimensional thanks to the `WorldEnvironment`'s sky. 

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
    - Type "MoveRight". 
    - Click `Add`.
    - Type "MoveUp". 
    - Click `Add`.
    - Type "MoveDown".
    - Click `Add`.
    - Type "Jump".
    - Click `Add`.
    - Type "Crouch".
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
    - **Repeat the three button assignment steps five additional times:**
      - .. for the "MoveRight", "MoveUp", "MoveDown", "Jump", and "Crouch" input actions.

Now you can use these input mappings in your code. 

You could skip the gamepad and joystick setup for now if you prefer, but keep in mind: **players do expect common input devices to be supported!**

### The GDScript

With all those editor setup steps out of the way, at least now you need to write **much less code** in GDScript:

```gdscript
extends Node3D

var moveAction
var jumpAction
var crouchAction

func _ready():
    moveAction = "Move"
    jumpAction = "Jump"
    crouchAction = "Crouch"

func _process(delta: float):
    var move_input = Input.get_vector("MoveLeft", "MoveRight", "MoveDown", "MoveUp")
    var jump_input_value = Input.get_action_strength(jumpAction)
    var crouch_input_value = Input.get_action_strength(crouchAction)

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

Yes, that's not one, not two, but three whole lines you're saving compared to the Unity MonoBehaviour implementation! 

GDScript provides a minor syntactical ease but the imperative code complexity remains the same.

> [!NOTE]
> > 🤔 Hey, wait! This GDScript is 35 lines but Unity's code snippet was 52 lines!
> 
> Correct, but in all fairness we should stop counting C# code's lines with only `{` or `}` when comparing it to GDScript. 
> IDEs will thankfully place those curly braces for us anyway. 
> That makes Unity's solution 38 _actual lines of code_, just three more than the GDScript version.
> The number of empty lines also remains the same.

## With LunyScript

Here's the LunyScript C# implementation once again for reference - identical to its Unity version since Luny scripts represent portable code:

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

**At 13 lines, that's still 2.77 times fewer lines than GDScript! 😎**

> [!NOTE]
> LunyScript - once ported to Godot - will remain firmly based in C#. 
> GDScript is not a portable language nor does it handle fluent APIs well.

### Why So Many Extra Steps?

Compared to Unity, there's an egregious amount of extra steps to be done in the Godot editor before you even get to scripting. 

This is by design. Godot deliberately provides _clean slates_ for everything: no _meaningful templates_ and not even _sensible defaults_.

Since I've not seen or heard anyone talk about this, allow me to indulge in a personal opinion piece - which you are free to skip. 😏

---

Godot's user experience revolves around hierarchical user interfaces and modal dialogs. 
This provides an unusually consistent UI, which is easy to pick up by beginners and non-technical users. 
I've done the same kind of procedural, hierarchical UI for an internal tool some 20 years ago.

Those early user interface successes can also be quite rewarding. 
That this sort of user interface is inefficient at scale doesn't (yet) matter. 
And when you're aiming for greater things or a career, you'll move on eventually anyway.

This is exemplified by nine out of ten Godot users identifying as "hobbyists" (87%: [Community Poll 2025](https://docs.google.com/forms/d/e/1FAIpQLScKWGJoLEeNW1qrsDfZRfk7gHultapacH5ZhQmo9XRZADW1IQ/viewanalytics)) - a very consistent metric over the years.

It explains why the game industry doesn't take Godot *really* serious, both as an alternative and as a competitor. 
Godot is a welcome springboard for new talents while it helps to shield engines from low-yield (and sometimes high-maintenance) users. 
Godot won over the hobbyists, but also locked itself into that audience, due to its early and now irrevocable design decisions.

Personally I'd love Godot if it weren't for its anachronistic UX rolling back two decades of user interface design and software architecture progress.

Btw there are very capable alternatives: [Stride](https://www.stride3d.net/) (FOSS), [Flax](https://flaxengine.com/) (source available), and a 'coming soon' (FOSS) made by former Unity developers ...
