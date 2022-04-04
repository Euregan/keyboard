module Display exposing (..)

import Angle
import Animation exposing (State)
import Pcb exposing (Pcb)
import Position
import Switch exposing (Switch)


type Display
    = Idle
        { pcb :
            { state : State
            , pcb : Pcb
            }
        , switches : List ( State, Switch )
        }


init : Pcb -> Display
init pcb =
    let
        pcbAnimation =
            Animation.start
                (Animation.init (Position.new 0 2 0) (Angle.degrees 0))
                0
                15000
                (Position.new 0 0 0)
                (Angle.degrees 0)
    in
    Idle
        { pcb =
            { state = pcbAnimation
            , pcb = pcb
            }
        , switches = []
        }


update : Float -> Display -> Display
update delta display =
    case display of
        Idle { pcb, switches } ->
            Idle
                { pcb =
                    { state = Animation.update delta pcb.state
                    , pcb = pcb.pcb
                    }
                , switches = switches
                }
