{-# OPTIONS_GHC -fno-warn-orphans #-}

-----------------------------------------------------------------------------
-- |
-- Module : Bio.Parse.Orphans.Biocore
-- Copyright : (C) 2015 Ricky Elrod
-- License : LGPL (see COPYING file)
-- Maintainer : Ricky Elrod <ricky@elrod.me>
-- Stability : experimental
--
-- Because biocore is released under the LGPL but bioparse is released under
-- BSD. To ensure the legally-required level of separation, we provide orphan
-- instances in this separate package, for bioparse types and biocore
-- typeclasses.
----------------------------------------------------------------------------
module Bio.Parse.Orphans.Biocore where

import Bio.Core.Sequence
import Bio.Parse.Sequence.Fasta as Fa
import Bio.Parse.Sequence.FastQ as Fq
import Bio.Parse.Sequence.Phd   as Phd
import qualified Data.ByteString.Lazy.Char8 as BL
import Data.List

instance BioSeq FastQSequence where
  seqid     = SeqLabel . head . Fq._header
  seqheader = SeqLabel . BL.concat . intersperse (BL.pack ":") . Fq._header
  seqdata   = SeqData . Fq._sequence
  seqlength = fromIntegral . BL.length . Fq._sequence

instance BioSeqQual FastQSequence where
  seqqual = QualData . Fq._quality

instance BioSeq FastaSequence where
  seqid     = SeqLabel . head . Fa._header
  seqheader = SeqLabel . BL.concat . Fa._header
  seqdata   = SeqData . Fa._sequence
  seqlength = fromIntegral . BL.length . Fa._sequence

instance BioSeq PhdSequence where
  seqid     = SeqLabel . Phd._identifier
  seqheader = SeqLabel . Phd._identifier
  seqdata   = SeqData . BL.pack . map _nucleotide . Phd._sequence
  seqlength = fromIntegral . length . Phd._sequence
