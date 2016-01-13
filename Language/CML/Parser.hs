module Language.CML.Expression (parseExpr) where

import Text.ParserCombinators.Parsec

data Expr = Expr String [Spec] [Expr]
  deriving (Eq, Show)

data Spec = Id String
          | Attr (String, String)
          | Class String
          deriving (Eq, Show)

braced :: Parser a -> Parser a
braced p = char '{' *> optional spaces *> p <* optional spaces <* char '}'

parseExpr :: Parser Expr
parseExpr = Expr
         <$> parseTag
         <*> many parseSpec <* optional spaces
         <*> braced (many parseExpr)

parseTag :: Parser String
parseTag = parseIdent

parseSpec :: Parser Spec
parseSpec = parseId <|> parseClass <|> parseAttr
  where
    parseId, parseClass, parseAttr :: Parser Spec
    parseId = Id <$> (char '#' *> parseIdent)
    parseClass = Class <$> (char '.' *> parseIdent)
    parseAttr = fmap Attr $ (,) <$> (char ':' *> parseIdent <* char '=') <*> parseString

parseIdent, parseString :: Parser String
parseIdent = (:) <$> (lower <|> upper) <*> many (alphaNum <|> oneOf "-_")
parseString = char '"' *> many (noneOf ['"']) <* char '"'

