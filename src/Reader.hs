module Reader (
    readTagInformation
) where

import Data.Monoid
import Sound.HTagLib
import qualified Models as M
import qualified Data.Text as T
import Control.Exception

data TrackTag = TrackTag { 
    atTitle   :: Title
    , atArtist  :: Artist
    , atAlbum   :: Album
    , atComment   :: Comment
    , atGenre   :: Genre
    , atYear    :: Maybe Year
    , atDuration :: Duration
} deriving Show



audioTrackGetter :: TagGetter TrackTag
audioTrackGetter = TrackTag
    <$> titleGetter
    <*> artistGetter
    <*> albumGetter
    <*> commentGetter 
    <*> genreGetter
    <*> yearGetter
    <*> durationGetter



readTagInformation :: FilePath -> IO (Either String M.TrackInformation)
readTagInformation inputFilePath = catch ( do
    track <- getTags' inputFilePath MP4 audioTrackGetter
    return $ Right M.TrackInformation {
        M.title = unTitle (atTitle track),
        M.artist = unArtist (atArtist track),
        M.album  = unAlbum (atAlbum track),
        M.comment  = unComment (atComment track),
        M.genre   = unGenre (atGenre track),
        M.year   = fmap unYear (atYear track),
        M.duration = unDuration (atDuration track)
    }) (\e -> return $ Left (show (e :: HTagLibException))) 