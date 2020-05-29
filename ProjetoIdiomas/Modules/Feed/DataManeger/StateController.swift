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
    
    var user: User?{
        didSet{
            storage.currentUser = user
        }
    }
    
    init(storage: StoregeAPI) {
        self.storage = storage
    }
    
    
    func fecthPosts(in languages: [Languages], from date: Date, completion: @escaping ([QueryDocumentSnapshot]?) -> ()){
        storage.fechPosts(in: languages, from: date, completion: completion)
    }
    
    func fetchComments(in post: Post,startingBy num: Int32, completion: @escaping ([QueryDocumentSnapshot]?) -> ()){
        storage.fechComments(in: post, startingBy: num, completion: completion)
    }
    
    func updateVotes<T : DocumentSerializable >(from voteType: String, inDocument: T,  with comment: Comment?){
        storage.updateVotes(from: voteType, inDocument: inDocument, with: comment)
    }
    
    
    func createPost(title: String, text: String, language: Languages,completion: @escaping (Result<Void, CustomError>) -> Void){
        storage.createPost(title: title, text: text, language: language, completion: completion)
    }
    
    
    func createComment(text: String, postID: String, completion: @escaping (Result<Comment, CustomError>) -> Void){
        storage.createComment(text: text, postID: postID, completion: completion)
    }
    
    func createUser(user: User, completion: @escaping (Result<Void, CustomError>) -> Void){
        storage.createUser(user: user, completion: completion)
    }
}
