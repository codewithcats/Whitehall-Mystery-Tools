module Buttons exposing (..)

import Html exposing (..)
import Html.Attributes as Attr
import Svg
import Svg.Attributes as SvgAttr


with_leading_icon : List (Attribute msg) -> Html msg -> String -> Html msg
with_leading_icon attrs icon button_text =
    button
        (List.append
            [ Attr.type_ "button"
            , Attr.class "inline-flex items-center px-4 py-2 border border-transparent shadow-sm text-sm font-medium rounded-md text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500"
            ]
            attrs
        )
        [ div [ Attr.class "-ml-1 mr-2 h-5 w-5" ] [ icon ]
        , text button_text
        ]
