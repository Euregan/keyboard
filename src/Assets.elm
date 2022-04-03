module Assets exposing (..)


type alias Assets =
    { pcbs :
        { corneClassic :
            { mesh : String
            , texture : String
            }
        }
    , switches :
        { cherryMx : String
        }
    }
