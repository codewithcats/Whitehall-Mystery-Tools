module DiscoveryLocation exposing
    ( DiscoveryLocation
    , init
    , update_locations
    )


type DiscoveryLocation
    = DiscoveryLocation (List Int)


init : DiscoveryLocation
init =
    DiscoveryLocation []


update_locations : List Int -> DiscoveryLocation
update_locations locations =
    DiscoveryLocation locations
