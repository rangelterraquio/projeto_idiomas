//
//  Profile.swift
//  ProjetoIdiomas
//
//  Created by Rangel Cardoso Dias on 19/04/20.
//  Copyright © 2020 Rangel Cardoso Dias. All rights reserved.
//

import Foundation
import FirebaseFirestore

public struct User{
    public var id: String
    let name: String
    var photoURL: String?
    var score: Int16?
    var rating: Int16?
    var fluentLanguage: [String]
    var learningLanguage: [String]?
    var idPosts : [String]?
    var idCommentedPosts: [String]?
    var fcmToken: String
    
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
            "fcmToken" : fcmToken
        ]
    }
}

extension User: DocumentSerializable{
    public init?(dictionary snapshot: QueryDocumentSnapshot) {
        let data = snapshot.data()
        
        if let snap = data["author"] as? [String : Any]{
            guard let name = snap["name"] as? String,
                let fcmToken = snap["fcmToken"] as? String,
                let id =  snap["id"] as? String,
                let fluentLanguage = snap["fluentLanguage"] as? [String] else {return nil}
            self.init(id: id, name: name, photoURL: snap["photoURL"] as? String, score: snap["score"] as? Int16, rating: snap["rating"] as? Int16, fluentLanguage: fluentLanguage, learningLanguage: snap["learningLanguage"] as? [String], idPosts: snap["idPosts"] as? [String], idCommentedPosts: snap["idCommentedPosts"] as? [String], fcmToken: fcmToken)
        }else{
            guard let name = data["name"] as? String,
               let fcmToken = data["fcmToken"] as? String,
                 let id = data["id"] as? String,
               let fluentLanguage = data["fluentLanguage"] as? [String] else {return nil}
            self.init(id: id, name: name, photoURL: data["photoURL"] as? String, score: data["score"] as? Int16, rating: data["rating"] as? Int16, fluentLanguage: fluentLanguage, learningLanguage: data["learningLanguage"] as? [String], idPosts: data["idPosts"] as? [String], idCommentedPosts: data["idCommentedPosts"] as? [String], fcmToken: fcmToken)
        }
        
        
//
//        self.init(id: snapshot.documentID, name: name, photoURL: snap["photoURL"] as? String, score: snap["score"] as? Int16, rating: snap["rating"] as? Int16, fluentLanguage: fluentLanguage, learningLanguage: snap["learningLanguage"] as? [String], idPosts: snap["idPosts"] as? [String], idCommentedPosts: snap["idCommentedPosts"] as? [String])
    }
    
    public init?(dictionary snapshot: DocumentSnapshot) {
            let data = snapshot.data()!
            
            if let snap = data["author"] as? [String : Any]{
                guard let name = snap["name"] as? String,
                    let fcmToken = snap["fcmToken"] as? String,
                    let fluentLanguage = snap["fluentLanguage"] as? [String] else {return nil}
                self.init(id: snapshot.documentID, name: name, photoURL: snap["photoURL"] as? String, score: snap["score"] as? Int16, rating: snap["rating"] as? Int16, fluentLanguage: fluentLanguage, learningLanguage: snap["learningLanguage"] as? [String], idPosts: snap["idPosts"] as? [String], idCommentedPosts: snap["idCommentedPosts"] as? [String], fcmToken: fcmToken)
            }else{
                guard let name = data["name"] as? String,
                   let fcmToken = data["fcmToken"] as? String,
                   let fluentLanguage = data["fluentLanguage"] as? [String] else {return nil}
                self.init(id: snapshot.documentID, name: name, photoURL: data["photoURL"] as? String, score: data["score"] as? Int16, rating: data["rating"] as? Int16, fluentLanguage: fluentLanguage, learningLanguage: data["learningLanguage"] as? [String], idPosts: data["idPosts"] as? [String], idCommentedPosts: data["idCommentedPosts"] as? [String], fcmToken: fcmToken)
            }
            
            
    //
    //        self.init(id: snapshot.documentID, name: name, photoURL: snap["photoURL"] as? String, score: snap["score"] as? Int16, rating: snap["rating"] as? Int16, fluentLanguage: fluentLanguage, learningLanguage: snap["learningLanguage"] as? [String], idPosts: snap["idPosts"] as? [String], idCommentedPosts: snap["idCommentedPosts"] as? [String])
        }
    
    
}

