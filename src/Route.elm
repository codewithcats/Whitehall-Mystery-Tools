module Route exposing (Route(..), route_parser)

import Url.Parser exposing (map, oneOf, s, top)


type Route
    = RandomDiscoveryLocation


route_parser : Url.Parser.Parser (Route -> c) c
route_parser =
    oneOf
        [ map RandomDiscoveryLocation (s "random-discovery-location")
        , map RandomDiscoveryLocation top
        ]
