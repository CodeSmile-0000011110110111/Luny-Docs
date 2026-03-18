# Luny Semantics Shmemantics

LunyScript and LunyEngine strive to provide consistent, relatable semantics while avoiding terms that are too technical or too vague. But it also borrows semantics from engines where it makes the most sense.

The idea is to fix game engines' inconsistencies and to more strictly follows C# / .NET naming guidelines in hope of a standardization (long term). Events that already happened use past tense (-ed). Ongoing events use present tense (-ing). Some exceptions: Consistently scheduled events (`On.Heartbeat`, `On.FrameUpdate`) and once-only events (`On.Ready`).

## Object Lifecycle Events

These are the object lifecycle events which can run blocks.
All object-specific events use the `On.*` prefix.
The table shows how they map to object lifecycle events in the most popular game engines:

| **LunyScript**              | **Unity**            | **Godot**          | **Unreal**              |
|:----------------------------|:---------------------|:-------------------|:------------------------|
| On.Created                  | Awake                | _init              | InitializeComponent     |
| On.Ready                    | Start                | _ready             | BeginPlay               |
| On.Enabled                  | OnEnable             | _enter_tree        | OnComponentActivated    |
| On.Disabled                 | OnDisable            | _exit_tree         | OnComponentDeactivated  |
| On.Heartbeat                | FixedUpdate          | _physics_process   | TickComponent           |
| On.FrameUpdate              | Update               | _process           | TickComponent           |
| On.FrameLateUpdate          | LateUpdate           | N/A                | TickComponent           |
| On.Destroyed                | OnDestroy            | N/A (manual)       | UninitializeComponent   |
| On.Collision(2D).Started    | OnCollisionEnter(2D) | body_entered       | OnComponentHit          |
| On.Collision(2D).Continuing | OnCollisionStay(2D)      | N/A (manual)       | N/A (manual)            |
| On.Collision(2D).Ended      | OnCollisionExit(2D)      | body_exited        | N/A (manual)            |
| On.Trigger(2D).Entered      | OnTriggerEnter(2D)       | area_entered       | OnComponentBeginOverlap |
| On.Trigger(2D).Staying      | OnTriggerStay(2D)        | N/A (manual) | N/A (manual)            |
| On.Trigger(2D).Exited       | OnTriggerExit(2D)        | area_exited        | OnComponentEndOverlap   |

> [!NOTE]
> The "heartbeat" may seem unusual. It's where every engine has issues: `FixedUpdate` .. uh, what is 'fixed' here? Is `Update()` _broken_?? And `_physics_process` is also misleading: it's not just about physics.
>
> The concept of a heartbeat is simple and relatable: It happens at a steady rate, mostly. But it can also "skip a beat" (not run in a frame), or have an "extra beat", even "race" (run multiple time per frame).

## Global Events

Global (external) events use the `When.*` prefix, in contrast to the `On.*` events which target a specific object.
This list isn't exhaustive or complete but should provide an overview of the most common global events that can run blocks:

| **LunyScript**               | **Unity**                  | **Godot**                                    | **Unreal**             |
|:-----------------------------|:---------------------------|:---------------------------------------------|:-----------------------|
| When.Input.Action.Started    | started                    | N/A                                          | Started                |
| When.Input.Action.Performed  | performed                  | N/A                                          | Triggered              |
| When.Input.Action.Continuing | performed                  | N/A                                          | Ongoing                |
| When.Input.Action.Ended      | canceled                   | N/A                                          | Canceled/Completed     |
| When.Scene.Loaded            | SceneManager.sceneLoaded   | N/A (tree_entered on root)                   | OnLevelLoaded          |
| When.Scene.Unloaded          | SceneManager.sceneUnloaded | N/A                                          | OnLevelUnloaded        |
| When.Quitting                | OnApplicationQuit          | _notification(NOTIFICATION_WM_CLOSE_REQUEST) | EndPlay (Reason: Quit) |

## LunyEngine Observer Events

These events are used by implementations of [`ILunyEngineObserver`](xref:Luny.ILunyEngineObserver). You will probably not write an observer yourself, but you will likely see those methods in code and callstacks.

| **Event**               | **Description**                                       |
|:------------------------|:------------------------------------------------------|
| OnEngineStartup         | Application launched, after LunyEngine initialization |
| OnEngineFrameBegins     | Every frame, before Heartbeat/FrameUpdate             |
| OnEngineHeartbeat       | Fixed timestep, 0-n times per frame                   |
| OnEngineFrameUpdate     | Frame update                                          |
| OnEngineFrameLateUpdate | Runs after frame update                               |
| OnEngineFrameEnds       | Every frame, after all frame events                   |
| OnEngineShutdown        | Application quitting                                  |

## LunyEngine Service Events

Very similar events are used by implementations of [`LunyEngineServiceBase`](xref:Luny.Engine.Services.LunyEngineServiceBase) providing engine "services" - feature-level APIs.

| **Event**                | **Description**                                        |
|:-------------------------|:-------------------------------------------------------|
| OnServiceInitialize      | Application launched, during LunyEngine initialization |
| OnServiceStartup         | After LunyEngine and all services' initialization      |
| OnServiceFrameBegins     | Before frame update                                    |
| OnServiceHeartbeat       | Before object's heartbeat                              |
| OnServiceFrameUpdate     | Before object's frame update                           |
| OnServiceFrameLateUpdate | Before object's frame late update                      |
| OnServiceFrameEnds       | After frame update completed                           |
| OnServiceShutdown        | Application quitting                                   |

Services have an additional `OnServiceInitialize` event for internal setup which is required to complete before `OnServiceStartup`.
During `OnServiceInitialize` the LunyEngine's services may not all be available or fully initialized.
