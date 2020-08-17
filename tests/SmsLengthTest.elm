module SmsLengthTest exposing (all)

import Expect
import SmsLength
import Test exposing (..)


realSmsFR =
    "Lors de votre commande chez real_merchant vous avez choisi de payer en plusieurs fois via notre solution. Nous vous avons récemment envoyé un email à votre adresse martin.dupont.2998823123@gmail.com afin de vous demander votre pièce d’identité et un justificatif de domicile. Ces documents nous permettront de valider votre commande. Attention, cet email est peut-être arrivé dans vos spams ! Vous pouvez aussi choisir de directement nous envoyer ces documents sur support@gettld.eu. Pour plus d’informations sur votre paiement, veuillez consulter votre échéancier via votre lien sécurisé : http://localhost:1339/11k6H4U48sDuzF1w0AyeCyuEIUE4mbHBJs Sans réponse de votre part sous 48h, votre commande sera annulée et intégralement remboursée. Merci, votre solution de paiement en plusieurs fois."


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
            , test "Real SMS FR" <|
                \() ->
                    Expect.equal
                        794
                        (SmsLength.charsUsed realSmsFR)
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
                        67
                        (SmsLength.charsInSms <| String.repeat 14 "Hello World 🎅")
            , test "Real SMS FR" <|
                \() ->
                    Expect.equal
                        67
                        (SmsLength.charsInSms realSmsFR)
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
            , test "Real SMS FR" <|
                \() ->
                    Expect.equal
                        12
                        (SmsLength.numberOfSms realSmsFR)
            ]
        ]
