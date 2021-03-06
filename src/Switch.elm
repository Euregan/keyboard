module Switch exposing (..)

import Assets exposing (SwitchAssets)
import BoundingBox3d exposing (BoundingBox3d)
import Color
import Http
import Length exposing (Meters)
import LoadState exposing (LoadState(..))
import Mesh exposing (Mesh)
import Obj.Decode exposing (ObjCoordinates)
import Scene3d.Material


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


load : Switch -> SwitchAssets -> (Switch -> Result Http.Error Mesh -> msg) -> Cmd msg
load switch assets msg =
    case switch of
        CherryMx ->
            Http.get
                { url = assets.cherryMx
                , expect =
                    Obj.Decode.expectObj (msg switch)
                        Length.meters
                        (Obj.Decode.map
                            (\constructor ->
                                constructor
                                    (Scene3d.Material.constant Color.blue)
                                    (Scene3d.Material.constant 0)
                            )
                            Mesh.decoder
                        )
                }


mesh : Switches -> Switch -> LoadState Mesh
mesh switches switch =
    case switch of
        CherryMx ->
            switches.cherryMx
