module Update exposing (..)

import Msgs exposing (Msg(..))
import Models exposing (Model, Player)
import Routing exposing (parseLocation)
import Commands exposing (savePlayerCmd, generateId)
import RemoteData

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of 
    OnFetchPlayers response ->
      ( { model | players = response }, Cmd.none )
    OnLocationChange location ->
      let
          newRoute =
            parseLocation location
      in
         ( { model | route = newRoute }, Cmd.none )
    ChangeLevel player howMuch ->
      let 
          updatedPlayer =
            { player | level = player.level + howMuch }
      in
          ( { model | player = updatedPlayer }, Cmd.none )
    OnPlayerSave (Ok player) ->
      ( updatePlayer model player, Cmd.none )
    OnPlayerSave (Err error) ->
      ( model, Cmd.none)
    OnPlayerNameChange player newName ->
      let
          updatedPlayer = 
            { player | name = newName }
      in
        ( { model | player = updatedPlayer }, Cmd.none )
    SavePlayer isUpdate player ->
        ( model, savePlayerCmd isUpdate player )
    OnNewPlayerClick ->
      let
          emptyPlayer = {
            id = generateId model.players
          , name = ""
          , level = 0
          }

          isUpdate = 
            True

          newModel = {
            route = model.route
          , players = model.players
          , player = emptyPlayer
          , isUpdate = isUpdate
          }
      in
          (newModel, Cmd.none)
    OnEditPlayerClick player ->
        ( { model | player = player }, Cmd.none )
          
          

        
      
      

updatePlayer : Model -> Player -> Model
updatePlayer model updatedPlayer =
      let 
          pick currentPlayer =
            if updatedPlayer.id == currentPlayer.id then
               updatedPlayer
            else
              currentPlayer

          updatePlayerList players =
            List.map pick players

          updatedPlayers =
            RemoteData.map updatePlayerList model.players
      in
         { model | players = updatedPlayers }
      
