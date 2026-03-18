# Engine and Service Events

These are LunyEngine events. Used internally and by framework developers, you will nevertheless run into them in callstacks (logs, exceptions).  

## LunyEngine Observer Events

These events are used by implementations of [`ILunyEngineObserver`](xref:Luny.ILunyEngineObserver).

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
