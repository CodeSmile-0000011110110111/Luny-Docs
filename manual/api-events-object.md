# Object Lifecycle Events

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

Notable exceptions using nouns/adjectives instead of following the past tense `-ed` and participle `-ing` rules: 
- Frame events: `On.Heartbeat`, `On.FrameUpdate`
- The once-only event: `On.Ready`

This is because `On.Heartbeating`, `On.FrameUpdating` and `On.Readied` seemed rather odd.


> [!NOTE]
> Why "heartbeat"? I find that's where every engine has issues: `FixedUpdate` .. uh, what is 'fixed' here? Is `Update()` _broken_?? And `_physics_process` is too narrow and misleading: it's not (just) about physics.
>
> The concept of a heartbeat is simple and relatable: It happens at a steady rate, most of the time. But it can also "skip a beat" (may not run every frame), or have an "extra beat" or even "race" (run multiple times per frame to _catch up_).
