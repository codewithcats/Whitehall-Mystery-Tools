module Main exposing (main)

import Browser
import Browser.Navigation
import Game
import Html
import Platform.Cmd exposing (Cmd)
import RandomDiscoveryLocation
import Route
import Url
import Url.Parser


type State
    = RandomDiscoveryLocation RandomDiscoveryLocation.Model
    | Game Game.Model


type alias Model =
    { key : Browser.Navigation.Key
    , state : State
    }


init : () -> Url.Url -> Browser.Navigation.Key -> ( Model, Cmd Msg )
init _ url key =
    onUrlChange key url


onUrlChange : Browser.Navigation.Key -> Url.Url -> ( Model, Cmd Msg )
onUrlChange key url =
    Url.Parser.parse Route.route_parser url
        |> Maybe.map
            (\parsed ->
                case parsed of
                    Route.RandomDiscoveryLocation ->
                        init_with_random_discovery_location key

                    Route.Game ->
                        init_with_game key
            )
        |> Maybe.withDefault (init_with_random_discovery_location key)


init_with_random_discovery_location : Browser.Navigation.Key -> ( Model, Cmd Msg )
init_with_random_discovery_location key =
    RandomDiscoveryLocation.init
        |> Tuple.mapBoth
            (RandomDiscoveryLocation >> Model key)
            (Cmd.map RandomDiscoveryLocationMsg)


init_with_game : Browser.Navigation.Key -> ( Model, Cmd Msg )
init_with_game key =
    Game.init
        |> Tuple.mapBoth
            (Game >> Model key)
            (Cmd.map GameMsg)


type Msg
    = RandomDiscoveryLocationMsg RandomDiscoveryLocation.Msg
    | GameMsg Game.Msg
    | UrlRequested Browser.UrlRequest
    | UrlChanged Url.Url


update : Msg -> Model -> ( Model, Cmd Msg )
update msg ({ state, key } as model) =
    case ( state, msg ) of
        ( RandomDiscoveryLocation r_model, RandomDiscoveryLocationMsg r_msg ) ->
            RandomDiscoveryLocation.update r_msg r_model
                |> Tuple.mapBoth (RandomDiscoveryLocation >> Model key) (Cmd.map RandomDiscoveryLocationMsg)

        ( _, UrlChanged url ) ->
            onUrlChange key url

        _ ->
            ( model, Cmd.none )


start_game : RandomDiscoveryLocation.Model -> ( Game.Model, Cmd Game.Msg )
start_game r_model =
    Game.init


view : Model -> Browser.Document Msg
view { state, key } =
    { title = "Whitehall Mystery"
    , body =
        [ case state of
            RandomDiscoveryLocation r_model ->
                RandomDiscoveryLocation.view key r_model
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
