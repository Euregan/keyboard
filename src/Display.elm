module Display exposing (..)

import Angle
import Animation exposing (State)
import Axis3d
import BoundingBox3d
import Camera3d exposing (Camera3d)
import Color
import DarkMode exposing (DarkMode)
import Direction3d
import Html exposing (Html)
import Illuminance
import Length exposing (Meters)
import LoadState exposing (LoadState(..))
import Mesh exposing (Mesh)
import Obj.Decode exposing (ObjCoordinates)
import Pcb exposing (Pcb)
import Pixels exposing (Pixels)
import Point3d
import Position
import Quantity exposing (Quantity)
import Random exposing (Seed)
import Scene3d
import Scene3d.Light
import Scene3d.Material
import Switch exposing (Switch)
import Vector3d
import Viewpoint3d


type Display
    = Idle
        { pcb :
            { state : State
            , pcb : Pcb
            }
        , switches : List { state : State, switch : Switch }
        }


type alias Viewport =
    { width : Quantity Int Pixels
    , height : Quantity Int Pixels
    }


init : Pcb -> Seed -> ( Display, Seed )
init pcb seed =
    let
        switchDelayGenerator =
            Random.float -100 100

        pcbAnimation =
            Animation.start
                (Animation.init (Position.new 0 25 0) (Angle.degrees 0))
                200
                500
                (Position.new 0 0 0)
                (Angle.degrees 0)

        ( switchesAnimation, newSeed ) =
            List.foldl
                (\( position, rotation ) ( animations, previousSeed ) ->
                    let
                        ( delay, seedAfterDelay ) =
                            Random.step switchDelayGenerator previousSeed
                    in
                    ( { state =
                            Animation.startAfter
                                pcbAnimation
                                (Animation.init (Position.new 0 25 0) rotation)
                                (delay - 100)
                                500
                                position
                                rotation
                      , switch = Switch.CherryMx
                      }
                        :: animations
                    , seedAfterDelay
                    )
                )
                ( [], seed )
                (Pcb.switchPositions pcb)
    in
    ( Idle
        { pcb =
            { state = pcbAnimation
            , pcb = pcb
            }
        , switches = switchesAnimation
        }
    , newSeed
    )


update : Float -> Display -> Display
update delta display =
    case display of
        Idle { pcb, switches } ->
            Idle
                { pcb =
                    { state = Animation.update delta pcb.state
                    , pcb = pcb.pcb
                    }
                , switches =
                    List.map
                        (\switch ->
                            { switch | state = Animation.update delta switch.state }
                        )
                        switches
                }


tableMesh : DarkMode -> Scene3d.Entity ObjCoordinates
tableMesh darkMode =
    Scene3d.quadWithShadow
        (Scene3d.Material.matte <| DarkMode.color darkMode)
        (Point3d.xyz (Length.meters -1) (Length.centimeters -0.5) (Length.meters -1))
        (Point3d.xyz (Length.meters 1) (Length.centimeters -0.5) (Length.meters -1))
        (Point3d.xyz (Length.meters 1) (Length.centimeters -0.5) (Length.meters 1))
        (Point3d.xyz (Length.meters -1) (Length.centimeters -0.5) (Length.meters 1))


view : DarkMode -> Viewport -> Pcb -> LoadState Mesh -> LoadState Mesh -> Display -> Html msg
view darkMode viewport pcb pcbResource switchResource displayed =
    let
        distanceFromMesh pcbMesh =
            let
                { minX, maxX, minY, maxY, minZ, maxZ } =
                    BoundingBox3d.extrema pcbMesh.boundingBox
            in
            List.map Quantity.abs [ minX, maxX, minY, maxY, minZ, maxZ ]
                |> List.foldl Quantity.max Quantity.zero
                |> Quantity.multiplyBy 4

        camera =
            let
                ( focalPoint, distance ) =
                    case pcbResource of
                        Loaded pcbMesh ->
                            ( BoundingBox3d.centerPoint pcbMesh.boundingBox, distanceFromMesh pcbMesh )

                        _ ->
                            ( Point3d.centimeters 0 0 0, Length.centimeters 100 )
            in
            Camera3d.perspective
                { viewpoint =
                    Viewpoint3d.orbitZ
                        { focalPoint = focalPoint
                        , azimuth = Angle.degrees 90

                        -- , elevation = Angle.degrees 180
                        , elevation = Angle.degrees -45
                        , distance = distance
                        }
                , verticalFieldOfView = Angle.degrees 30
                }

        placePcbMesh pcbMesh =
            let
                { x, y, z } =
                    case displayed of
                        Idle dis ->
                            Animation.position dis.pcb.state
                                |> Position.toRecord
            in
            pcbMesh.mesh
                |> Scene3d.translateBy (Vector3d.centimeters x y z)

        placeSwitchMeshes switchMesh =
            case displayed of
                Idle dis ->
                    List.map
                        (\{ state } ->
                            let
                                { x, y, z } =
                                    Animation.position state
                                        |> Position.toRecord
                            in
                            switchMesh.mesh
                                |> Scene3d.rotateAround Axis3d.y (Animation.rotation state)
                                |> Scene3d.translateBy (Vector3d.centimeters x y z)
                        )
                        dis.switches

        entities =
            case ( pcbResource, switchResource ) of
                ( Loaded pcbMesh, Loaded switchMesh ) ->
                    tableMesh darkMode
                        :: placePcbMesh pcbMesh
                        :: placeSwitchMeshes switchMesh

                ( Loaded pcbMesh, Pending ) ->
                    [ tableMesh darkMode
                    , placePcbMesh pcbMesh
                    ]

                ( _, _ ) ->
                    [ tableMesh darkMode ]

        sun =
            Scene3d.Light.directional (Scene3d.Light.castsShadows True)
                { direction = Direction3d.xyZ (Angle.degrees -135) (Angle.degrees -20)
                , intensity = Illuminance.lux 80000
                , chromaticity = Scene3d.Light.sunlight
                }

        sky =
            Scene3d.Light.overhead
                { upDirection = Direction3d.z
                , chromaticity = Scene3d.Light.skylight
                , intensity = Illuminance.lux 20000
                }

        environment =
            Scene3d.Light.overhead
                { upDirection = Direction3d.reverse Direction3d.z
                , chromaticity = Scene3d.Light.daylight
                , intensity = Illuminance.lux 15000
                }
    in
    Scene3d.custom
        { lights = Scene3d.threeLights sun sky environment
        , exposure = Scene3d.exposureValue 15
        , toneMapping = Scene3d.noToneMapping
        , whiteBalance = Scene3d.Light.daylight
        , antialiasing = Scene3d.multisampling
        , camera = camera
        , dimensions = ( viewport.width, viewport.height )
        , background = Scene3d.transparentBackground
        , clipDepth = Length.meters 0.1
        , entities = entities
        }
