module Models exposing (..)

import RemoteData exposing (WebData)
type alias IsUpdate =
  Bool

type alias Model =
  { players : WebData (List Player)
  , route : Route
  , player : Player
  , isUpdate : IsUpdate
  }

initialModel : Route -> Model
initialModel route = 
  { players = RemoteData.Loading
  , route = route
  , player = {
      id = ""
    , name = ""
    , level = 0
  }
  , isUpdate = False

  }

type alias PlayerId =
  String

type alias Player =
  { id: PlayerId
  , name: String
  , level: Int
  }

type Route 
  = PlayersRoute 
  | PlayerRoute PlayerId
  | NewPlayerRoute
  | NotFoundRoute
