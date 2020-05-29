//
//  Comment.swift
//  ProjetoIdiomas
//
//  Created by Rangel Cardoso Dias on 11/05/20.
//  Copyright © 2020 Rangel Cardoso Dias. All rights reserved.
//

import Foundation
import FirebaseFirestore

public struct Comment{
    
    var authorId: String
    var authorName: String
    var authorPhotoURL: String?
    var upvote: Int32
    var downvote: Int32
    var commentText: String
    public var id: String
    
    
    var dictionary : [String : Any]{
        return [
            "id" : id as String,
            "authorId" : authorId as String,
            "upvote" : upvote as Int32,
            "downvote" : downvote as Int32,
            "commentText" : commentText as String,
            "authorName" : authorName as String
        ]
    }
    
    init(authorId: String,upvote: Int32, downvote: Int32, commentText: String, id: String, authorName: String, authorPhotoURL: String?){
        self.authorId = authorId
        self.upvote = upvote
        self.downvote = downvote
        self.commentText = commentText
        self.authorName = authorName
        self.authorPhotoURL = authorPhotoURL
        self.id = id
    }
}
extension Comment: DocumentSerializable{
//    let data = snapshot.data()

//    guard let snap = data["author"] as? [String : Any],
//              let name = snap["name"] as? String,
//              let fluentLanguage = snap["fluentLanguage"] as? [String]
//              else {return nil}
    public init?(dictionary snapshot: QueryDocumentSnapshot) {
        let snap = snapshot.data()
        //guard let snap = data["comment"] as? [String : Any],
        guard let authorId = snap["authorId"] as? String,
            let upvote = snap["upvote"] as? Int32,
            let downvote = snap["downvote"] as? Int32,
            let commentText = snap["commentText"] as? String,
            let authorName = snap["authorName"] as? String
            else{return nil}
            let authorPhotoURL = snap["authorPhotoURL"] as? String
        self.init(authorId: authorId, upvote: upvote, downvote: downvote, commentText: commentText, id: snapshot.documentID,authorName: authorName, authorPhotoURL: authorPhotoURL)
    }
    
    
    
}

