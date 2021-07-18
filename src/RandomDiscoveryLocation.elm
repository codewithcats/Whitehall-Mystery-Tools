module RandomDiscoveryLocation exposing (..)

import Buttons
import Html exposing (..)
import Html.Attributes as Attr
import Icons


view : Html msg
view =
    Buttons.with_leading_icon Icons.dice "Random"
