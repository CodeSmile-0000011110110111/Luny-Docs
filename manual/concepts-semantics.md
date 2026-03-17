# Luny Semantics Shmemantics 

LunyScript/LunyEngine strive to provide consistent, relatable semantics while avoiding terms that are too technical or too vague. But it also borrows semantics from engines where it makes the most sense.

## Object Lifecycle Events

These are the object lifecycle events how they map to various engines:

| **LunyScript**     | **Unity**         | **Godot**                                    | **Unreal**               |
|:-------------------|:------------------|:---------------------------------------------|:-------------------------|
| On.Created         | Awake             | _init                                        | InitializeComponent |
| On.Ready           | Start             | _ready                                       | BeginPlay                |
| On.Enabled         | OnEnable          | _enter_tree                                  | OnComponentActivated                   |
| On.Disabled        | OnDisable         | _exit_tree                                   | OnComponentDeactivated                   |
| On.Heartbeat       | FixedUpdate       | _physics_process                             | TickComponent                     |
| On.FrameUpdate     | Update            | _process                                     | TickComponent                     |
| On.FrameLateUpdate | LateUpdate        | N/A                                          | TickComponent                     |
| On.Destroyed       | OnDestroy         | N/A                                          | UninitializeComponent                  |
| On.Quitting        | OnApplicationQuit | _notification(NOTIFICATION_WM_CLOSE_REQUEST) | EndPlay                   |

> [!NOTE]
> The heartbeat may raise questions. The concept is simple: run code at a steady rate, decoupled from the framerate. That's where engines have issues: `FixedUpdate` .. uh, what is or gets 'fixed' here? And `_physics_process` is misleading
as this isn't just about physics but deterministic updates.
> 
> A heartbeat happens at a steady rate, but it can also "skip a beat", have an "extra beat", or race. Everyone experiences these, though I rephrained from calling it [`On.HeartPalpitation`](https://en.wikipedia.org/wiki/Palpitations). But it's the most relatable concept. 😊

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
