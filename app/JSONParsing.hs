{-# LANGUAGE DeriveGeneric #-} 
{-# LANGUAGE OverloadedStrings #-}

module JSONParsing where

-- Libraries and modules
import qualified Data.ByteString.Lazy.Char8 as C
import Network.HTTP.Conduit (simpleHttp)
import Control.Monad
import Data.Aeson
import Data.Text

data JSONResponse = JSONResponse
    { userResponse :: UserResponse
    } deriving (Show)

data UserResponse = UserResponse
    { gameCount :: Int
    , listOfGames :: [Game]
    } deriving (Show)

data Game = Game
    { appidGame :: Int
    , nameGame :: Text
    , playtimeForeverGame :: Int
    , imgIconURLGame :: Text
    , imgLogoURLGame :: Text
    , playtimeWindowsForeverGame :: Maybe Int
    , playtimeMACForeverGame :: Maybe Int
    , playtimeLinuxForeverGame :: Maybe Int
    , hasCommunityVisibleStatsGame :: Maybe Bool
    , playtimeMACForeveRGame :: Maybe Int
    , playtime2WeeksGame :: Maybe Int
    } deriving (Show)

instance FromJSON JSONResponse where
    parseJSON (Object v) = JSONResponse
        <$> v .: "response"

instance FromJSON UserResponse where
    parseJSON (Object v) = UserResponse
        <$> v .: "game_count"
        <*> v .: "games"

instance FromJSON Game where
    parseJSON (Object v) = Game
        <$> v .: "appid"
        <*> v .: "name"
        <*> v .: "playtime_forever"
        <*> v .: "img_icon_url"
        <*> v .: "img_logo_url"
        <*> v .:? "playtime_windows_forever"
        <*> v .:? "playtime_mac_forever"
        <*> v .:? "playtime_linux_forever"
        <*> v .:? "has_community_visible_stats"
        <*> v .:? "playtime_mac_foreve r"
        <*> v .:? "playtime_2weeks"

apiKey :: String
apiKey = "0786DE3A3F9117713096BAE4347B357A"

axelSteam :: String
axelSteam = "76561198068497293"

createURL :: String -> String
createURL steam64 = ("http://api.steampowered.com/IPlayerService/GetOwnedGames/v0001/?key=" ++ apiKey ++ "&steamid=" ++ steam64 ++ "&include_played_free_games=false&include_appinfo=true")

extractFromJSON :: String -> IO ()
extractFromJSON url = do
    retrieved <- simpleHttp url
    let parsed = eitherDecode retrieved :: Either String JSONResponse
    case parsed of 
        Left err -> putStrLn err
        Right v -> print v
 