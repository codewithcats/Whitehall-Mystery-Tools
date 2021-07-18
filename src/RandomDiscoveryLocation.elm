module RandomDiscoveryLocation exposing (Model, Msg, init, update, view)

import Array
import ArrayX
import Buttons
import Html exposing (..)
import Html.Attributes as Attr
import Html.Events exposing (onClick)
import Icons
import Platform.Cmd exposing (Cmd)
import Random


top_left_locations : Array.Array Int
top_left_locations =
    List.concat [ List.range 1 3, List.range 8 18, List.range 28 36, List.range 48 55, List.range 68 72 ]
        |> Array.fromList


top_right_locations : Array.Array Int
top_right_locations =
    List.concat [ List.range 5 7, List.range 23 27, List.range 42 47, List.range 60 67, List.range 77 79 ]
        |> Array.fromList


bottom_left_locations : Array.Array Int
bottom_left_locations =
    List.concat [ List.range 117 123, List.range 134 137, [ 139 ], [ 152, 153 ], [ 155, 156 ], [ 159 ], [ 161 ], [ 173 ], List.range 175 178, [ 189 ] ]
        |> Array.fromList


bottom_right_locations : Array.Array Int
bottom_right_locations =
    List.concat [ [ 129, 130 ], [ 132, 133 ], [ 142 ], List.range 145 151, [ 165 ], List.range 168 172, [ 183 ], List.range 185 188 ]
        |> Array.fromList


locations : Array.Array (Array.Array Int)
locations =
    Array.fromList
        [ top_left_locations
        , top_right_locations
        , bottom_left_locations
        , bottom_right_locations
        ]


type Model
    = Model (Array.Array Int)


init : ( Model, Cmd Msg )
init =
    ( Model (Array.fromList []), Cmd.none )


type Msg
    = RandomClicked
    | RandomLocationReceived Int Int
    | ShuffleIndexesReceived (List ( Int, Int ))


update : Msg -> Model -> ( Model, Cmd Msg )
update msg ((Model discovery_locations) as model) =
    case msg of
        RandomClicked ->
            Tuple.mapSecond (always <| Cmd.batch <| List.indexedMap generate_next_location <| Array.toList locations) init

        RandomLocationReceived index location_index ->
            let
                updated_discovery_locations =
                    Array.get index locations
                        |> Maybe.andThen (Array.get location_index)
                        |> Maybe.withDefault -1
                        |> (\location_number -> Array.push location_number discovery_locations)
            in
            ( Model updated_discovery_locations
            , if Array.length updated_discovery_locations == 4 then
                generate_shuffle_indexes

              else
                Cmd.none
            )

        ShuffleIndexesReceived indexes ->
            ( Model (ArrayX.shuffle indexes discovery_locations), Cmd.none )


generate_next_location : Int -> Array.Array Int -> Cmd Msg
generate_next_location i l =
    Random.generate (RandomLocationReceived i) (Random.int 0 (Array.length l - 1))


locations_index_generator : Random.Generator Int
locations_index_generator =
    Random.int 0 (Array.length locations - 1)


generate_shuffle_indexes : Cmd Msg
generate_shuffle_indexes =
    Random.generate ShuffleIndexesReceived (Random.list (Array.length locations) (Random.pair locations_index_generator locations_index_generator))


view : Model -> Html Msg
view (Model discovery_locations) =
    div []
        [ Buttons.with_leading_icon
            [ onClick RandomClicked ]
            Icons.dice
            "Random"
        , p [] [ text <| String.join " " <| List.map String.fromInt <| Array.toList discovery_locations ]
        ]
