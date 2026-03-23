# Object and Global Events

LunyScript and LunyEngine strive to provide consistent, relatable event semantics. The idea is to fix game engines' inconsistencies by strictly following C# / .NET naming guidelines for consistency, and to try and define a possible common standard (long term).

The event semantics follow these rules:
- Events that already happened use past tense: `-ed`.
- Ongoing / recurring events use present tense: `-ing`. 
- [Object Events](concepts-events-object.md) -> Use the `On.*` prefix.
- [Global Events](concepts-events-global.md) -> Use the `When.*` prefix.
- [LunyEngine SDK Events](concepts-events-engine.md)
