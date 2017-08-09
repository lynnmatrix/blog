--------------------------------------------------------------------------------
{-# LANGUAGE OverloadedStrings #-}
import           Data.Monoid (mappend, (<>))
import           Hakyll
import           Text.Regex
import           System.FilePath
import           Data.List

-- Groups article items by year (reverse order).
groupArticles :: [Item String] -> [(Int, [Item String])]
groupArticles = fmap merge . group . fmap tupelise
    where
        merge :: [(Int, [Item String])] -> (Int, [Item String])
        merge gs   = let conv (year, acc) (_, toAcc) = (year, toAcc ++ acc)
                     in  foldr conv (head gs) (tail gs)

        group ts   = groupBy (\(y, _) (y', _) -> y == y') ts
        tupelise i = let path = (toFilePath . itemIdentifier) i
                     in  case (articleYear . takeBaseName) path of
                             Just year -> (year, [i])
                             Nothing   -> error $
                                              "[ERROR] wrong format: " ++ path

-- Extracts year from article file name.
articleYear :: FilePath -> Maybe Int
articleYear s = fmap read $ fmap head $ matchRegex articleRx s

articleRx :: Regex
articleRx = mkRegex "^([0-9]{4})\\-([0-9]{2})\\-([0-9]{2})\\-(.+)$"
--------------------------------------------------------------------------------
main :: IO ()
main = hakyll $ do
    match "images/*" $ do
        route   idRoute
        compile copyFileCompiler

    match "css/*" $ do
        route   idRoute
        compile compressCssCompiler

    match "js/*" $ do
        route   idRoute
        compile copyFileCompiler

    match "CNAME" $ do
        route   idRoute
        compile copyFileCompiler

    match (fromList ["about.rst", "contact.markdown"]) $ do
        route   $ setExtension "html"
        compile $ pandocCompiler
            >>= loadAndApplyTemplate "templates/default.html" siteCtx
            >>= relativizeUrls

    match "posts/*" $ do
        route $ setExtension "html"
        compile $ pandocCompiler
            >>= loadAndApplyTemplate "templates/post.html"    postCtx
            >>= loadAndApplyTemplate "templates/default.html" postCtx
            >>= relativizeUrls

    create ["archive.html"] $ do
        route idRoute
        compile $ do
            posts <- fmap groupArticles $ recentFirst =<< loadAll "posts/*"
            let archiveCtx =
                    listField "years"
                    (
                        field "year" (return . fst . itemBody) <>
                        listFieldWith "articles" postCtx
                            (return . snd . itemBody)
                    )
                    (sequence $ fmap (\(y, is) -> makeItem (show y, is))
                                                      posts) <>
                    constField "title" "Archives"            `mappend`
                    siteCtx

            makeItem ""
                >>= loadAndApplyTemplate "templates/archive.html" archiveCtx
                >>= loadAndApplyTemplate "templates/default.html" archiveCtx
                >>= relativizeUrls


    match "index.html" $ do
        route idRoute
        compile $ do
            posts <- fmap groupArticles $ recentFirst =<< loadAll "posts/*"
            let indexCtx =
                    listField "years"
                    (
                        field "year" (return . fst . itemBody) <>
                        listFieldWith "articles" postCtx
                            (return . snd . itemBody)
                    )
                    (sequence $ fmap (\(y, is) -> makeItem (show y, is))
                                                      posts) <>
                    constField "title" "Home"                `mappend`
                    siteCtx

            getResourceBody
                >>= applyAsTemplate indexCtx
                >>= loadAndApplyTemplate "templates/default.html" indexCtx
                >>= relativizeUrls

    match "templates/*" $ compile templateBodyCompiler


--------------------------------------------------------------------------------
postCtx :: Context String
postCtx =
    dateField "date" "%B %e, %Y" `mappend`
    constField "disqus_shortname" "lynnmatrix-github-com" `mappend`
    siteCtx

siteCtx :: Context String
siteCtx =
    constField "baseurl" "http://linyiming.me" `mappend`
    constField "site_description" "林以明の博客" `mappend`
    constField "twitter_username" "lynnmatrix" `mappend`
    constField "github_username" "lynnmatrix" `mappend`
    constField "google_username" "lynnmatrix" `mappend`
    defaultContext
