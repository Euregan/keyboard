port module Main exposing (main)

import Angle exposing (Angle)
import Animation exposing (State)
import Array
import Assets exposing (Assets)
import Axis3d
import BoundingBox3d exposing (BoundingBox3d)
import Browser
import Browser.Dom
import Browser.Events
import Camera3d exposing (Camera3d)
import Color exposing (Color)
import DarkMode exposing (DarkMode)
import Direction3d
import Display exposing (Display(..), Viewport)
import Duration exposing (Duration)
import Html exposing (Attribute, Html)
import Html.Attributes
import Html.Events
import Http
import Json.Decode
import Keyboard exposing (Keyboard(..))
import Length exposing (Meters, meters)
import LoadState exposing (LoadState(..))
import Mesh exposing (Mesh)
import Obj.Decode exposing (Decoder, ObjCoordinates)
import Pcb exposing (Pcb(..), Pcbs)
import Pixels exposing (Pixels)
import Point3d exposing (Point3d)
import Position
import Quantity exposing (Quantity)
import Random exposing (Seed)
import Scene3d
import Scene3d.Material exposing (Texture)
import Scene3d.Mesh exposing (Textured, Uniform)
import Selector exposing (DisplayedSelection(..))
import Sphere3d
import Switch exposing (Switch(..), Switches)
import Task
import Texture exposing (Diffuse)
import TriangularMesh exposing (TriangularMesh)
import Vector3d
import Viewpoint3d
import WebGL.Texture


type alias Model =
    { viewport : Viewport
    , assets : Assets
    , pcbMeshes : Pcbs
    , switchMeshes : Switches
    , selected : DisplayedSelection
    , darkMode : DarkMode
    , displayed : Display
    , seed : Seed
    }


type Msg
    = Resize (Quantity Int Pixels) (Quantity Int Pixels)
    | LoadedPcb Pcb (Result String Mesh)
    | LoadedSwitch Switch (Result Http.Error Mesh)
    | Tick Duration
    | ToggleDarkMode


main : Program (Flags Assets) Model Msg
main =
    Browser.element
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }


type alias Flags assets =
    { assets | darkMode : Bool }


init : Flags Assets -> ( Model, Cmd Msg )
init flags =
    let
        getViewport =
            Task.perform
                (\{ viewport } ->
                    Resize
                        (Pixels.int (round viewport.width))
                        (Pixels.int (round viewport.height))
                )
                Browser.Dom.getViewport

        ( display, seed ) =
            Display.init CorneClassic (Random.initialSeed 42)
    in
    ( { viewport =
            { width = Quantity.zero
            , height = Quantity.zero
            }
      , assets = { pcbs = flags.pcbs, switches = flags.switches }
      , pcbMeshes = Pcb.init
      , switchMeshes = Switch.init
      , selected = SwitchSelected Corne CorneClassic CherryMx
      , displayed = display
      , seed = seed
      , darkMode = DarkMode.fromBoolean flags.darkMode
      }
    , Cmd.batch <|
        [ getViewport
        , Switch.load CherryMx flags.switches LoadedSwitch
        , Pcb.load CorneClassic flags.pcbs LoadedPcb
        ]
    )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Browser.Events.onResize (\width height -> Resize (Pixels.int width) (Pixels.int height))
        , Browser.Events.onAnimationFrameDelta (Duration.milliseconds >> Tick)
        ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        LoadedPcb pcb (Ok mesh) ->
            ( { model | pcbMeshes = Pcb.setMesh model.pcbMeshes pcb (Loaded mesh) }
            , Cmd.none
            )

        LoadedPcb pcb (Err error) ->
            ( model
            , Cmd.none
            )

        LoadedSwitch switch (Ok mesh) ->
            ( { model | switchMeshes = Switch.setMesh model.switchMeshes switch (Loaded mesh) }
            , Cmd.none
            )

        LoadedSwitch switch (Err error) ->
            ( model
            , Cmd.none
            )

        Resize width height ->
            ( { model | viewport = { width = width, height = height } }, Cmd.none )

        Tick delta ->
            ( { model
                | displayed = Display.update (Duration.inMilliseconds delta) model.displayed
                , darkMode = DarkMode.tick (Duration.inMilliseconds delta) model.darkMode
              }
            , Cmd.none
            )

        ToggleDarkMode ->
            let
                mode =
                    DarkMode.toggle model.darkMode
            in
            ( { model | darkMode = mode }, toggleDarkMode <| DarkMode.toBoolean mode )


port toggleDarkMode : Bool -> Cmd msg


areMeshesLoaded pcbMeshes switches =
    case ( pcbMeshes.corneClassic, switches.cherryMx ) of
        ( Loaded _, Loaded _ ) ->
            True

        _ ->
            False


view : Model -> Html Msg
view model =
    Html.main_
        [ Html.Attributes.style "overflow" "hidden" ]
        [ case model.selected of
            Empty ->
                Html.text "Select a keyboard"

            KeyboardSelected _ ->
                Html.text "Select a PCB"

            PcbSelected _ _ ->
                Html.text "Select a switch"

            SwitchSelected keyoard pcb switch ->
                Display.view
                    model.darkMode
                    model.viewport
                    pcb
                    (Pcb.mesh model.pcbMeshes pcb)
                    (Switch.mesh model.switchMeshes switch)
                    model.displayed
        , Selector.view model.selected ToggleDarkMode
        ]
