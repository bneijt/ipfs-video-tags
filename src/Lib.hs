module Lib (
    loadFromIpfs
) where
import Data.Text
import Reader (readTagInformation)
import Data.Aeson (encode)
import qualified Models as M
import Client
import Control.Exception
import System.Directory (removeFile)
import qualified Data.ByteString.Lazy as LBS
import System.IO

-- | Load from the local IPFS gateway the tag information
loadFromIpfs :: String -> IO (Either String M.TrackInformation)
loadFromIpfs cid = bracket
    (do 
        chunk <- readInitialChunk cid
        (path, handle) <- openTempFile "/tmp" "cid.bin"
        LBS.hPut handle chunk
        hClose handle
        return path
    )
    removeFile
    readTagInformation
