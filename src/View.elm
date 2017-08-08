module View exposing (..)

import Html exposing (Html, div, text)
import Msgs exposing (Msg(..))
import Models exposing (..)

import Players.List
import Players.Edit
import RemoteData

view : Model -> Html Msg

view model =
  div []
  [ page model ]

page : Model -> Html Msg
page model =
  case model.route of
    Models.PlayersRoute ->
      Players.List.view model.players

    Models.PlayerRoute id ->
      playerEditPage model id

    Models.NewPlayerRoute ->
      newPlayerPage model

    Models.NotFoundRoute ->
      notFoundView

playerEditPage : Model -> PlayerId -> Html Msg
playerEditPage model playerId =
  Players.Edit.view model.isUpdate model.player
  
newPlayerPage : Model -> Html Msg
newPlayerPage model =
  let 
      player = model.player
  in
      Players.Edit.view model.isUpdate player
     
notFoundView : Html msg
notFoundView = 
  div []
  [ text "Not found" 
  ]

