module Commands exposing (..)

import Http
import Json.Decode as Decode
import Json.Decode.Pipeline exposing (decode, required)
import Msgs exposing (Msg)
import Models exposing (PlayerId, Player, IsUpdate)
import RemoteData
import Json.Encode as Encode
import RemoteData exposing (WebData)


fetchPlayers : Cmd Msg
fetchPlayers = 
  Http.get fetchPlayersUrl playersDecoder
    |> RemoteData.sendRequest
    |> Cmd.map Msgs.OnFetchPlayers

fetchPlayersUrl : String
fetchPlayersUrl = 
  "http://localhost:4000/players"

savePlayerUrl : PlayerId -> String
savePlayerUrl playerId =
  "http://localhost:4000/players/" ++ playerId
newPlayerUrl : String
newPlayerUrl =
  "http://localhost:4000/players"

savePlayerRequest : Bool -> Player -> Http.Request Player
savePlayerRequest isUpdate player =
  let
      method =
        if isUpdate then
           "PATCH"
        else
          "POST"
      url =
        if player.id == "" then
           newPlayerUrl
        else
          savePlayerUrl player.id
    in
      Http.request
       { body = playerEncoder player |> Http.jsonBody
       , expect = Http.expectJson playerDecoder
       , headers = []
       , method = method
       , timeout = Nothing
       , url = url
       , withCredentials = False
       }



savePlayerCmd : IsUpdate -> Player -> Cmd Msg
savePlayerCmd isUpdate player = 
  savePlayerRequest  isUpdate player
    |> Http.send Msgs.OnPlayerSave

playerEncoder : Player -> Encode.Value
playerEncoder player =
  let attributes = 
    [ ("id", Encode.string player.id )
    , ("name", Encode.string player.name )
    , ("level", Encode.int player.level )
    ]
  in
     Encode.object attributes


playersDecoder : Decode.Decoder (List Player)
playersDecoder = 
  Decode.list playerDecoder

playerDecoder : Decode.Decoder Player
playerDecoder =
  decode Player
    |> required "id" Decode.string
    |> required "name" Decode.string
    |> required "level" Decode.int

generateId : WebData (List Player) -> String
generateId players = 
  case players of 
    RemoteData.Success players ->
        let maybeLastPlayer = 
            List.sortBy .id players
              |> List.reverse
              |> List.head
        in
         case maybeLastPlayer of
           Just lastPlayer ->
             toString 
             (
               (
                 String.toInt lastPlayer.id 
                 |> Result.toMaybe 
                 |> Maybe.withDefault 0
               ) + 1 
             )
           Nothing ->
             "0"
    RemoteData.NotAsked ->
      "0"
    RemoteData.Failure error ->
      toString error
    RemoteData.Loading ->
      "loading"


