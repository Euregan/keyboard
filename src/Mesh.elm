module Mesh exposing (Mesh, decoder)

import Angle
import Animation
import Array
import BoundingBox3d exposing (BoundingBox3d)
import Color
import Length exposing (Meters)
import Obj.Decode exposing (Decoder, ObjCoordinates)
import Point3d exposing (Point3d)
import Position
import Quantity
import Scene3d exposing (Entity)
import Scene3d.Material
import Scene3d.Mesh exposing (Textured)
import Texture exposing (Texture)
import TriangularMesh exposing (TriangularMesh)
import Vector3d


type alias Mesh =
    { mesh : Entity ObjCoordinates
    , boundingBox : BoundingBox3d Meters ObjCoordinates
    }


type alias Vertex =
    { normal : Vector3d.Vector3d Quantity.Unitless ObjCoordinates
    , position : Point3d Meters ObjCoordinates
    , uv : ( Float, Float )
    }


decoder : Decoder (Texture -> Mesh)
decoder =
    Obj.Decode.map initMesh Obj.Decode.texturedFaces


initMesh : TriangularMesh Vertex -> Texture -> Mesh
initMesh triangularMesh texture =
    let
        mesh =
            Scene3d.Mesh.texturedFaces triangularMesh
    in
    Mesh
        (Scene3d.meshWithShadow (Scene3d.Material.texturedMatte texture) mesh (Scene3d.Mesh.shadow mesh))
        (case List.map .position (Array.toList (TriangularMesh.vertices triangularMesh)) of
            first :: rest ->
                BoundingBox3d.hull first rest

            [] ->
                BoundingBox3d.singleton Point3d.origin
        )
