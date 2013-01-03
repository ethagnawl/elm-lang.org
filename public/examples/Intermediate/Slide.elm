
data Either a b = Left a | Right b

mergeEither xs ys = merge (Left <~ xs) (Right <~ ys)

input = let clickPos = sampleOn Mouse.clicks Mouse.position
        in  mergeEither clickPos (40 `fpsWhen` (second `since` clickPos))

step inp ((tx,ty),(x,y)) =
    case inp of
      Left t -> (t, (x,y))
      Right d -> ((tx,ty), ( x + (tx - x) * (d / 100)
                           , y + (ty - y) * (d / 100) ))

follower (w,h) (target,pos) =
  layers [ collage w h [ filled cyan (circle 16 pos) ]
         , plainText "Click anywhere and the circle will follow."
         ]

main = follower <~ Window.dimensions
                 ~ foldp step ((200,200),(200,200)) input

