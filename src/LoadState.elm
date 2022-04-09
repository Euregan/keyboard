module LoadState exposing (..)


type LoadState a
    = Pending
    | Loaded a
    | Error String


map2 : (a -> b -> c) -> LoadState a -> LoadState b -> LoadState c
map2 func loadStateA loadStateB =
    case ( loadStateA, loadStateB ) of
        ( Loaded a, Loaded b ) ->
            Loaded <| func a b

        ( Error error, _ ) ->
            Error error

        ( _, Error error ) ->
            Error error

        _ ->
            Pending
