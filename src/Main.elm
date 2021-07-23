module Main exposing (main)

import Browser
import Browser.Navigation
import Game
import Html
import Platform.Cmd exposing (Cmd)
import RandomDiscoveryLocation
import Url


type State
    = RandomDiscoveryLocation RandomDiscoveryLocation.Model
    | Game Game.Model


type alias Model =
    { key : Browser.Navigation.Key
    , state : State
    }


init : () -> Url.Url -> Browser.Navigation.Key -> ( Model, Cmd Msg )
init _ url key =
    RandomDiscoveryLocation.init
        |> Tuple.mapBoth
            (RandomDiscoveryLocation >> Model key)
            (Cmd.map RandomDiscoveryLocationMsg)


type Msg
    = RandomDiscoveryLocationMsg RandomDiscoveryLocation.Msg
    | UrlRequested Browser.UrlRequest
    | UrlChanged Url.Url


update : Msg -> Model -> ( Model, Cmd Msg )
update msg ({ state, key } as model) =
    case ( state, msg ) of
        ( RandomDiscoveryLocation r_model, RandomDiscoveryLocationMsg r_msg ) ->
            RandomDiscoveryLocation.update r_msg r_model
                |> Tuple.mapBoth (RandomDiscoveryLocation >> Model key) (Cmd.map RandomDiscoveryLocationMsg)

        _ ->
            ( model, Cmd.none )


view : Model -> Browser.Document Msg
view { state } =
    { title = "Whitehall Mystery"
    , body =
        [ case state of
            RandomDiscoveryLocation r_model ->
                RandomDiscoveryLocation.view r_model
                    |> Html.map RandomDiscoveryLocationMsg

            Game game_model ->
                Game.view game_model
        ]
    }


main : Program () Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        , onUrlRequest = UrlRequested
        , onUrlChange = UrlChanged
        }
