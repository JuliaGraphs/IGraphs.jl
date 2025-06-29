# News

## v0.10.18 - 2025-06-30

- `IGraphAlg` introduced as a generic dispatch argument for `Graphs.jl` functions extended with implementations from `igraph`.
- Implementing `Graphs.radius`, `Graphs.diameter`, and `Graphs.Experimental.has_isomorph` methods through `igraph`.
- `igraphalg_methods` lists all the `Graphs.jl` functions for which an `IGraphAlg` method has been defined.

## v0.10.17 - 2025-06-29

- `IGNull` is introduced as a convenient placehold argument for when the low-level C function expects a `NULL` as a default.

## v0.10.16 - 2025-04-21

- `IGVector*` and `IGMatrix*` support the corresponding julia `AbstractArray` interfaces now.

## v0.10.15 - 2025-04-17

- First release of IGraphs.jl closely wrapping the C library igraph v0.10.15
