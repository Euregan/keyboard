module Position exposing (..)

import Coordinates exposing (WorldCoordinates)
import Length exposing (Meters)
import Point3d exposing (Point3d)
import Vector3d exposing (Vector3d)


type alias Position =
    Point3d Meters WorldCoordinates


new : Float -> Float -> Float -> Position
new x y z =
    Point3d.centimeters x y z


translateZ : Position -> Float -> Position
translateZ position amount =
    translateBy position <| Point3d.centimeters 0 0 amount


translateBy : Position -> Position -> Position
translateBy positionA positionB =
    Point3d.translateBy (Vector3d.fromRecord Length.meters (Point3d.toMeters positionA)) positionB


toRecord : Position -> { x : Float, y : Float, z : Float }
toRecord =
    Point3d.toRecord Length.inCentimeters
