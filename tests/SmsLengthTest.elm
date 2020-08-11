module SmsLengthTest exposing (all)

import Expect
import SmsLength
import Test exposing (..)


all : Test
all =
    describe "SmsLength module"
        [ describe "charsUsed"
            [ test "handle char count in the GSM charset" <|
                \() ->
                    Expect.equal
                        12
                        (SmsLength.charsUsed "Hello World!")
            , test "handle char count in the GSM extended charset" <|
                \() ->
                    Expect.equal
                        14
                        (SmsLength.charsUsed "Hello World €")
            , test "handle char count in UCS-2 Unicode charset" <|
                \() ->
                    Expect.equal
                        14
                        (SmsLength.charsUsed "Hello World 🎅")
            , test "handle char count on multipart SMS" <|
                \() ->
                    Expect.equal
                        196
                        (SmsLength.charsUsed <| String.repeat 14 "Hello World 🎅")
            ]
        , describe "charsInSMS"
            [ test "handle char count in the GSM charset" <|
                \() ->
                    Expect.equal
                        160
                        (SmsLength.charsInSms "Hello World!")
            , test "handle char count in the GSM extended charset" <|
                \() ->
                    Expect.equal
                        160
                        (SmsLength.charsInSms "Hello World €")
            , test "handle char count in GSM multipart messages" <|
                \() ->
                    Expect.equal
                        153
                        (SmsLength.charsInSms <| String.repeat 14 "Hello World €")
            , test "handle char count in UCS-2 Unicode charset" <|
                \() ->
                    Expect.equal
                        70
                        (SmsLength.charsInSms "Hello World 🎅")
            , test "handle char count on multipart UCS-2 messages" <|
                \() ->
                    Expect.equal
                        63
                        (SmsLength.charsInSms <| String.repeat 14 "Hello World 🎅")
            ]
        ]
