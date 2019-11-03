{-# LANGUAGE OverloadedStrings #-}

module Main (main) where

import Lib (loadFromIpfs)

import Web.Spock
import Web.Spock.Config

import Control.Monad.Trans
import Data.IORef
import Data.Monoid
import Network.Wai.Middleware.Static
import qualified Data.Text as T
import qualified Data.Text.Lazy.IO as TIO
import Data.Aeson.Text (encodeToLazyText)
import Network.HTTP.Types.Status (notFound404, internalServerError500, badRequest400)
import System.Directory (doesFileExist, createDirectoryIfMissing)
import System.FilePath ((</>))
import Control.Exception

data MySession = EmptySession
data MyAppState = DummyAppState (IORef Int)

main :: IO ()
main = do
    createDirectoryIfMissing False "tags"
    ref <- newIORef 0
    spockCfg <- defaultSpockCfg EmptySession PCNoDatabase (DummyAppState ref)
    runSpock 8081 (spock spockCfg app)

app :: SpockM () MySession MyAppState ()
app = do 
    -- middleware $ staticPolicy (addBase "meta")
    get root $
        text "API is under tags/<cid>\nFor example, try tags/QmcuAfSwwrrMqCvaFXbEZWsWfF7TyPKHocFeNqsSQT5Eie"
    get ("tags" <//> var) $ \cid ->
        if T.length cid == 46
        then do
            let storagePath = ("tags" </> T.unpack cid)
            alreadyAvailable <- liftIO $ doesFileExist storagePath
            if alreadyAvailable
                then file "application/json" storagePath
                else do
                    -- Download first 250KB of file
                    eitherTag <- liftIO $ loadFromIpfs (T.unpack cid)
                    case eitherTag of
                        Right tag -> do
                            liftIO $ TIO.writeFile storagePath (encodeToLazyText tag)
                            json tag
                        Left problem -> do
                            setStatus internalServerError500
                            text (T.pack problem)
        else do
            setStatus badRequest400
            text "Wrong length in CID"