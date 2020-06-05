//
//  Notification.swift
//  ProjetoIdiomas
//
//  Created by Rangel Cardoso Dias on 04/06/20.
//  Copyright © 2020 Rangel Cardoso Dias. All rights reserved.
//

import Foundation
import FirebaseFirestore
public struct Notifaction{
    
    public var id: String
    var postID: String
    var authorID: String
    var msg: String
    var date: Date
    var authorImageURL: String?
    var isViewed: Bool
    var dictionary : [String : Any]{
        return [
            "id" : id as String,
            "postID" : postID as String,
            "authorID" : authorID as String,
            "msg" : msg as String,
            "date" : date as Date,
            "authorImageURL" : authorImageURL as? String?,
            "isViewed" : isViewed as Bool
        ]
    }
}


extension Notifaction: DocumentSerializable{
    public init?(dictionary snapshot: QueryDocumentSnapshot) {
        let snap = snapshot.data()
        guard let postID = snap["postID"] as? String,
         let authorID = snap["authorID"] as? String,
         let msg = snap["msg"] as? String,
        let date = snap["date"] as? Timestamp,
        let isViewed = snap["isViewed"] as? Bool
        else {
            return nil
        }
        
        
        
        self.init(id: snapshot.documentID, postID: postID, authorID: authorID, msg: msg, date: date.dateValue(), authorImageURL: snap["authorImageURL"] as? String, isViewed: isViewed)
        
    }
    
    
    
    
}
