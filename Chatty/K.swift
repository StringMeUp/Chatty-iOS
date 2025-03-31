//
//  Constants.swift
//  Chatty
//
//  Created by Samir Ramic on 03.03.25.
//

struct K {
    static let appName = "⚡️ Chatty ⚡️"
    static let cellIdentifier = "ReusableCell"
    static let cellNibName = "MessageCell"
    static let registerSegue = "RegisterToChat"
    static let loginSegue = "LoginToChat"
    
    struct BrandColors {
        static let blue = "BrandYaleBlue"
        static let lightBlue = "BrandYaleLightBlue"
        static let yellow = "BrandNaplesYellow"
        static let brown = "BrandSandyBrown"
        static let red = "BrandTomato"
        static let lemonChiffon = "BrandLemonChiffon"
    }
    
    struct FStore {
        static let collectionName = "messages"
        static let senderField = "sender"
        static let bodyField = "body"
        static let dateField = "date"
    }
}
