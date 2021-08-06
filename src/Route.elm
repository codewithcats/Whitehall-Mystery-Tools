module Route exposing (Route(..), route_parser)

import Url.Parser exposing (map, oneOf, s, top)


type Route
    = RandomDiscoveryLocation
    | Game


route_parser : Url.Parser.Parser (Route -> c) c
route_parser =
    oneOf
        [ map RandomDiscoveryLocation (s "random-discovery-location")
        , map Game (s "game")
        , map RandomDiscoveryLocation top
        ]
