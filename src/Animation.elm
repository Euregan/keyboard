module Animation exposing (State, angle, init, position, start, update)

import Angle exposing (Angle)
import Position exposing (Position)
import Rotation exposing (Rotation)


type State
    = Idle Position Rotation
    | Moving Animation


type alias Animation =
    { delay : Float
    , duration : Float
    , elapsed : Float
    , from : Position
    , to : Position
    , position : Position
    , rotation : Rotation
    }


init : Position -> Angle -> State
init to rotation =
    Idle to rotation


start : State -> Float -> Float -> Position -> Angle -> State
start state delay duration to rotation =
    -- We avoid starting a new animation if it's not necessary
    if position state == to then
        state

    else
        Moving
            { duration = duration
            , delay = delay
            , elapsed = 0
            , from = position state
            , to = to
            , position = position state
            , rotation = rotation
            }


position : State -> Position
position state =
    case state of
        Idle pos _ ->
            pos

        Moving animation ->
            animation.position


angle : State -> Angle
angle state =
    case state of
        Idle _ rotation ->
            rotation

        Moving animation ->
            animation.rotation


update : Float -> State -> State
update delta state =
    case state of
        Idle pos rotation ->
            Idle pos rotation

        Moving animation ->
            if delta + animation.elapsed >= animation.duration + animation.delay then
                Idle animation.to animation.rotation

            else
                let
                    elapsed =
                        animation.elapsed + delta

                    percentTraveled =
                        if animation.delay > elapsed then
                            0

                        else
                            elapsed / animation.duration

                    relative fromValue toValue =
                        (toValue - fromValue) * sqrt ((cos (percentTraveled * pi - pi) + 1) / 2)

                    relativeZ fromValue toValue =
                        (toValue - fromValue) * (((cos (percentTraveled * (pi / 0.6964) - pi) + 1) / 1.2) ^ (1 / 4))

                    from =
                        Position.toRecord animation.from

                    to =
                        Position.toRecord animation.to
                in
                Moving
                    { animation
                        | elapsed = elapsed
                        , position = Position.new (from.x + relative from.x to.x) (from.y + relative from.y to.y) (from.z + relativeZ from.z to.z)
                    }
