module Assets exposing (..)


type alias Assets =
    { pcbs : PcbAssets
    , switches : SwitchAssets
    }


type alias PcbAssets =
    { corneClassic :
        { mesh : String
        , diffuse : String
        , metallic : String
        }
    }


type alias SwitchAssets =
    { cherryMx : String
    }
