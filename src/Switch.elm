module Switch exposing (..)

import Assets exposing (Assets)
import BoundingBox3d exposing (BoundingBox3d)
import Http
import Length exposing (Meters)
import LoadState exposing (LoadState(..))
import Mesh exposing (Mesh)
import Obj.Decode exposing (ObjCoordinates)


type Switch
    = CherryMx


type alias Switches =
    { cherryMx : LoadState Mesh
    }


toString : Switch -> String
toString switch =
    case switch of
        CherryMx ->
            "Cherry MX"


init : Switches
init =
    { cherryMx = Pending }


setMesh : Switches -> Switch -> LoadState Mesh -> Switches
setMesh switches switch newMesh =
    case switch of
        CherryMx ->
            { switches | cherryMx = newMesh }


load :
    Switch
    -> Assets
    ->
        (Switch
         -> Result Http.Error Mesh
         -> msg
        )
    -> Cmd msg
load switch assets msg =
    case switch of
        CherryMx ->
            Http.get
                { url = assets.switches.cherryMx
                , expect = Obj.Decode.expectObj (msg switch) Length.meters Mesh.decoder
                }


mesh : Switches -> Switch -> LoadState Mesh
mesh switches switch =
    case switch of
        CherryMx ->
            switches.cherryMx
