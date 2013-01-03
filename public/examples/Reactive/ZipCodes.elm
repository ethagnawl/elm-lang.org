
import Maybe
import HTTP


(field,rawInput) = Input.textField "Zip Code"

-- Covert raw input into a usable URL.
toUrl s = if length s == 5 && all Char.isDigit s
             then Just ("http://zip.elevenbasetwo.com/v2/US/" ++ s)
             else Nothing

-- Transform the signal of raw input into usable data, indicating if the input
-- is valid and, if so, what it is.
realInput = toUrl <~ rawInput

-- Send AJAX requests for any valid input!
responses = sendGet (fromMaybe "" <~ keepIf isJust Nothing realInput)

-- Display a response.
display response = 
  case response of
    Success address -> text . monospace $ toText address
    Waiting -> image 16 16 "waiting.gif"
    Failure _ _ -> asText response

-- Give the user a message depending on whether their input is valid and
-- the response from any AJAX requests.
message =
  let msg = plainText "Enter a valid zip code, such as 12345 or 90210."
      output inp rsp = maybe msg (\_ -> display rsp) inp
  in  output <~ realInput ~ responses

main = above field <~ message
