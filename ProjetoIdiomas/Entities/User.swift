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

extension User: DocumentSerializable{
    init?(dictionary snapshot: QueryDocumentSnapshot) {
        let data = snapshot.data()
        
        guard let snap = data["author"] as? [String : Any],
            let name = snap["name"] as? String,
            let fluentLanguage = snap["fluentLanguage"] as? [String]
            else {return nil}
        
        self.init(id: snapshot.documentID, name: name, photoURL: snap["photoURL"] as? String, score: snap["score"] as? Int16, rating: snap["rating"] as? Int16, fluentLanguage: fluentLanguage, learningLanguage: snap["learningLanguage"] as? [String], idPosts: snap["idPosts"] as? [String], idCommentedPosts: snap["idCommentedPosts"] as? [String])
    }
    
    
}

