{-# LANGUAGE DeriveGeneric #-}
module Models
(
    TrackInformation(..)
)
where

import GHC.Generics
import Sound.HTagLib
import Data.Aeson
import Data.Text
  

data TrackInformation = TrackInformation { 
    title   :: Text
    , artist  :: Text
    , album   :: Text
    , genre   :: Text
    , comment :: Text
    , year    :: Maybe Int
    , duration :: Int
} deriving (Generic, Show)

instance ToJSON TrackInformation

instance FromJSON TrackInformation
