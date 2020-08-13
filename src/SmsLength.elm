module SmsLength exposing
    ( charsUsed, charsInSms
    , numberOfSms
    )

{-| SmsLength

Utilities arround SMS messages and their length with regards to the necessary encoding.


# How many chars are used, how much chars do I have by SMS?

@docs charsUsed, charsInSms


# How many SMS do I need?

@docs numberOfSms

-}


type alias Message =
    String


isGSMChar : Char -> Bool
isGSMChar c =
    List.member c gsmCharset


isExtendedGMSChar : Char -> Bool
isExtendedGMSChar c =
    List.member c gsmExtendedCharset


isUCS2 : Message -> Bool
isUCS2 message =
    String.toList message
        |> List.all (\c -> isGSMChar c || isExtendedGMSChar c)
        |> not


gsmCharWeight : Char -> Int
gsmCharWeight c =
    if List.member c gsmCharset then
        1

    else
        2


{-| Tell the number of chars in a string

  - Handle the GSM Charset
  - Handle the GSM extended charset (a character counts for two 7-bit chars)
  - Handle the UCS-2 charset (all characters counts for 2 bytes)

A SMS is allowed for 140 bytes, multipart SMS needs a 7 bytes header to be linked to each other's.

-}
charsUsed : Message -> Int
charsUsed message =
    if isUCS2 message then
        String.length message

    else
        String.toList message
            |> List.map gsmCharWeight
            |> List.sum


{-| Tell the number of chars per SMS with regards to the mandatory message encoding

  - Handle the GSM Charset
  - Handle the GSM extended charset (a character counts for two 7-bit chars)
  - Handle the UCS-2 charset (all characters counts for 2 bytes)

A SMS is allowed for 140 bytes, multipart SMS needs a 7 bytes header to be linked to each other's.

-}
charsInSms : Message -> Int
charsInSms message =
    let
        message_length =
            charsUsed message
    in
    if isUCS2 message then
        if message_length > 70 then
            63

        else
            70

    else if message_length > 160 then
        153

    else
        160


{-| Tell the number of SMS messages mandatory with regards to the current message string and encoding
-}
numberOfSms : Message -> Int
numberOfSms message =
    let
        message_length =
            charsUsed message

        chars_per_sms =
            charsInSms message
    in
    (toFloat message_length / toFloat chars_per_sms)
        |> ceiling


gsmCharset : List Char
gsmCharset =
    [ ' '
    , '!'
    , '"'
    , '#'
    , '$'
    , '%'
    , '\''
    , '('
    , ')'
    , '*'
    , '+'
    , ','
    , '-'
    , '.'
    , '/'
    , ':'
    , ';'
    , '<'
    , '='
    , '>'
    , '?'
    , '@'
    , '_'
    , '¡'
    , '£'
    , '¥'
    , '§'
    , '¿'
    , '&'
    , '¤'
    , '0'
    , '1'
    , '2'
    , '3'
    , '4'
    , '5'
    , '6'
    , '7'
    , '8'
    , '9'
    , 'A'
    , 'B'
    , 'C'
    , 'D'
    , 'E'
    , 'F'
    , 'G'
    , 'H'
    , 'I'
    , 'J'
    , 'K'
    , 'L'
    , 'M'
    , 'N'
    , 'O'
    , 'P'
    , 'Q'
    , 'R'
    , 'S'
    , 'T'
    , 'U'
    , 'V'
    , 'W'
    , 'X'
    , 'Y'
    , 'Z'
    , 'a'
    , 'b'
    , 'c'
    , 'd'
    , 'e'
    , 'f'
    , 'g'
    , 'h'
    , 'i'
    , 'j'
    , 'k'
    , 'l'
    , 'm'
    , 'n'
    , 'o'
    , 'p'
    , 'q'
    , 'r'
    , 's'
    , 't'
    , 'u'
    , 'v'
    , 'w'
    , 'x'
    , 'y'
    , 'z'
    , 'Ä'
    , 'Å'
    , 'Æ'
    , 'Ç'
    , 'É'
    , 'Ñ'
    , 'Ø'
    , 'ø'
    , 'Ü'
    , 'ß'
    , 'Ö'
    , 'à'
    , 'ä'
    , 'å'
    , 'æ'
    , 'è'
    , 'é'
    , 'ì'
    , 'ñ'
    , 'ò'
    , 'ö'
    , 'ù'
    , 'ü'
    , 'Δ'
    , 'Φ'
    , 'Γ'
    , 'Λ'
    , 'Ω'
    , 'Π'
    , 'Ψ'
    , 'Σ'
    , 'Θ'
    , 'Ξ'
    ]


gsmExtendedCharset : List Char
gsmExtendedCharset =
    [ '|', '^', '€', '{', '}', '[', ']', '~' ]
