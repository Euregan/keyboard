module DarkMode exposing (DarkMode, color, fromBoolean, tick, toBoolean, toggle)

import Color exposing (Color)


transitionDuration =
    75


type DarkMode
    = Dark
    | ToDark Float
    | Light
    | ToLight Float


color : DarkMode -> Color
color mode =
    let
        ( darkRed, darkGreen, darkBlue ) =
            ( 73, 73, 73 )

        ( lightRed, lightGreen, lightBlue ) =
            ( 224, 234, 242 )
    in
    case mode of
        Dark ->
            Color.rgb255 darkRed darkGreen darkBlue

        ToDark progress ->
            Color.rgb255
                (round <| (lightRed - darkRed) * (1 - progress) + darkRed)
                (round <| (lightGreen - darkGreen) * (1 - progress) + darkGreen)
                (round <| (lightBlue - darkBlue) * (1 - progress) + darkBlue)

        Light ->
            Color.rgb255 lightRed lightGreen lightBlue

        ToLight progress ->
            Color.rgb255
                (round <| (lightRed - darkRed) * progress + darkRed)
                (round <| (lightGreen - darkGreen) * progress + darkGreen)
                (round <| (lightBlue - darkBlue) * progress + darkBlue)


fromBoolean : Bool -> DarkMode
fromBoolean mode =
    case mode of
        True ->
            Dark

        False ->
            Light


toBoolean : DarkMode -> Bool
toBoolean mode =
    case mode of
        Dark ->
            True

        ToDark _ ->
            True

        Light ->
            False

        ToLight _ ->
            False


toggle : DarkMode -> DarkMode
toggle mode =
    case mode of
        Dark ->
            ToLight 0

        ToDark progress ->
            ToLight (1 - progress)

        Light ->
            ToDark 0

        ToLight progress ->
            ToDark (1 - progress)


tick : Float -> DarkMode -> DarkMode
tick delta mode =
    case mode of
        Dark ->
            Dark

        Light ->
            Light

        ToDark progress ->
            let
                newProgress =
                    progress + (delta / transitionDuration)
            in
            if newProgress > 1 then
                Dark

            else
                ToDark newProgress

        ToLight progress ->
            let
                newProgress =
                    progress + (delta / transitionDuration)
            in
            if newProgress > 1 then
                Light

            else
                ToLight newProgress
