module GlobRegex
       (
         globToRegex
       ,matchesGlob
       )where

import Text.Regex.Posix ((=~))

globToRegex :: String -> String
globToRegex cs = '^' : globToRegex' cs ++ "$"

globToRegex' :: String -> String
globToRegex' "" = ""
globToRegex' ('*':cs) = ".*" ++ globToRegex' cs
globToRegex' ('?':cs) = '.' : globToRegex' cs
globToRegex' ('[':'!':c:cs) = "[^" ++ c : charClass cs
globToRegex' ('[':c:cs) = '[' : c : charClass cs
globToRegex' ('[':_) = error "unterminated"
globToRegex' (c:cs) = escape c ++ globToRegex' cs

escape :: Char -> String
escape c | c `elem` regexChars = '\\' : [c]
         | otherwise = [c]
  where regexChars = "\\+()^$.{}|"

charClass :: String -> String
charClass (']':cs) = ']' : globToRegex' cs
charClass (_:cs) = charClass cs
charClass [] = error "unterminated"

matchesGlob :: String -> String-> Bool
matchesGlob patt name = name =~ globToRegex patt
