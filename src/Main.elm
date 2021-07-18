module Main exposing (main)

import Browser
import Html exposing (Html)
import Platform.Cmd exposing (Cmd)
import RandomDiscoveryLocation


type Model
    = Model RandomDiscoveryLocation.Model


init : () -> ( Model, Cmd Msg )
init _ =
    RandomDiscoveryLocation.init
        |> Tuple.mapBoth Model (Cmd.map RandomDiscoveryLocationMsg)


type Msg
    = RandomDiscoveryLocationMsg RandomDiscoveryLocation.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg (Model random_discovery_location) =
    case msg of
        RandomDiscoveryLocationMsg r_msg ->
            RandomDiscoveryLocation.update r_msg random_discovery_location
                |> Tuple.mapBoth Model (Cmd.map RandomDiscoveryLocationMsg)


view : Model -> Html Msg
view (Model random_discovery_location) =
    RandomDiscoveryLocation.view random_discovery_location
        |> Html.map RandomDiscoveryLocationMsg


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }
