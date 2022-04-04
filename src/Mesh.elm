module Mesh exposing (..)

import Angle
import Animation
import Array
import BoundingBox3d exposing (BoundingBox3d)
import Color
import Length exposing (Meters)
import Obj.Decode exposing (Decoder, ObjCoordinates)
import Point3d exposing (Point3d)
import Position
import Scene3d exposing (Entity)
import Scene3d.Material
import Scene3d.Mesh exposing (Textured)
import TriangularMesh exposing (TriangularMesh)


type alias Mesh =
    { mesh : Entity ObjCoordinates
    , boundingBox : BoundingBox3d Meters ObjCoordinates
    }


decoder : Decoder Mesh
decoder =
    Obj.Decode.oneOf
        [ withBoundingBox .position Scene3d.Mesh.texturedFaces Obj.Decode.texturedFaces
        , withBoundingBox .position Scene3d.Mesh.texturedFacets Obj.Decode.texturedTriangles
        ]


withBoundingBox :
    (a -> Point3d Meters ObjCoordinates) -- a function that knows how to extract position of a vertex
    -> (TriangularMesh a -> Textured ObjCoordinates) -- a function that knows how to create a Mesh
    -> Decoder (TriangularMesh a) -- a primitive decoder
    -> Decoder Mesh
withBoundingBox getPosition createMesh =
    Obj.Decode.map
        (\triangularMesh ->
            let
                mesh =
                    createMesh triangularMesh
            in
            Mesh
                (Scene3d.meshWithShadow (Scene3d.Material.matte Color.blue) mesh (Scene3d.Mesh.shadow mesh))
                (case List.map getPosition (Array.toList (TriangularMesh.vertices triangularMesh)) of
                    first :: rest ->
                        BoundingBox3d.hull first rest

                    [] ->
                        BoundingBox3d.singleton Point3d.origin
                )
        )
