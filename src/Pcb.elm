module Pcb exposing (..)

import Assets exposing (Assets)
import BoundingBox3d exposing (BoundingBox3d)
import Http
import Length exposing (Meters)
import LoadState exposing (LoadState(..))
import Mesh exposing (MeshWithBoundingBox)
import Obj.Decode exposing (ObjCoordinates)


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
                { url = assets.pcbs.corneClassic
                , expect = Obj.Decode.expectObj (msg pcb) Length.meters Mesh.decoder
                }


mesh : Pcbs -> Pcb -> LoadState MeshWithBoundingBox
mesh pcbs pcb =
    case pcb of
        CorneClassic ->
            pcbs.corneClassic
