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
    let notificationSender = PushNotificationSender()
    var user: User?{
        didSet{
            StoregeAPI.currentUser = user
        }
    }
    
    init(storage: StoregeAPI) {
        self.storage = storage
    }
    
    
    func fecthPosts(in languages: [Languages], from date: Date, completion: @escaping ([QueryDocumentSnapshot]?) -> ()){
        storage.fechPosts(in: languages, from: date, completion: completion)
    }
    func fetchPostBy(id: String,completion: @escaping (DocumentSnapshot?) -> ()){
        storage.fetchPostBy(id: id, completion: completion)
    }
    func fetchComments(in post: Post,startingBy num: Int32, completion: @escaping ([QueryDocumentSnapshot]?) -> ()){
        storage.fechComments(in: post, startingBy: num, completion: completion)
    }
    
    func updateVotes<T : DocumentSerializable >(from voteType: String, inDocument: T,  with comment: Comment?){
        storage.updateVotes(from: voteType, inDocument: inDocument, with: comment)
    }
    
    
    func fetchActivites(completion: @escaping ([QueryDocumentSnapshot]?) -> ()){
        storage.fetchActivities(completion: completion)
    }
    
    func createPost(title: String, text: String, language: Languages,completion: @escaping (Result<Void, CustomError>) -> Void){
        storage.createPost(title: title, text: text, language: language, completion: completion)
    }
    
    
    func createComment(text: String, post: Post, completion: @escaping (Result<Comment, CustomError>) -> Void){
        storage.createComment(text: text, post: post, completion: completion)
        
    }
    
    func createUser(user: User, completion: @escaping (Result<Void, CustomError>) -> Void){
        storage.createUser(user: user, completion: completion)
    }
    
    func sendNotification(post: Post, comment: Comment){
        notificationSender.sendPushNotification(to: post, title: "New Comment", body: "\(comment.authorName) commented on your post :D", complition: { isCompleted in
            
            if isCompleted{
                self.storage.createActivity(post: post, msg: "\(comment.authorName) commented on your post :D") { (result) in
                    
                    //fazer algo
                }
            }
            
        })
    }
    
    func upadteActivityStatus(id: String){
        storage.uodateActivityStatus(id: id)
    }
    
    
    
}
