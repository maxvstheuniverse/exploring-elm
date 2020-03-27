module Main exposing (main)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, preventDefaultOn)
import Http
import Json.Decode as Decode
import Ports exposing (onUrlChange, pushUrl)
import Route exposing (Route)



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


type Request
    = Failure
    | Loading
    | Success String


type Msg
    = UrlChanged String
    | NavigateTo String
    | Decrement
    | Increment
    | GotText (Result Http.Error String)


type alias Model =
    { route : Route
    , url : String
    , counter : Int
    , request : Request
    }



-- INIT


init : String -> ( Model, Cmd Msg )
init flags =
    ( { route = Route.fromString flags
      , url = flags
      , counter = 0
      , request = Loading
      }
    , Http.get
        { url = "http://localhost:8080/api/get_student_library"
        , expect = Http.expectString GotText
        }
    )



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UrlChanged url ->
            ( { model | route = Route.fromString url, url = url }, Cmd.none )

        NavigateTo path ->
            ( model, pushUrl path )

        GotText result ->
            case result of
                Ok fullText ->
                    ( { model | request = Success fullText }, Cmd.none )

                Err _ ->
                    ( { model | request = Failure }, Cmd.none )

        Decrement ->
            ( { model | counter = model.counter - 1 }, Cmd.none )

        Increment ->
            ( { model | counter = model.counter + 1 }, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    onUrlChange UrlChanged



-- NAVIGATION
-- Decode.succeed skips any decoding and just returns the value. In this case a message to navigate to the given path.


navigationLink : String -> String -> Html Msg
navigationLink path label =
    a [ href path, preventDefaultOn "click" (Decode.succeed ( NavigateTo path, True )) ] [ text label ]



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ text "The current URL is: "
        , b [] [ text model.url ]
        , div []
            [ button [ onClick Decrement ] [ text "-" ]
            , span
                [ style "width" "100px"
                , style "text-align" "center"
                , style "display" "inline-block"
                ]
                [ text (String.fromInt model.counter) ]
            , button [ onClick Increment ] [ text "+" ]
            ]
        , ul [ style "list-style" "none" ]
            [ li [] [ navigationLink "/" "Home" ]
            , li [] [ navigationLink "/profile/max" "Profile" ]
            , li [] [ navigationLink "/reviews/the-century-of-the-self" "The Century of the Self" ]
            , li [] [ navigationLink "/reviews/public-opinion" "Public Opinion" ]
            , li [] [ navigationLink "/reviews/shah-of-shahs" "Shah of Shahs" ]
            , li [] [ navigationLink "/unknown" "This Route Doesn\'t Exist" ]
            ]
        , div []
            [ case model.request of
                Failure ->
                    text "I was unable to load your request."

                Loading ->
                    text "Loading..."

                Success fullText ->
                    pre [] [ text fullText ]
            ]
        ]
