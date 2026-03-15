# Your first Luny Script in Unity

**Goal**: You want to create a controllable capsule as your first "Player" in a blank scene.

## Status Quo: Unity

First, let's see what you would currently have to do in Unity:

- **Project**: `Right-click: Create -> Scene -> Scene`. Name it whatever you like.
- **Project**: `Right-click: Create -> MonoBehaviour Script`. Name it "Player".
- **Hierarchy**: `Right-click: 3D Object -> Capsule`. Name it "Player".
- **Inspector**: Select "Player". `Inspector: Add Component -> Player`.
- You check the Internet for a "simple" Unity 'Player' script and found this:

```csharp
using UnityEngine;
using UnityEngine.InputSystem;

public class Player : MonoBehaviour 
{
    private InputAction moveAction;
    private InputAction jumpAction;
    private InputAction crouchAction;

    void Awake() 
    {
        moveAction = InputSystem.actions.FindAction("Move");
        jumpAction = InputSystem.actions.FindAction("Jump");
        crouchAction = InputSystem.actions.FindAction("Crouch");
    }

    void Update() 
    {
        Vector2 rawMoveInput = moveAction.ReadValue<Vector2>();
        float jumpInputValue = jumpAction.ReadValue<float>();
        float crouchInputValue = crouchAction.ReadValue<float>();

        float moveX = rawMoveInput.x;
        float moveZ = rawMoveInput.y;

        Vector3 movementDirection = new Vector3(0, 0, 0);
        movementDirection.x = moveX;
        movementDirection.z = moveZ;

        if (jumpInputValue > 0.1f) 
        {
            movementDirection.y = 1.0f;
        }
        else 
        {
            if (crouchInputValue > 0.1f) 
            {
                movementDirection.y = -1.0f;
            }
            else 
            {
                movementDirection.y = 0.0f;
            }
        }

        float movementSpeed = 4.0f;
        float timeStep = Time.deltaTime;
        Vector3 finalMovement = movementDirection * timeStep * movementSpeed;

        transform.Translate(finalMovement);
    }
}
```

**It's _only_ 52 lines for something so trivial. 🤯**

## With LunyScript

Let's compare it with the same LunyScript:

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

**That's 13 lines! Four times less! 😎**

It only gets better from here on. The complexit doesn't scale proportionally, the gap widens the more you script!
