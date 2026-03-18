# Luny Semantics Shmemantics 

LunyScript and LunyEngine strive to provide consistent, relatable semantics while avoiding terms that are too technical or too vague. But it also borrows semantics from engines where it makes the most sense. 

The idea is _not another opinionated API_ but to fix game engines' inconsistencies, and to more strictly follows C# / .NET naming guidelines. Events that already happened use past tense (-ed). Ongoing events use present tense (-ing). Some exceptions: Consistently scheduled events use nouns (Heartbeat, FrameUpdate), and once-only events may use adjectives (Ready).

## Object Lifecycle Events

These are the object lifecycle events which can run blocks. The table shows how they map to the most widely used game engines' lifecycle events:

| **LunyScript**              | **Unity**         | **Godot**          | **Unreal**               |
|:----------------------------|:------------------|:-------------------|:-------------------------|
| On.Created                  | Awake             | _init              | InitializeComponent |
| On.Ready                    | Start             | _ready             | BeginPlay                |
| On.Enabled                  | OnEnable          | _enter_tree        | OnComponentActivated                   |
| On.Disabled                 | OnDisable         | _exit_tree         | OnComponentDeactivated                   |
| On.Heartbeat                | FixedUpdate       | _physics_process   | TickComponent                     |
| On.FrameUpdate              | Update            | _process           | TickComponent                     |
| On.FrameLateUpdate          | LateUpdate        | N/A                | TickComponent                     |
| On.Destroyed                | OnDestroy         | N/A (not reliable) | UninitializeComponent                  |
| On.Collision(2D).Started    |       |                                           |                    |
| On.Collision(2D).Continuing |       |                                           |                    |
| On.Collision(2D).Ended      |       |                                           |                    |
| On.Trigger(2D).Entered      |       |                                           |                    |
| On.Trigger(2D).Staying      |       |                                           |                    |
| On.Trigger(2D).Exited       |       |                                           |                    |

I thoroughly considered each and every semantic carefully. Most terms are borrowed from Unity because its semantics are consistent and relatable, and it's the most widely used engine.

> [!NOTE]
> The "heartbeat" may seem unusual. It's where every engine has issues: `FixedUpdate` .. uh, what is 'fixed' here? Is `Update()` _broken_?? And `_physics_process` is also misleading: it's not just about physics. 
> 
> The concept of a heartbeat is simple and relatable: It happens at a steady rate, mostly. But it can also "skip a beat" (not run in a frame), or have an "extra beat", even "race" (run multiple time per frame). Everyone can relate to such [heart palpitations](https://en.wikipedia.org/wiki/Palpitations. 😊

## Global Events

This list isn't complete but still provides a broad overview of global/external events that can run blocks:

| **LunyScript**               | **Unity**                  | **Godot**                                    | **Unreal**               |
|:-----------------------------|:---------------------------|:---------------------------------------------|:-------------------------|
| When.Input.Action.Started    |       | N/A                                          |                    |
| When.Input.Action.Performed  |       | N/A                                          |                    |
| When.Input.Action.Continuing |       | N/A                                          |                    |
| When.Input.Action.Ended      |       | N/A                                          |                    |
| When.Scene.Loaded            | SceneManager.sceneLoaded   | N/A                                          |                    |
| When.Scene.Unloaded          | SceneManager.sceneUnloaded | N/A                                          |                    |
| When.Quitting                | OnApplicationQuit          | _notification(NOTIFICATION_WM_CLOSE_REQUEST) | EndPlay                   |

The distinction between `On.*` and `When.*` is one of 'local' vs 'global': The `On.*` events relate to the object itself, the `When.*` events are external events, not targeting a specific object.  

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
| OnServiceStartup         | After LunyEngine initialization                        |
| OnServiceFrameBegins     | Before frame update                                    |
| OnServiceHeartbeat       | Before object's heartbeat                              |
| OnServiceFrameUpdate     | Before object's frame update                           |
| OnServiceFrameLateUpdate | Before object's frame late update                      |
| OnServiceFrameEnds       | After frame update completed                           |
| OnServiceShutdown        | Application quitting                                   |
