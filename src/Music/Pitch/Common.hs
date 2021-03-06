
------------------------------------------------------------------------------------
-- |
-- Copyright   : (c) Hans Hoglund 2012
--
-- License     : BSD-style
--
-- Maintainer  : hans@hanshoglund.se
-- Stability   : experimental
-- Portability : non-portable (TF,GNTD)
--
-- Provides a representation of pitch as defined in Common Music Theory (CMT).
--
-------------------------------------------------------------------------------------

module Music.Pitch.Common (
    -- * Enharmonic representation
    -- ** Octaves
    Octaves,
    HasOctaves(..),

    -- ** Steps
    Steps,
    HasSteps(..),

    -- ** Semitones
    Semitones,
    HasSemitones(..),
    semitone,
    tone,
    ditone,
    tritone,
    isSemitone,
    isTone,
    isTritone,
    
    -- ** Enharmonic equivalence
    (=:=),
    (/:=),

    -- * Pitches
    -- ** Name type
    Name(..),

    -- ** Accidental  type
    Accidental,
    doubleFlat, 
    flat, 
    natural, 
    sharp, 
    doubleSharp,

    -- *** Inspecting accidentals
    isNatural,
    isSharpened,
    isFlattened,
    isStandard,

    -- ** Pitch type
    Pitch,    
    pitch,
    name,
    accidental,
    asPitch,

    -- module Music.Pitch.Common.Name,
    -- module Music.Pitch.Common.Accidental,
    -- module Music.Pitch.Common.Pitch,

    -- * Intervals
    -- ** Number type
    Number,
    HasNumber(..),   
    unison,
    prime,
    second,
    third,
    fourth,
    fifth,
    sixth,
    seventh,
    octave,
    ninth,
    tenth,
    twelfth, 
    duodecim,
    thirteenth,
    fourteenth,
    fifteenth,

    -- ** Quality type
    Quality(..),    
    HasQuality(..),
    invertQuality,
    isPerfect,
    isMajor,
    isMinor,
    isAugmented,
    isDiminished,

    -- ** Interval type
    Interval,

    -- *** Creating intervals
    interval,
    perfect,
    major,
    minor,
    augmented,
    diminished,
    doublyAugmented,
    doublyDiminished,
    asInterval,

    -- *** Inspecting intervals
    isNegative,
    isPositive,
    isNonNegative,
    isPerfectUnison,
    isStep,
    isLeap,

    -- *** Simple and compound intervals
    isSimple,
    isCompound,
    separate,
    simple,

    -- *** Inversion
    invert,

    -- module Music.Pitch.Common.Number,
    -- module Music.Pitch.Common.Quality,
    -- module Music.Pitch.Common.Interval,

    -- * Miscellaneous
    module Music.Pitch.Common.Spell,
    module Music.Pitch.Common.Harmony,
)
where

import Data.Maybe
import Data.Either
import Data.Semigroup
import Data.VectorSpace
import Data.AffineSpace
import Control.Monad
import Control.Applicative
import qualified Data.List as List

import Music.Pitch.Absolute
import Music.Pitch.Literal
import Music.Pitch.Common.Pitch
import Music.Pitch.Common.Interval
import Music.Pitch.Common.Semitones
import Music.Pitch.Common.Spell
import Music.Pitch.Common.Harmony


{-  
        Semitones is the smallest musical unit (Semitones in Western music)
        
        The `semitones` function retrieves the number of Semitones in a pitch, for example
            semitones :: Interval -> Semitones
            semitones major third = 4

        Note that semitones is surjetive. We can define a non-deterministic function `spellings`
            spellings :: Semitones -> [Interval]
            spellings 4 = [majorThird, diminishedFourth]
        Law
            map semitones (spellings a) = replicate n a    for all n > 0
        Lemma
            map semitones (spellings a)
        

        isHemitonic   [1,2,2] = True
        isHemitonic   [2,2,2] = False
        isCohemitonic [1,1,2] = True
        isCohemitonic [1,2,1] = False
        isTritonic ...
        
        A Scale is a [Semitones], for example [2,2,1,2,2,2,1]
            From this we can derive       [2,4,5,7,9,11,12]
        A Scale is a function (Number -> Interval)
        A Scale is a function (Number -> Semitones)

        -- TODO simplify etc
        isMelodicDissonance :: Interval -> Bool


    "Post-tonal"
    
        Messiaen
        
        mode1 = [2,2,2,2,2]
        mode2 = [1,2, 1,2, 1,2, 1,2]
        mode3 = [2,1,1, 2,1,1, 2,1,1]
        mode4 = [1,1,3,1,   1,1,3,1]
        mode5 = [1,4,1,     1,4,1]
        mode6 = [2,2,1,1,   2,2,1,1]
        mode7 = [1,1,1,2,1, 1,1,1,2,1]


-   Old stuff>



-- Semitone is an enumerated associated type
type family Semitone a :: *
type family Alteration a :: *

-- A scale is a function :: Semitone a -> a
newtype Scale a = Scale { getScale :: [Semitone a] } 
-- Eq, Show

semitone :: Scale a -> Semitone a -> a
semitone = undefined


semitone (Scale xs) p = xs !! (fromIntegral p `mod` length xs)


fromSemitone :: (Num a, Ord a, Integral b, Num c) => Scale a -> b -> c
fromSemitone (Scale xs) p = fromIntegral $ fromMaybe (length xs - 1) $ List.findIndex (>= fromIntegral p) xs

scaleFromSemitones :: Num a => [a] -> Scale a
scaleFromSemitones = Scale . accum
    where
        accum = snd . List.mapAccumL add 0
        add a x = (a + x, a + x)

-- numberOfSemitones :: Scale a -> Int
numberOfSemitones = length . getScale

major :: Num a => Scale a
major = scaleFromSemitones [0,2,2,1,2,2,2,1]

naturalMinor :: Num a => Scale a
naturalMinor = scaleFromSemitones [0,2,1,2,2,1,2,2]

harmonicMinor :: Num a => Scale a                     
harmonicMinor = scaleFromSemitones [0,2,1,2,2,1,3,1]

-}


-- or' :: (t -> Bool) -> (t -> Bool) -> t -> Bool
-- or' p q x = p x || q x

-- replicate' n = replicate (fromIntegral n)
