//
//  Inbox.swift
//  SkateBud
//
//  Created by Victor on 2022-11-14.
//

import Foundation

class Inbox {
    var date: Double
    var text: String
    var user: User
    var read = false
    
    init(date: Double, text: String, user: User, read: Bool)  {
        self.date = date
        self.text = text
        self.user = user
        self.read = read
    }
    
    static func transformInbox(dict: [String: Any], user: User) -> Inbox? {
        guard let date = dict["date"] as? Double,
              let text = dict["text"] as? String,
              let read = dict["read"] as? Bool else {
                  return nil
              }
        
        let inbox = Inbox(date: date, text: text, user: user, read: read)
        
        return inbox
    }
    
    func updateData(key: String, value: Any) {
        switch key {
        case "text": self.text = value  as! String
        case "date": self.date = value as! Double
        default: break
        }
    }
}
