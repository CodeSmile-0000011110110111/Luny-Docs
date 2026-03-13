# Your first Luny Script in Godot

**Goal**: You want to create a controllable capsule as your first "Player" in a blank scene.

This time you're clever and try it in Godot, since it's so much easier to work with!

## Status Quo (Godot)

Nobody tells starters about the egregious amount of work Godot offloads onto users via UI interactions. I'll walk you through the process. 

If you're already familiar with the technicalities of the Godot editor you can [skip to the GDScript](#the-gdscript).

### Create the 3D Scene

To create a usable scene in Unity, you would do this:

- **Project**: `Right-click: Create -> Scene -> Scene`. Name it.

In Godot, you will have to perform these steps:

- **FileSystem**: `Right-click -> New Scene`.
    - In the popup dialog: Select `3D Scene`, enter scene name, click `OK`.
- **Scene**: `Right-click: Add Child Node`.
    - **Node Dialog**: Select `Camera3D`. Click `Create`.
- **Inspector**: Select `Camera3D`. Check `Current`.
- **Scene**: Select root node.
- **Scene**: `Right-click: Add Child Node`.
    - **Node Dialog**: Select `DirectionalLight3D`. Click `Create`.
- **Scene**: Select root node.
- **Scene**: `Right-click: Add Child Node`.
    - **Node Dialog**: Select `WorldEnvironment`. Click `Create`.
- **Inspector**: Select `WorldEnvironment`.
    - `Environment -> New Environment`.
    - Click `Environment`. `Background -> Mode -> Sky`.
    - `Sky -> New Sky`.
    - Click `Sky`. `Sky Material -> New ProceduralSkyMaterial`.

Now your scene renders (requires a camera), objects are lit and cast shadows (requires a light), and the world doesn't look flat (requires a skybox). 

### Create the Player Object

To create a player capsule character with a script in Unity, you would do this:

- **Project**: `Right-click: Create -> MonoBehaviour Script`. Name it "Player".
- **Hierarchy**: `Right-click: 3D Object -> Capsule`. Name it "Player".
- **Inspector**: Select "Player". `Add Component -> Player`.

In Godot, you will have to perfom these steps:

- **Scene**: Select root node.
- **Scene**: `Right-click: Add Child Node`.
    - **Node Dialog**: Select `CharacterBody3D`. Click `Create`.
- **Scene**: `Right-click: CharacterBody3D -> Add Child Node`.
    - **Node Dialog**: Select `CollisionShape3D`. Click `Create`.
- **Inspector**: Select `CollisionShape3D`. Click `Shape -> CapsuleShape3D`.
- **Scene**: `Right-click: CharacterBody3D -> Add Child Node`.
    - **Node Dialog**: Select `MeshInstance3D`. Click `Create`.
- **Inspector**: Select `MeshInstance3D`. Click `Mesh -> CapsuleMesh`.
- **Scene**: Select `CharacterBody3D`.
- **Scene**: `Right-click: Attach Script`.
  - **Attach Node Script Dialog**: Browse or enter path and file name. Click `Create`.

Now you have a capsule character with a script attached.

### Create the Input Setup

Unity already provides you with a default Input Map for Keyboard&Mouse, Gamepad and Joystick input devices.

In Godot, you will have to set up the Input Map yourself:

- **Menu**: `Project -> Project Settings`.
- **Project Settings**: Click the `Input Map` tab.
- **Input Map**: In the `Action` field:
    - Type "MoveLeft". Click `Add`.
    - Type "MoveRight". Click `Add`.
    - Type "MoveUp". Click `Add`.
    - Type "MoveDown". Click `Add`.
    - Type "Jump". Click `Add`.
    - Type "Crouch". Click `Add`.
    - Click the `+` icon next to "MoveLeft" action -> **Event Configuration for..**:
        - Press the desired key or mouse button (or select it from the list). Click `OK`.
        - Press the desired gamepad button (or select it from the list). Click `OK`.
        - Press the desired joystick button (or select it from the list). Click `OK`.
    - **Repeat the above steps** five additional times ..
      - .. for the "MoveRight", "MoveUp", "MoveDown", "Jump", and "Crouch" input actions.

Now you can use these input mappings in your code. You could skip the gamepad and joystick setup if you like. But players do expect all common input devices to be supported.

### Why So Many Steps?

Godot is deliberately designed to provide a _clean slate_ for everything, and to generate the UI rather than purposefully designing it. It does not provide _meaningful templates_ and in many cases not even _sensible defaults_ while confronting users with an abundance of modal dialogs and deeply nested hierarchies.

Some find this experience to be 🤓😎 while others are like 😕😒. 

Godot has its strengths (2D workflows, consistency, open source, small projects), weaknesses (3D, UI/UX, asset management, platform support, large projects), and irrevocable flaws (OOP architecture). Simply put: GDScript may be easier, but marginally so while the Godot editor all around isn't easier (definitely not less work) but it does provide higher consistency than Unity's and Unreal's interfaces.

### The GDScript

With all those editor setup steps out of the way, at least now you're going to have to write **a lot less code** with GDScript:

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

Well .. turns out you're saving just three lines of code compared to Unity! Even in GDScript, imperative code complexity remains the biggest burden! The language merely provides a syntactical ease.

> Hey, wait! This GDScript is 35 lines but Unity's code snippet was 52 lines! 🤔 

Correct, but in all fairness we should stop counting C# code's { } brace lines when comparing it to GDScript. The C# IDEs will thankfully place those braces for us anyway. That makes Unity's solution 38 _actual lines of code_, just three more than the GDScript version.

## With LunyScript

Now let's compare the same process with LunyScript again. 

Assuming a - as of yet imaginary - Godot version of LunyScript, I would definitely provide _meaningful templates_ and _sensible defaults_ to reduce the UI interactions. But since that doesn't exist, I can't replicate equal workflow steps, so just assume you still have to do all the above outside of scripting.

Here's the LunyScript C# implementation once again - identical to its Unity version since it is portable code:

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

**Still 2.77 times less than GDScript! 😎** Those 13 lines you could have just copy-pasted from Unity.

Note: LunyScript will continue to be based in C# even when it does support Godot in the future. GDScript is not a portable language, and it doesn't handle fluent APIs well.
