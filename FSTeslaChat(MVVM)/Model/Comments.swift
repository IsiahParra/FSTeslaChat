//
//  Comments.swift
//  FSTeslaChat(MVVM)
//
//  Created by Isiah Parra on 6/27/22.
//

import Foundation

class Comments: Codable {
    var text: String
    var id: String
    var timestamp: Date
    
    enum Key {
        static let text = "text"
        static let id = "id"
        static let timestamp = "timestamp"
    }
    var messageData: [String:AnyHashable] {
        [Key.text : self.text,
         Key.id: self.id,
         Key.timestamp: self.timestamp.timeIntervalSince1970]
    }
    init(text: String, id: String, timestamp: Date = Date()) {
        self.text = text
        self.id = id
        self.timestamp = timestamp
    }
    convenience init?(fromDict Dict: [String:Any]) {
        guard let text = Dict[Key.text] as? String,
             let id = Dict[Key.id] as? String,
             let timestamp = Dict[Key.timestamp] as? Double
        else {return nil}
        self.init(text: text, id: id, timestamp: Date(timeIntervalSince1970: timestamp))
    }
}
