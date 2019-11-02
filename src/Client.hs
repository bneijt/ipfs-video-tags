module Client (
    readInitialChunk
) where

import Network.HTTP.Client
import System.IO
import qualified Data.ByteString.Lazy as LBS
import Control.Exception

-- |Read an initial chunk from the given CID into a temporary file
-- if successfull, return the FilePath to the temporary file containing the
-- first chunk of the file
-- first argument is the CID to download
readInitialChunk :: String -> IO LBS.ByteString
readInitialChunk cid = do
    manager <- newManager defaultManagerSettings {managerResponseTimeout = responseTimeoutMicro 5000000}
    request <- parseRequest $ "http://127.0.0.1:8080/ipfs/" ++ cid
    withResponse request manager readChunk

readChunk :: Response BodyReader -> IO LBS.ByteString
readChunk response = brReadSome reader (250*1024)
    where
        reader = responseBody response
   