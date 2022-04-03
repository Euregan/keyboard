module Keyboard exposing (..)

import LoadState exposing (LoadState(..))
import Mesh exposing (Mesh)


type Keyboard
    = Corne


toString : Keyboard -> String
toString keyboard =
    case keyboard of
        Corne ->
            "Corne"
