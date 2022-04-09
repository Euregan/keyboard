module Assets exposing (..)


type alias Assets =
    { pcbs :
        { corneClassic :
            { mesh : String
            , diffuse : String
            , metallic : String
            }
        }
    , switches :
        { cherryMx : String
        }
    }
