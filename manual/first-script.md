# Your first Luny Script

You have a blank scene in Unity. You want to create a character controller.

## Status Quo

- **Hierarchy**: `Right-click: 3D Object -> Capsule`. Name it "Player".
- **Project**: `Right-click: Create -> MonoBehaviour Script`. Name it "Player".
- **Hierarchy**: Select "Player". `Inspector: Add Component -> Player`.
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

**It's 'only' 51 lines! 🤯**

## With LunyScript

- **Hierarchy**: `Right-click: 3D Object -> Capsule`. Name it "Player".
- **Project**: `Right-click: Create -> Luny Script`. Name it "Player".
- _Component: optional. Luny scripts run on the object matching the script's name._
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

**That's 12 lines! 😎**

Enter playmode and try it.
