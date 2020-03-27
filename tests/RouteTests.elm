module RouteTests exposing (fromString)

import Expect
import Route exposing (Route)
import Test exposing (..)



-- TESTS


fromString : Test
fromString =
    describe "Route.fromString"
        [ testUrl "/" Route.Home
        , testUrl "/profile/username" (Route.Profile "username")
        , testUrl "/reviews/the-century-of-the-self" (Route.Review "the-century-of-the-self")
        , testUrl "/this/route/does/not/exist" Route.NotFound
        ]



--  HELPERS


httpFoo : String
httpFoo =
    "https://foo.bar"


testUrl : String -> Route -> Test
testUrl path route =
    test ("Generating route from path: \"" ++ path ++ "\"") <|
        \() ->
            httpFoo
                ++ path
                |> Route.fromString
                |> Expect.equal route
