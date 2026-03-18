# Global Events

Global (external) events use the `When.*` prefix, in contrast to the `On.*` events which target a specific object.

| **LunyScript**               | **Unity**                  | **Godot**                                                | **Unreal**             |
|:-----------------------------|:---------------------------|:---------------------------------------------------------|:-----------------------|
| When.Input.Action.Started    | started                    | N/A                                                      | Started                |
| When.Input.Action.Performed  | performed                  | N/A                                                      | Triggered              |
| When.Input.Action.Continuing | performed                  | N/A                                                      | Ongoing                |
| When.Input.Action.Ended      | canceled                   | N/A                                                      | Canceled/Completed     |
| When.Scene.Loaded            | sceneLoaded   | N/A (tree_entered on root)                               | OnLevelLoaded          |
| When.Scene.Unloaded          | sceneUnloaded | N/A                                                      | OnLevelUnloaded        |
| When.Quitting                | OnApplicationQuit          | _notification(..) with<br/>NOTIFICATION_WM_CLOSE_REQUEST | EndPlay (Reason: Quit) |

This list isn't exhaustive or complete but should provide an overview of the most common global events that can run blocks.
