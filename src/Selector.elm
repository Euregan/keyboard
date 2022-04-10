module Selector exposing (..)

import Html exposing (Html)
import Html.Attributes
import Html.Events
import Keyboard exposing (Keyboard(..))
import Pcb exposing (Pcb(..))
import Switch exposing (Switch(..))


type DisplayedSelection
    = Empty
    | KeyboardSelected Keyboard
    | PcbSelected Keyboard Pcb
    | SwitchSelected Keyboard Pcb Switch


selectedKeyboard : DisplayedSelection -> Maybe Keyboard
selectedKeyboard displayedSelection =
    case displayedSelection of
        Empty ->
            Nothing

        KeyboardSelected keyboard ->
            Just keyboard

        PcbSelected keyboard _ ->
            Just keyboard

        SwitchSelected keyboard _ _ ->
            Just keyboard


card : Html msg -> Html msg
card content =
    Html.div
        [ Html.Attributes.style "padding" "1rem"
        , Html.Attributes.style "font-family" "sans-serif"
        , Html.Attributes.style "color" "white"
        , Html.Attributes.style "border-radius" "0.3rem"
        , Html.Attributes.style "background" "rgba(1, 1, 1, 0.4)"
        , Html.Attributes.style "backdrop-filter" "blur(2px)"
        ]
        [ content ]


view : DisplayedSelection -> msg -> Html msg
view selection toggleDarkMode =
    let
        keyboard =
            selectedKeyboard selection
    in
    Html.section
        [ Html.Attributes.style "position" "absolute"
        , Html.Attributes.style "right" "0"
        , Html.Attributes.style "top" "0"
        , Html.Attributes.style "display" "flex"
        , Html.Attributes.style "flex-direction" "column"
        , Html.Attributes.style "gap" "1rem"
        , Html.Attributes.style "padding" "2rem"
        ]
        [ card <| Html.button [ Html.Events.onClick toggleDarkMode ] [ Html.text "Dark mode" ]
        , card <| Html.text <| Keyboard.toString Corne
        , card <| Html.text <| Pcb.toString CorneClassic
        , card <| Html.text <| Switch.toString CherryMx
        ]
