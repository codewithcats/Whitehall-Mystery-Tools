module Icons exposing (..)

import Html exposing (..)
import Html.Attributes as Attr
import Svg exposing (path, svg)
import Svg.Attributes as SvgAttr


dice : Svg.Svg msg
dice =
    svg
        [ SvgAttr.viewBox "0 0 192 192"
        ]
        [ Svg.g
            []
            [ Svg.g
                [ SvgAttr.fill "currentColor" ]
                [ path
                    [ SvgAttr.d "m97.373 65.775a31.8 31.8 0 0 1 14.627-8.366v-41.409a16 16 0 0 0 -16-16h-72a16 16 0 0 0 -16 16v72a16 16 0 0 0 16 16h35.148zm-17.373-41.775a8 8 0 1 1 -8 8 8 8 0 0 1 8-8zm0 32a8 8 0 1 1 -8 8 8 8 0 0 1 8-8zm-40-32a8 8 0 1 1 -8 8 8 8 0 0 1 8-8zm0 56a8 8 0 1 1 8-8 8 8 0 0 1 -8 8z"
                    ]
                    []
                , path
                    [ SvgAttr.d "m176.568 111.03-40.936-40.937a15.974 15.974 0 0 0 -4.685-3.257c-10.131-4.593-20.844-2.479-27.917 4.6l-40.937 40.932a15.974 15.974 0 0 0 -3.257 4.685c-4.593 10.131-2.479 20.844 4.6 27.917l40.936 40.937a15.974 15.974 0 0 0 4.685 3.257c10.131 4.593 20.844 2.479 27.917-4.6l40.937-40.936a15.974 15.974 0 0 0 3.257-4.685c4.589-10.127 2.475-20.843-4.6-27.913zm-56.568 24.97a8 8 0 1 1 8-8 8 8 0 0 1 -8 8z"
                    ]
                    []
                ]
            ]
        ]


play_solid : Svg.Svg msg
play_solid =
    svg
        [ SvgAttr.fill "currentColor"
        , SvgAttr.viewBox "0 0 20 20"
        ]
        [ path
            [ SvgAttr.fillRule "evenodd"
            , SvgAttr.d "M10 18a8 8 0 100-16 8 8 0 000 16zM9.555 7.168A1 1 0 008 8v4a1 1 0 001.555.832l3-2a1 1 0 000-1.664l-3-2z"
            , SvgAttr.clipRule "evenodd"
            ]
            []
        ]
