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
        , describe "numberOfSms"
            [ test "handle char count in the GSM charset" <|
                \() ->
                    Expect.equal
                        1
                        (SmsLength.numberOfSms "Hello World!")
            , test "handle char count in the GSM charset with long messages" <|
                \() ->
                    Expect.equal
                        1
                        (SmsLength.numberOfSms <| String.repeat 13 "Hello World!")
            , test "handle char count in the GSM charset with multipart messages" <|
                \() ->
                    Expect.equal
                        2
                        (SmsLength.numberOfSms <| String.repeat 14 "Hello World!")
            , test "handle char count in the GSM extended charset with long messages" <|
                \() ->
                    Expect.equal
                        1
                        (SmsLength.numberOfSms <| String.repeat 11 "Hello World €")
            , test "handle char count in the GSM extended charset with multipart messages" <|
                \() ->
                    Expect.equal
                        2
                        (SmsLength.numberOfSms <| String.repeat 12 "Hello World €")
            , test "handle char count in UCS-2 Unicode charset with long messages" <|
                \() ->
                    Expect.equal
                        1
                        (SmsLength.numberOfSms <| String.repeat 5 "Hello World 🎅")
            , test "handle char count on multipart UCS-2 messages" <|
                \() ->
                    Expect.equal
                        2
                        (SmsLength.numberOfSms <| String.repeat 6 "Hello World 🎅")
            , test "UCS-2 lower limit" <|
                \() ->
                    Expect.equal
                        1
                        (SmsLength.numberOfSms <| String.repeat 35 "🎅")
            , test "UCS-2 upper limit" <|
                \() ->
                    Expect.equal
                        2
                        (SmsLength.numberOfSms <| String.repeat 36 "🎅")
            , test "GSM chartset lower limit" <|
                \() ->
                    Expect.equal
                        1
                        (SmsLength.numberOfSms <| String.repeat 160 "H")
            , test "GSM charset upper limit" <|
                \() ->
                    Expect.equal
                        2
                        (SmsLength.numberOfSms <| String.repeat 161 "H")
            ]
        ]
