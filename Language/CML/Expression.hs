module Language.CML.Expression where

data Expr = Expr String [Spec] [Expr] -- ^ The elementary expression type is a tag-name with zero to possible infinite specifications (classes, ids, other attributes) and child expressions.
          | Text String               -- ^ Source text (content) which is not a tag.
          deriving (Eq, Show)

data Spec = Id String             -- ^ A data type for <tag id="id-name"></tag>.
          | Attr (String, String) -- ^ A data type for <tag key="value"></tag>.
          | Class String          -- ^ A data type for <tag class="class-name"></tag>.
          deriving (Eq, Show)

