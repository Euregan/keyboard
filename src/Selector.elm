module Selector exposing (..)

import Html exposing (Html)
import Html.Attributes
import Keyboard exposing (Keyboard(..))
import Pcb exposing (Pcb)
import Switch exposing (Switch)


type DisplayedSelection
    = Empty
    | KeyboardSelected Keyboard
    | PcbSelected Keyboard Pcb
    | SwitchSelected Keyboard Pcb Switch


getSelectedKeyboard : DisplayedSelection -> Maybe Keyboard
getSelectedKeyboard displayedSelection =
    case displayedSelection of
        Empty ->
            Nothing

        KeyboardSelected keyboard ->
            Just keyboard

        PcbSelected keyboard _ ->
            Just keyboard

        SwitchSelected keyboard _ _ ->
            Just keyboard


view : DisplayedSelection -> Html msg
view selection =
    let
        keyboard =
            getSelectedKeyboard selection
    in
    Html.section []
        [ Html.select
            []
            [ Html.option [] [ Html.text <| Keyboard.toString Corne ] ]
        ]
