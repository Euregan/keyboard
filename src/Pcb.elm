module Pcb exposing (..)

import Angle exposing (Angle)
import Assets exposing (Assets)
import BoundingBox3d exposing (BoundingBox3d)
import Http
import Length exposing (Meters)
import LoadState exposing (LoadState(..))
import Mesh exposing (MeshWithBoundingBox)
import Obj.Decode exposing (ObjCoordinates)
import Vector3d exposing (Vector3d)


type Pcb
    = CorneClassic


type alias Pcbs =
    { corneClassic : LoadState MeshWithBoundingBox
    }


toString : Pcb -> String
toString pcb =
    case pcb of
        CorneClassic ->
            "Classic"


init : Pcbs
init =
    { corneClassic = Pending }


setMesh : Pcbs -> Pcb -> LoadState MeshWithBoundingBox -> Pcbs
setMesh pcbs pcb newMesh =
    case pcb of
        CorneClassic ->
            { pcbs | corneClassic = newMesh }


load :
    Pcb
    -> Assets
    ->
        (Pcb
         -> Result Http.Error MeshWithBoundingBox
         -> msg
        )
    -> Cmd msg
load pcb assets msg =
    case pcb of
        CorneClassic ->
            Http.get
                { url = assets.pcbs.corneClassic.mesh
                , expect = Obj.Decode.expectObj (msg pcb) Length.meters Mesh.decoder
                }


mesh : Pcbs -> Pcb -> LoadState MeshWithBoundingBox
mesh pcbs pcb =
    case pcb of
        CorneClassic ->
            pcbs.corneClassic


switchPositions : Pcb -> List ( Vector3d Meters ObjCoordinates, Angle )
switchPositions pcb =
    case pcb of
        CorneClassic ->
            [ -- First column
              ( Vector3d.centimeters 5.7 0 -0.7, Angle.degrees 0 )
            , ( Vector3d.centimeters 5.7 0 -2.59, Angle.degrees 0 )
            , ( Vector3d.centimeters 5.7 0 1.2, Angle.degrees 0 )

            -- Second column
            , ( Vector3d.centimeters 3.8 0 -0.7, Angle.degrees 0 )
            , ( Vector3d.centimeters 3.8 0 -2.59, Angle.degrees 0 )
            , ( Vector3d.centimeters 3.8 0 1.2, Angle.degrees 0 )

            -- Third column
            , ( Vector3d.centimeters 1.9 0 -0.22, Angle.degrees 0 )
            , ( Vector3d.centimeters 1.9 0 -2.11, Angle.degrees 0 )
            , ( Vector3d.centimeters 1.9 0 1.68, Angle.degrees 0 )

            -- Fourth column
            , ( Vector3d.centimeters 0 0 0, Angle.degrees 0 )
            , ( Vector3d.centimeters 0 0 -1.89, Angle.degrees 0 )
            , ( Vector3d.centimeters 0 0 1.9, Angle.degrees 0 )

            -- Fifth column
            , ( Vector3d.centimeters -1.9 0 -0.22, Angle.degrees 0 )
            , ( Vector3d.centimeters -1.9 0 -2.11, Angle.degrees 0 )
            , ( Vector3d.centimeters -1.9 0 1.68, Angle.degrees 0 )

            -- Sixth column
            , ( Vector3d.centimeters -3.8 0 -0.44, Angle.degrees 0 )
            , ( Vector3d.centimeters -3.8 0 -2.36, Angle.degrees 0 )
            , ( Vector3d.centimeters -3.8 0 1.42, Angle.degrees 0 )

            -- Thumb keys
            , ( Vector3d.centimeters -0.96 0 -4.1, Angle.degrees 0 )
            , ( Vector3d.centimeters -3.05 0 -4.27, Angle.degrees -16 )
            , ( Vector3d.centimeters -5.58 0 -4.98, Angle.degrees 60 )
            ]
