//
//  StateController.swift
//  ProjetoIdiomas
//
//  Created by Rangel Cardoso Dias on 13/04/20.
//  Copyright © 2020 Rangel Cardoso Dias. All rights reserved.
//

import Foundation
import FirebaseFirestore

public class StateController{
    
    private var storage: StoregeAPI!
    let imageLoader = ImageLoader()
    init(storage: StoregeAPI) {
        self.storage = storage
    }
    
    
    func fecthPosts(in languages: [Languages], from date: Date, completion: @escaping ([QueryDocumentSnapshot]?) -> ()){
        storage.fechPosts(in: languages, from: date, completion: completion)
    }
    
    func updateVotes<T : DocumentSerializable >(from voteType: String, inDocument: T){
        storage.updateVotes(from: voteType, inDocument: inDocument)
    }
    
    
    func createPost(title: String, text: String, language: Languages,completion: @escaping (Result<Void, CustomError>) -> Void){
        storage.createPost(title: title, text: text, language: language, completion: completion)
    }
}
