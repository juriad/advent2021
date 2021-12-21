module Main where

import Prelude {- (Unit, bind, map, pure, ($), mod, (+), (-)) -}

import Effect (Effect)
import Effect.Console (logShow)

import Node.Encoding (Encoding(..))
import Node.FS.Sync (readTextFile)

import Data.Int (fromString)
import Data.String (Pattern(..), split, trim)
import Data.Maybe (Maybe(..), fromJust, maybe)
import Data.Array ((!!), head, tail, snoc, any, concat, all, filter)

import Data.Foldable (foldl)
import Data.HashMap (HashMap, alter, empty, singleton, toArrayBy, keys)
import Data.Hashable (class Hashable)

import Data.BigInt (BigInt, fromInt)

import Data.Tuple (Tuple(..))

import Partial.Unsafe (unsafePartial)

type Player =
    { number :: Int
    , position :: Int
    , score :: Int
    }

parsePlayer :: String -> Player
parsePlayer line = unsafePartial $ fromJust $ do
    pns <- arr !! 1
    pn <- fromString pns
    pps <- arr !! 4
    pp <- fromString pps
    pure { number: pn, position: pp, score: 0 }
    where
        arr = split (Pattern " ") line

parsePlayers :: String -> Array Player
parsePlayers content = map parsePlayer (split (Pattern "\n") content)

round0 :: Player -> Int -> Int -> Player
round0 player r mul = { number: player.number, position: p, score: player.score + p * mul }
    where p = ((player.position + r - 1) `mod` 10) + 1

round100 :: Array Player -> Int -> Array Player
round100 players r = unsafePartial $ fromJust $ do
    f <- head players
    t <- tail players
    pure (snoc t (round0 f r 1))

won1000 :: Array Player -> Boolean
won1000 players = any (\p -> p.score >= 1000) players

type Die =
    { next :: Int
    , rolled :: Int
    }

roll :: Die -> Tuple Int Die
roll die = Tuple die.next {next: (die.next `mod` 100) + 1, rolled: die.rolled + 1}

roll3 :: Die -> Tuple Int Die
roll3 d0 = Tuple (r1 + r2 + r3) d3
    where
        Tuple r1 d1 = roll d0
        Tuple r2 d2 = roll d1
        Tuple r3 d3 = roll d2

play1000 :: Array Player -> Die -> Tuple (Array Player) Die
play1000 players die =
    if (won1000 players) then
        Tuple players die
    else
        play1000 (round100 players r) d
        where
            Tuple r d = roll3 die









type Universe = HashMap (Tuple Player Player) BigInt

initialUniverse :: Array Player -> Universe
initialUniverse players = unsafePartial $ fromJust $ do
    p1 <- players !! 0
    p2 <- players !! 1
    pure (singleton (Tuple p1 p2) (fromInt 1))

pushRoll :: Universe -> Int -> Int -> Array (Tuple (Tuple Player Player) BigInt)
pushRoll universe r mul = map (\ (Tuple (Tuple p1 p2) u) ->
         if (p1.score < 0) || (p2.score < 0) then
             Tuple (Tuple p1 p2) u
         else
             Tuple (Tuple (round0 p1 r mul) p2) u
     ) $ filter (\ (Tuple (Tuple p1 p2) _) -> p1.score >= 0 && p2.score >= 0)  $ (toArrayBy Tuple universe)

pushRoll0 :: Universe -> Array (Tuple (Tuple Player Player) BigInt)
pushRoll0 universe = filter (\ (Tuple (Tuple p1 p2) _) -> p1.score < 0 || p2.score < 0)  $ (toArrayBy Tuple universe)

mapFromEntries :: forall k. (Hashable k) => Array (Tuple k BigInt) -> HashMap k BigInt
mapFromEntries entries = foldl (\m (Tuple k v) -> alter (\p -> Just (maybe v (\j -> j + v) p)) k m) empty entries

round1 :: Universe -> Int -> Universe
round1 universe mul = mapFromEntries u
    where
        u0 = pushRoll0 universe
        u1 = pushRoll universe 1 mul
        u2 = pushRoll universe 2 mul
        u3 = pushRoll universe 3 mul
        u = concat [u0, u1, u2, u3]

swap :: Universe -> Universe
swap universe = mapFromEntries (toArrayBy (\ (Tuple p1 p2) v -> Tuple (Tuple p2 (
        if (p1.score >= 21) then
            { number: p1.number, position: p1.position, score: -p1.score }
        else
            p1
    )) v) universe)

round3 :: Universe -> Universe
round3 u0 = swap u3
    where
        u1 = round1 u0 0
        u2 = round1 u1 0
        u3 = round1 u2 1


won :: Universe -> Boolean
won universe = all (\ (Tuple p1 p2) -> (p1.score < 0) || (p2.score < 0)) (keys universe)

play :: Universe -> Universe
play universe =
    if (won universe) then
        universe
    else
        play (round3 universe)


main :: Effect Unit
main = do
    content <- readTextFile UTF8 "input"
    let players = parsePlayers $ trim content
    let die = {next: 1, rolled: 0}
    let Tuple players' die' = play1000 players die
    logShow (die'.rolled * (unsafePartial $ fromJust $ players' !! 0).score)

    let u0 = initialUniverse players
    let u = play u0
    let (Tuple s1 s2) = foldl (\ (Tuple a1 a2) (Tuple (Tuple p1 _) v) ->
            if p1.score < 0 then
                Tuple (a1 + v) a2
            else
                Tuple a1 (a2 + v)
        ) (Tuple (fromInt 0) (fromInt 0)) (toArrayBy Tuple u)
    logShow (max s1 s2)
