module Mesh exposing (..)

import Angle
import Animation
import Array
import BoundingBox3d exposing (BoundingBox3d)
import Length exposing (Meters)
import Obj.Decode exposing (Decoder, ObjCoordinates)
import Point3d exposing (Point3d)
import Position
import Scene3d.Mesh exposing (Textured)
import TriangularMesh exposing (TriangularMesh)


type alias Mesh =
    { aimation : Animation.State
    , mesh : Textured ObjCoordinates
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
            Mesh
                (Animation.start (Animation.init (Position.new 0 0 0) (Angle.degrees 0)) 0 350 (Position.new 0 0 0) (Angle.degrees 0))
                (createMesh triangularMesh)
                (case List.map getPosition (Array.toList (TriangularMesh.vertices triangularMesh)) of
                    first :: rest ->
                        BoundingBox3d.hull first rest

                    [] ->
                        BoundingBox3d.singleton Point3d.origin
                )
        )
