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
    List.concat [ List.range 1 3, List.range 8 18, List.range 28 36, List.range 48 55, [ 68, 69, 71, 72 ] ]
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
    = Model ModelData


type alias ModelData =
    { current_random_index : Int
    , discovery_locations : Array.Array (Array.Array Int)
    , choices_count : Int
    }


init : ( Model, Cmd Msg )
init =
    ( Model
        { current_random_index = 0
        , discovery_locations =
            Array.fromList
                [ Array.empty
                , Array.empty
                , Array.empty
                ]
        , choices_count = 3
        }
    , Cmd.none
    )


type Msg
    = RandomClicked
    | RandomLocationReceived Int Int
    | ShuffleIndexesReceived (List ( Int, Int ))


update : Msg -> Model -> ( Model, Cmd Msg )
update msg ((Model model_data) as model) =
    case msg of
        RandomClicked ->
            Tuple.mapSecond (always <| Cmd.batch <| List.indexedMap generate_next_location <| Array.toList locations) init

        RandomLocationReceived index location_index ->
            let
                updated_choice =
                    Array.get index locations
                        |> Maybe.andThen (Array.get location_index)
                        |> Maybe.withDefault -1
                        |> (\location_number ->
                                Array.push location_number
                                    (Array.get model_data.current_random_index model_data.discovery_locations
                                        |> Maybe.withDefault (Array.fromList [])
                                    )
                           )

                updated_discovery_locations =
                    Array.set model_data.current_random_index updated_choice model_data.discovery_locations
            in
            ( Model { model_data | discovery_locations = updated_discovery_locations }
            , if Array.length updated_choice == 4 then
                generate_shuffle_indexes

              else
                Cmd.none
            )

        ShuffleIndexesReceived indexes ->
            let
                updated_choice =
                    ArrayX.shuffle indexes
                        (Array.get model_data.current_random_index model_data.discovery_locations
                            |> Maybe.withDefault Array.empty
                        )

                updated_discovery_locations =
                    Array.set model_data.current_random_index updated_choice model_data.discovery_locations
            in
            ( Model
                { model_data
                    | discovery_locations = updated_discovery_locations
                    , current_random_index = model_data.current_random_index + 1
                }
            , if model_data.current_random_index == 2 then
                Cmd.none

              else
                Cmd.batch <| List.indexedMap generate_next_location <| Array.toList locations
            )


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
view (Model model_data) =
    div [ Attr.class "h-screen flex flex-col items-center pt-16" ]
        [ h3 [ Attr.class "font-light" ] [ text "Whitehall Mystery Tools" ]
        , h1 [ Attr.class "text-lg text-center font-semibold mb-8" ]
            [ text "Discovery Location Randomizer" ]
        , Buttons.with_leading_icon
            [ onClick RandomClicked ]
            Icons.dice
            "Random"
        , div []
            (Array.map view_choice model_data.discovery_locations |> Array.toList)
        ]


view_choice : Array.Array Int -> Html msg
view_choice choice =
    ul
        [ Attr.class "mt-16 flex space-x-8"
        , Attr.class "transform transition duration-700"
        , Attr.classList
            [ ( "translate-y-0 opacity-1", Array.length choice == 4 )
            , ( "-translate-y-8 opacity-0", Array.length choice /= 4 )
            ]
        ]
        (Array.toList <|
            Array.map
                (\location ->
                    li
                        [ Attr.class "w-10 h-10 bg-gray-100"
                        , Attr.class "flex items-center justify-center"
                        , Attr.class "rounded-full ring-8 ring-gray-100 ring-offset-2 ring-offset-gray-500"
                        , Attr.class "text-gray-600"
                        ]
                        [ text <| String.fromInt location ]
                )
                choice
        )
