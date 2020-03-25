module Main exposing (main)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, preventDefaultOn)
import Json.Decode as Decode
import Url
import Url.Parser as Parser exposing ((</>))

import Ports exposing (onUrlChange, pushUrl)

-- Application

main : Program String Model Msg
main =
  Browser.element
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }


-- MODEL
type alias Model =
    { location : Location
    , counter : Int }


-- INIT

init : String -> (Model, Cmd Msg)
init flags =
  ({ location = toLocation flags, counter = 0 }, Cmd.none)


-- UPDATE

type Msg
    = UrlChanged Location
    | NavigateTo String
    | Decrement
    | Increment


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UrlChanged newLocation ->
            ( { model | location = newLocation } , Cmd.none )

        NavigateTo path ->
            ( model, pushUrl path )

        Decrement ->
            ( { model | counter = model.counter - 1} , Cmd.none )

        Increment ->
            ( { model | counter = model.counter + 1} , Cmd.none )


-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
    onUrlChange (toLocation >> UrlChanged)


-- NAVIGATION & ROUTING

type alias Location =
    { route : Route
    , url : String
    }


type Route
  = Home
  | Profile
  | Review String
  | NotFound


routeParser : Parser.Parser (Route -> a) a
routeParser =
  Parser.oneOf
    [ Parser.map Home Parser.top
    , Parser.map Profile (Parser.s "profile")
    , Parser.map Review (Parser.s "reviews" </> Parser.string)
    ]


toLocation : String -> Location
toLocation string =
  case Url.fromString string of
    Nothing ->
        { route = NotFound, url = "" }

    Just url ->
        { route = Maybe.withDefault NotFound (Parser.parse routeParser url), url = Url.toString url }


-- Decode.succeed skips any decoding and just returns the value. In this case a message to navigate to the given path.
navigationLink : String -> String -> Html Msg
navigationLink path label =
    a [ href path, preventDefaultOn "click" (Decode.succeed(NavigateTo path, True)) ] [ text label ]


-- VIEW

view : Model -> Html Msg
view model =
    div []
        [ text "The current URL is: "
        , b [] [ text model.location.url ]
        , div []
            [ button [ onClick Decrement] [ text "-" ]
            , span [ style "width" "100px"
                   , style "text-align" "center"
                   , style "display" "inline-block"
                   ] [ text (String.fromInt model.counter) ]
            , button [ onClick Increment ] [ text "+" ]
            ]
        , ul [ style "list-style" "none"]
            [ li [] [ navigationLink "/" "Home" ]
            , li [] [ navigationLink "/profile" "Profile" ]
            , li [] [ navigationLink "/reviews/the-century-of-the-self" "The Century of the Self" ]
            , li [] [ navigationLink "/reviews/public-opinion" "Public Opinion" ]
            , li [] [ navigationLink "/reviews/shah-of-shahs" "Shah of Shahs" ]
            ]
        ]

