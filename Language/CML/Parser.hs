-- | This module exports the parsers for the CML language.
module Language.CML.Expression where

import Text.ParserCombinators.Parsec

data Expr = Expr String [Spec] [Expr] -- ^ The elementary expression type is a tag-name with zero to possible infinite specifications (classes, ids, other attributes) and child expressions.
          | Text String               -- ^ Source text (content) which is not a tag.
          deriving (Eq, Show)

data Spec = Id String             -- ^ A data type for <tag id="id-name"></tag>.
          | Attr (String, String) -- ^ A data type for <tag key="value"></tag>.
          | Class String          -- ^ A data type for <tag class="class-name"></tag>.
          deriving (Eq, Show)

-- | A parser wrapped in curly braces.
braced :: Parser a -> Parser a
braced p = char '{' *> optional spaces *> p <* optional spaces <* char '}'

-- | The main parser: parses an entire HTML tag tree.
parseExpr :: Parser Expr
parseExpr = try parseSubtree <|> (Text <$> parseText)
  where
    parseSubtree = Expr <$> parseTag
                <*> many parseSpec <* optional spaces
                <*> braced (parseExpr `sepBy` optional spaces)

-- | Parses a tag name.
parseTag :: Parser String
parseTag = parseIdent

-- | Parses either an id-spec, a class-spec or a miscellaneous attribute.
parseSpec :: Parser Spec
parseSpec = parseId <|> parseClass <|> parseAttr
  where
    parseId, parseClass, parseAttr :: Parser Spec
    parseId    = Id <$> (char '#' *> parseIdent)
    parseClass = Class <$> (char '.' *> parseIdent)
    parseAttr  = fmap Attr $ (,) <$> (char ':' *> parseIdent <* char '=') <*> parseString

-- | Simple string and identifier parsers.
parseIdent, parseString, parseText :: Parser String
parseIdent  = (:) <$> (lower <|> upper) <*> many (alphaNum <|> oneOf "-_")
parseString = char '"' *> many (noneOf ['"']) <* char '"'
parseText   = many1 (noneOf "{}")

testParse = parse parseExpr []
