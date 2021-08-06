module Game exposing
    ( Model
    , Msg
    , init
    , view
    )

import DiscoveryLocation exposing (DiscoveryLocation)
import Html exposing (..)


type Model
    = Model State


type State
    = PickDiscoveryLocation DiscoveryLocation
    | PlayRound Int


type Msg
    = Ignored


init : ( Model, Cmd Msg )
init =
    ( Model (PickDiscoveryLocation DiscoveryLocation.init), Cmd.none )


view : Model -> Html msg
view _ =
    div [] []
