module Route exposing (Route(..), fromString)

import Url
import Url.Parser as Parser exposing ((</>), Parser, oneOf, s, string)


type Route
    = Home
    | Profile String
    | Review String
    | NotFound


routeParser : Parser (Route -> a) a
routeParser =
    oneOf
        [ Parser.map Home Parser.top
        , Parser.map Profile (s "profile" </> string)
        , Parser.map Review (s "reviews" </> string)
        ]


fromString : String -> Route
fromString maybeUrl =
    case Url.fromString maybeUrl of
        Nothing ->
            NotFound

        Just url ->
            Maybe.withDefault NotFound (Parser.parse routeParser url)
