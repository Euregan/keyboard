module Mesh exposing (..)

import Array
import BoundingBox3d exposing (BoundingBox3d)
import Length exposing (Meters)
import Obj.Decode exposing (Decoder, ObjCoordinates)
import Point3d exposing (Point3d)
import Scene3d.Mesh exposing (Textured)
import TriangularMesh exposing (TriangularMesh)


type alias Mesh =
    Textured ObjCoordinates


type alias MeshWithBoundingBox =
    ( Mesh, BoundingBox3d Meters ObjCoordinates )


decoder : Decoder MeshWithBoundingBox
decoder =
    Obj.Decode.oneOf
        [ withBoundingBox .position Scene3d.Mesh.texturedFaces Obj.Decode.texturedFaces
        , withBoundingBox .position Scene3d.Mesh.texturedFacets Obj.Decode.texturedTriangles
        ]


withBoundingBox :
    (a -> Point3d Meters ObjCoordinates) -- a function that knows how to extract position of a vertex
    -> (TriangularMesh a -> Mesh) -- a function that knows how to create a Mesh
    -> Decoder (TriangularMesh a) -- a primitive decoder
    -> Decoder ( Mesh, BoundingBox3d Meters ObjCoordinates )
withBoundingBox getPosition createMesh =
    Obj.Decode.map
        (\triangularMesh ->
            ( createMesh triangularMesh
            , case List.map getPosition (Array.toList (TriangularMesh.vertices triangularMesh)) of
                first :: rest ->
                    BoundingBox3d.hull first rest

                [] ->
                    BoundingBox3d.singleton Point3d.origin
            )
        )
