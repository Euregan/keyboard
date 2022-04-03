module Main exposing (main)

import Angle exposing (Angle)
import Array
import Assets exposing (Assets)
import Axis3d
import BoundingBox3d exposing (BoundingBox3d)
import Browser
import Browser.Dom
import Browser.Events
import Camera3d exposing (Camera3d)
import Color exposing (Color)
import Direction3d
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
import Quantity exposing (Quantity)
import Scene3d
import Scene3d.Material exposing (Texture)
import Scene3d.Mesh exposing (Textured, Uniform)
import Selector exposing (DisplayedSelection(..))
import Sphere3d
import Switch exposing (Switch(..), Switches)
import Task
import TriangularMesh exposing (TriangularMesh)
import Viewpoint3d
import WebGL.Texture exposing (Error(..))


type alias Viewport =
    { width : Quantity Int Pixels
    , height : Quantity Int Pixels
    }


type alias Model =
    { azimuth : Angle
    , elevation : Angle
    , zoom : Float
    , viewport : Viewport
    , assets : Assets
    , pcbMeshes : Pcbs
    , switchMeshes : Switches
    , displayed : DisplayedSelection
    }


type Msg
    = Resize (Quantity Int Pixels) (Quantity Int Pixels)
    | LoadedPcb Pcb (Result Http.Error ( Mesh, BoundingBox3d Meters ObjCoordinates ))
    | LoadedSwitch Switch (Result Http.Error ( Mesh, BoundingBox3d Meters ObjCoordinates ))


main : Program Flags Model Msg
main =
    Browser.element
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }


type alias Flags =
    Assets


init : Flags -> ( Model, Cmd Msg )
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
    in
    ( { azimuth = Angle.degrees 90

      -- , elevation = Angle.degrees 180
      , elevation = Angle.degrees -45
      , zoom = 0
      , viewport =
            { width = Quantity.zero
            , height = Quantity.zero
            }
      , assets = flags
      , pcbMeshes = Pcb.init
      , switchMeshes = Switch.init
      , displayed = SwitchSelected Corne CorneClassic CherryMx
      }
    , Cmd.batch
        [ getViewport
        , Pcb.load CorneClassic flags LoadedPcb
        , Switch.load CherryMx flags LoadedSwitch
        ]
    )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Browser.Events.onResize (\width height -> Resize (Pixels.int width) (Pixels.int height)) ]


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


sphere =
    Scene3d.sphereWithShadow
        (Scene3d.Material.matte Color.blue)
        (Sphere3d.atPoint (Point3d.centimeters 1 2 1) (Length.centimeters 3))


meshView : Camera3d Meters ObjCoordinates -> Viewport -> Pcb -> Mesh -> Mesh -> Html Msg
meshView camera viewport pcb pcbMesh switchMesh =
    let
        switchEntity =
            Scene3d.meshWithShadow (Scene3d.Material.matte Color.blue) switchMesh (Scene3d.Mesh.shadow switchMesh)

        table =
            Scene3d.quadWithShadow
                (Scene3d.Material.matte <| Color.rgb255 201 211 223)
                (Point3d.xyz (Length.meters -1) (Length.centimeters -0.5) (Length.meters -1))
                (Point3d.xyz (Length.meters 1) (Length.centimeters -0.5) (Length.meters -1))
                (Point3d.xyz (Length.meters 1) (Length.centimeters -0.5) (Length.meters 1))
                (Point3d.xyz (Length.meters -1) (Length.centimeters -0.5) (Length.meters 1))

        entities =
            Scene3d.meshWithShadow (Scene3d.Material.matte Color.blue) pcbMesh (Scene3d.Mesh.shadow pcbMesh)
                :: List.map
                    (\( vector, angle ) ->
                        Scene3d.rotateAround Axis3d.y angle switchEntity
                            |> Scene3d.translateBy vector
                    )
                    (Pcb.switchPositions pcb)
    in
    Scene3d.sunny
        { upDirection = Direction3d.z
        , sunlightDirection = Direction3d.xyZ (Angle.degrees -135) (Angle.degrees -20)

        -- , sunlightDirection = Direction3d.xyZ (Angle.degrees 135) (Angle.degrees -20)
        , shadows = True
        , camera = camera
        , dimensions = ( viewport.width, Pixels.int 1200 )
        , background = Scene3d.transparentBackground
        , clipDepth = Length.meters 0.1
        , entities = table :: entities
        }


view : Model -> Html Msg
view model =
    Html.main_
        [ Html.Attributes.style "position" "absolute"
        , Html.Attributes.style "left" "0"
        , Html.Attributes.style "top" "0"
        , Html.Attributes.style "width" "100%"
        , Html.Attributes.style "height" "100%"
        ]
        [ case model.displayed of
            Empty ->
                Html.text "Select a keyboard"

            KeyboardSelected _ ->
                Html.text "Select a PCB"

            PcbSelected _ _ ->
                Html.text "Select a switch"

            SwitchSelected keyoard pcb switch ->
                case ( Pcb.mesh model.pcbMeshes pcb, Switch.mesh model.switchMeshes switch ) of
                    ( Loaded ( pcbMesh, boundingBox ), Loaded ( switchMesh, _ ) ) ->
                        let
                            { minX, maxX, minY, maxY, minZ, maxZ } =
                                BoundingBox3d.extrema boundingBox

                            distance =
                                List.map Quantity.abs [ minX, maxX, minY, maxY, minZ, maxZ ]
                                    |> List.foldl Quantity.max Quantity.zero
                                    |> Quantity.multiplyBy 2
                                    |> Quantity.multiplyBy (2 - model.zoom)

                            camera =
                                Camera3d.perspective
                                    { viewpoint =
                                        Viewpoint3d.orbitZ
                                            { focalPoint = BoundingBox3d.centerPoint boundingBox
                                            , azimuth = model.azimuth
                                            , elevation = model.elevation
                                            , distance = distance
                                            }
                                    , verticalFieldOfView = Angle.degrees 30
                                    }
                        in
                        meshView camera
                            model.viewport
                            pcb
                            pcbMesh
                            switchMesh

                    _ ->
                        Html.text "Loading"
        , Selector.view model.displayed
        ]
