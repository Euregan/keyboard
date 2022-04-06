module Animation exposing (State, init, position, rotation, start, startAfter, update)

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
init to angle =
    Idle to angle


start : State -> Float -> Float -> Position -> Rotation -> State
start state delay duration to angle =
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
            , rotation = angle
            }


startAfter : State -> State -> Float -> Float -> Position -> Angle -> State
startAfter afterState previousState delay duration to angle =
    -- We avoid starting a new animation if it's not necessary
    if position previousState == to then
        previousState

    else
        case afterState of
            Idle _ _ ->
                Moving
                    { duration = duration
                    , delay = delay
                    , elapsed = 0
                    , from = position previousState
                    , to = to
                    , position = position previousState
                    , rotation = angle
                    }

            Moving animation ->
                Moving
                    { duration = duration
                    , delay = (animation.duration + animation.delay - animation.elapsed) + delay
                    , elapsed = 0
                    , from = position previousState
                    , to = to
                    , position = position previousState
                    , rotation = angle
                    }


position : State -> Position
position state =
    case state of
        Idle pos _ ->
            pos

        Moving animation ->
            animation.position


rotation : State -> Rotation
rotation state =
    case state of
        Idle _ angle ->
            angle

        Moving animation ->
            animation.rotation


update : Float -> State -> State
update delta state =
    case state of
        Idle pos angle ->
            Idle pos angle

        Moving animation ->
            if delta + animation.elapsed >= animation.duration + animation.delay then
                Idle animation.to animation.rotation

            else
                let
                    easeOut x =
                        1 - ((1 - x) ^ 3)

                    elapsed =
                        animation.elapsed + delta

                    percentTraveled =
                        if animation.delay > elapsed then
                            0

                        else
                            (elapsed - animation.delay) / animation.duration

                    relative fromValue toValue =
                        (toValue - fromValue) * easeOut percentTraveled

                    from =
                        Position.toRecord animation.from

                    to =
                        Position.toRecord animation.to
                in
                Moving
                    { animation
                        | elapsed = elapsed
                        , position = Position.new (from.x + relative from.x to.x) (from.y + relative from.y to.y) (from.z + relative from.z to.z)
                    }
