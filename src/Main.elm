module Main exposing (..)

import Html exposing (program)
import Msgs exposing (Msg)
import Models exposing (initialModel, Model)
import Update exposing (update)
import View exposing (view)
import Commands exposing(fetchPlayers)
import Navigation exposing (Location)
import Routing

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none

init : Location -> (Model, Cmd Msg)
init location =
  let 
      currentRoute = 
        Routing.parseLocation location
  in
     ( initialModel currentRoute, fetchPlayers )

-- MAIN

main : Program Never Model Msg
main =
  Navigation.program Msgs.OnLocationChange
  { init = init,
  view = view,
  update = update,
  subscriptions = subscriptions
  }
