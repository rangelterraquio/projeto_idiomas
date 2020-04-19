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


protocol DocumentSerializable {
  init?(dictionary: QueryDocumentSnapshot)

}

public struct Profile{
    let id: String
    let name: String
    var photoURL: String?
    var score: Int16?
    var rating: Int16?
    var fluentLanguage: [String]
    var learningLanguage: [String]?
    var idPosts : [String]?
    var idCommentedPosts: [String]?
    
    
    var dictionary : [String : Any]{
        return [
            "id" : id,
            "name" : name,
            "photoURL" : photoURL as Any,
            "score" : score as Any,
            "rating" : rating as Any,
            "fluentLanguage" : fluentLanguage,
            "learningLanguage" : learningLanguage as Any,
            "idPosts" : idPosts as Any,
            "idCommentedPosts" : idCommentedPosts as Any,
        ]
    }
}

extension Profile: DocumentSerializable{
    init?(dictionary snapshot: QueryDocumentSnapshot) {
        let data = snapshot.data()
        
        guard let snap = data["author"] as? [String : Any],
            let name = snap["name"] as? String,
            let fluentLanguage = snap["fluentLanguage"] as? [String]
            else {return nil}
        
        self.init(id: snapshot.documentID, name: name, photoURL: snap["photoURL"] as? String, score: snap["score"] as? Int16, rating: snap["rating"] as? Int16, fluentLanguage: fluentLanguage, learningLanguage: snap["learningLanguage"] as? [String], idPosts: snap["idPosts"] as? [String], idCommentedPosts: snap["idCommentedPosts"] as? [String])
    }
    
    
}


public struct Post {
//    struct ProfileFeed{
//        let nome: String?
//        let id: String
//        let fotoURL: String?
//        
//        init(<#parameters#>) {
//            <#statements#>
//        }
//    }
    
    let id: String
    let title: String
    let message: String
    let author: Profile
    let language: String
    var upvote: Int32
    var downvote: Int32
    let publicationDate: Date
   // var comments: [String]?
    
    
    var dictionary : [String:Any] {
        return [
                "title": title,
                "message": message,
                "publicationDate": publicationDate,
                "language": language,
                "upvote": upvote,
                "downvote": downvote,
                "author" : author.dictionary
               // "comments": comments  ?? "",
        ]
    }
    
    

    init(id: String, title: String, message: String, language: String, upvote: Int32, downvote: Int32, publicationDate: Date, author: Profile) {
           self.title = title
           self.message = message
           self.publicationDate = publicationDate
           self.language  = language
           self.upvote = upvote
           self.downvote = downvote
           self.id = id
           self.author = author
       }
       

}

extension Post : DocumentSerializable{
  
    
    
    init?(dictionary snapshot: QueryDocumentSnapshot) {
        let snap = snapshot.data()
        guard let title = snap["title"] as? String,
            let message = snap["message"] as? String,
            let publicationDate = snap["publicationDate"] as? Timestamp,
            let language = snap["language"] as? String,
            let upvote = snap["upvote"] as? Int32,
            let downvote = snap["downvote"] as? Int32,
            let author = Profile(dictionary: snapshot)
            else {return nil}
            
        self.init(id: snapshot.documentID, title: title, message: message, language: language, upvote: upvote, downvote: downvote, publicationDate: publicationDate.dateValue(),author: author)
        }

}
public enum Languages : String{
    case portuguese = "pt"
    case english = "en"
    case spanish = "sp"
    case french = "fr"
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
