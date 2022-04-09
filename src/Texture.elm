module Texture exposing (..)

import Color exposing (Color)
import Scene3d.Material


type alias Diffuse =
    Scene3d.Material.Texture Color


type alias Metallic =
    Scene3d.Material.Texture Float
