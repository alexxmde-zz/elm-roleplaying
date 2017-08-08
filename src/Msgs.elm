module Msgs exposing (..)

import Models exposing (Player, IsUpdate)
import RemoteData exposing (WebData)
import Navigation exposing (Location)
import Http exposing (..)

type Msg =
  OnFetchPlayers (WebData (List Player))
  | OnLocationChange Location
  | OnPlayerSave (Result Http.Error Player)
  | ChangeLevel Player Int
  | OnPlayerNameChange Player String 
  | SavePlayer IsUpdate Player
  | OnNewPlayerClick
  | OnEditPlayerClick Player

