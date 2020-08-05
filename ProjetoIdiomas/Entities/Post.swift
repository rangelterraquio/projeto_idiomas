//
//  Publication.swift
//  ProjetoIdiomas
//
//  Created by Rangel Cardoso Dias on 13/04/20.
//  Copyright © 2020 Rangel Cardoso Dias. All rights reserved.
//

import Foundation
import UIKit
import FirebaseFirestore


public protocol DocumentSerializable {
  init?(dictionary: QueryDocumentSnapshot)
    var id: String { get set }
}


public struct Post {
//    struct ProfileFeed{
//        let nome: String?
//        let id: String
//        let fotoURL: String?
//        
//        init() {
//
//        }
//    }
    
    public var id: String
    let title: String
    let message: String
    let author: User
    let language: String
    var upvote: Int32 // 10 joao
    var downvote: Int32 // 35
    let publicationDate: Date
    var isLiked = false
    var isReported = false
    var reported: Int
//    var comments: [Comment]
    
    
    var dictionary : [String:Any] {
        return [
                "title": title,
                "message": message,
                "publicationDate": publicationDate,
                "language": language,
                "upvote": upvote,
                "downvote": downvote,
                "author" : author.dictionary,
                "reported" : reported
//                "comments": comments
        ]
    }
    
    

    init(id: String, title: String, message: String, language: String, upvote: Int32, downvote: Int32, publicationDate: Date, author: User, reported: Int) {
           self.title = title
           self.message = message
           self.publicationDate = publicationDate
           self.language  = language
           self.upvote = upvote
           self.downvote = downvote
           self.id = id
           self.author = author
           self.reported = reported
//           self.comments = comments
       }
       

}

extension Post : DocumentSerializable{
  
    
    
    public init?(dictionary snapshot: QueryDocumentSnapshot) {
        let snap = snapshot.data()
        guard let title = snap["title"] as? String,
            let message = snap["message"] as? String,
            let publicationDate = snap["publicationDate"] as? Timestamp,
            let language = snap["language"] as? String,
            let upvote = snap["upvote"] as? Int32,
            let downvote = snap["downvote"] as? Int32,
            let author = User(dictionary: snapshot)
            else {return nil}
            
//        var comments: [Comment] = [Comment]()
//        if let snapComments = snap["comments"] as? [QueryDocumentSnapshot] {
//            for snap  in snapComments {
//                if let cm = Comment(dictionary: snap){
//                    comments.append(cm)
//                }
//            }
//        }
        self.init(id: snapshot.documentID, title: title, message: message, language: language, upvote: upvote, downvote: downvote, publicationDate: publicationDate.dateValue(),author: author, reported: snap["reported"] as? Int ?? 0)
        }
    
    
    public init?(dictionary document: DocumentSnapshot) {
        guard let snap = document.data() else {return nil}
            guard let title = snap["title"] as? String,
                let message = snap["message"] as? String,
                let publicationDate = snap["publicationDate"] as? Timestamp,
                let language = snap["language"] as? String,
                let upvote = snap["upvote"] as? Int32,
                let downvote = snap["downvote"] as? Int32,
                let author = User(dictionary: document)
                else {return nil}
                
    //        var comments: [Comment] = [Comment]()
    //        if let snapComments = snap["comments"] as? [QueryDocumentSnapshot] {
    //            for snap  in snapComments {
    //                if let cm = Comment(dictionary: snap){
    //                    comments.append(cm)
    //                }
    //            }
    //        }
            self.init(id: document.documentID, title: title, message: message, language: language, upvote: upvote, downvote: downvote, publicationDate: publicationDate.dateValue(),author: author, reported: snap["reported"] as? Int ?? 0)
            }

}


/*
 
 
 struct CommentResponseModel {

     var createdAt : Date?
     var commentDescription : String?
     var documentId : String?

     var dictionary : [String:Any] {
         return [
                 "createdAt": createdAt  ?? "",
                 "commentDescription": commentDescription  ?? ""
         ]
     }

    init(snapshot: QueryDocumentSnapshot) {
         documentId = snapshot.documentID
         var snapshotValue = snapshot.data()
         createdAt = snapshotValue["createdAt"] as? Date
         commentDescription = snapshotValue["commentDescription"] as? String
     }
 }
 */
extension Post: Equatable{
    public static func == (lhs: Post, rhs: Post) -> Bool {
        lhs.id.elementsEqual(rhs.id)
    }
}
