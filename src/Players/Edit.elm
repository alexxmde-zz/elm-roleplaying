module Players.Edit exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class, value, href, type_)
import Html.Events exposing (onClick, onInput)
import Msgs exposing (Msg)
import Models exposing (Player, IsUpdate)
import Routing exposing (playersPath, newPlayerPath)


view : IsUpdate -> Player -> Html Msg
view isUpdate model =
  div []
      [ nav model
      , form isUpdate model
      ]

nav : Player -> Html Msg
nav model =
  div [ class "clearfix mb2 white bg-black p1" ]
      [ listBtn ]

form : IsUpdate -> Player -> Html Msg
form isUpdate player = 
  let 
      onNameChange newName =
        Msgs.OnPlayerNameChange player newName
  in
  div [ class "m3" ]
      [ h1 [] [ text player.id ],
        input  [ type_ "text", onInput onNameChange, value player.name ]
               []
      , formLevel isUpdate player
      ]
formLevel : IsUpdate -> Player -> Html Msg
formLevel isUpdate player = 
  div 
    [ class "clearfix py1"
    ]
    [ div [ class "col col-5" ] [ text "Level" ]
    , div [ class "col col-7" ]
          [ span [ class "h2 bold" ] [ text (toString player.level) ]
          , btnLevelDecrease player
          , btnLevelIncrease player
          ]
    , div [ class "col col-4" ] 
          [ btnSave isUpdate player ]
    ]
btnLevelDecrease : Player -> Html Msg
btnLevelDecrease player =
  let
      message =
        Msgs.ChangeLevel player -1
  in
      a [ class "btn ml1 h1", onClick message ]
        [ i [ class "fa fa-minus-circle" ] [] ]

btnLevelIncrease : Player -> Html Msg
btnLevelIncrease player =
  let
      message =
        Msgs.ChangeLevel player 1
  in
      a [ class "btn ml1 h1", onClick message ]
        [ i [ class "fa fa-plus-circle" ] [] ]

listBtn : Html Msg
listBtn =
  a
    [ class "btn regular"
    , href playersPath
    ]
    [ i [ class "fa fa-chevron-left mr1" ] []
    , text "List"
    ]

btnSave : IsUpdate -> Player -> Html Msg
btnSave isUpdate player =
  let
      message =
        Msgs.SavePlayer isUpdate player
  in
      button [ onClick message ]
             [ text "Save" ]
      
