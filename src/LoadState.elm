module LoadState exposing (..)


type LoadState a
    = Pending
    | Loaded a
    | Error String
