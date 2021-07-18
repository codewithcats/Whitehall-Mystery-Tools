module ArrayX exposing (..)

import Array


shuffle : List ( Int, Int ) -> Array.Array a -> Array.Array a
shuffle swapIndexes array =
    List.foldl (\( i, j ) acc -> swap i j acc) array swapIndexes


swap : Int -> Int -> Array.Array a -> Array.Array a
swap i j array =
    let
        i_value =
            Array.get i array

        j_value =
            Array.get j array
    in
    Maybe.map (\v -> Array.set j v array) i_value
        |> Maybe.andThen (\result -> Maybe.map (\v -> Array.set i v result) j_value)
        |> Maybe.withDefault array
