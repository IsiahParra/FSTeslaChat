//
//  Messages.swift
//  FSTeslaChat(MVVM)
//
//  Created by Isiah Parra on 6/19/22.
//

import Foundation


class Message: Codable {
    var imageURL: String?
    var id: String
    var text: String
    var sender: String
    var timeStamp: Date
    
    
    enum Key {
        static let collectionType = "message"
        static let text = "text"
        static let sender = "sender"
        static let timeStamp = "timeStamp"
        static let id = "id"
        static let image = "imageURL"
    }
    var messageData: [String : AnyHashable] {
        [Key.text : self.text,
         Key.sender : self.sender,
         Key.timeStamp : self.timeStamp.timeIntervalSince1970,
         Key.id: self.id,
         Key.image: self.imageURL]
    }


    init(id: String, text: String, sender: String, timeStamp: Date = Date(), imageURL: String? = nil) {
        self.text = text
        self.sender = sender
        self.timeStamp = timeStamp
        self.id = id
        self.imageURL = imageURL
    }

    convenience init?(fromDictionary dict: [String : Any]) {
        guard let text = dict[Key.text] as? String,
              let sender = dict[Key.sender] as? String,
              let timeStamp = dict[Key.timeStamp] as? Double,
              let id = dict[Key.id] as? String,
              let imageURL = dict[Key.image] as? String
        else { return nil }

        self.init(id: id, text: text, sender: sender, timeStamp: Date(timeIntervalSince1970: timeStamp), imageURL: imageURL)
    }
}

extension Message: Equatable {
    static func == (lhs: Message, rhs: Message) -> Bool {
        return lhs.id == rhs.id
    }
}

