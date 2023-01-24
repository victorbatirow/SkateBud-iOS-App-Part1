//
//  InboxApi.swift
//  SkateBud
//
//  Created by Victor on 2022-11-14.
//

import Foundation
import Firebase

typealias InboxCompletion = (Inbox) -> Void


class InboxApi {
    func lastMessages(uid: String,  onSuccess: @escaping(InboxCompletion)) {
        let ref = Ref().databaseInboxForUser(uid: uid)
        ref.observe(DataEventType.childAdded) { (snapshot) in
            if let dict = snapshot.value as? Dictionary<String, Any> {
                Api.User.getUserInfor(uid: snapshot.key, onSuccess: { (user) in
                    if let inbox = Inbox.transformInbox(dict: dict, user: user) {
                        onSuccess(inbox)
                    }
                })
            }
        }
    }
}
