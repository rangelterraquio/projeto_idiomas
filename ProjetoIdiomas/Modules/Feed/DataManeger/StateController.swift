//
//  StateController.swift
//  ProjetoIdiomas
//
//  Created by Rangel Cardoso Dias on 13/04/20.
//  Copyright © 2020 Rangel Cardoso Dias. All rights reserved.
//

import Foundation
import FirebaseFirestore
import GoogleSignIn
import FirebaseAuth

public class StateController{
    
    private var storage: StoregeAPI!
    var imageLoader: ImageLoader!
    let notificationSender = PushNotificationSender()
    var notificationManeger: PushNotificationManager?
    let cameraHandler = CamereHandler()
    var isFirstSnapShot = true
    var user: User?{
        didSet{
            StoregeAPI.currentUser = user
        }
    }
    
    init(storage: StoregeAPI) {
        self.storage = storage
        self.imageLoader = storage.imageLoader
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
    
    
    func fetchActivites(from date: Date, completion: @escaping ([QueryDocumentSnapshot]?) -> ()){
        storage.fetchActivities(from: date, completion: completion)
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
        if comment.authorId != user?.id{
            notificationSender.sendPushNotification(to: post, title: "New Comment", body: "\(comment.authorName) commented on your post :D", complition: { isCompleted in
                
                if isCompleted{
                    self.storage.createActivity(post: post, msg: "\(comment.authorName) commented on your post.") { (result) in
                        
                        //fazer algo
                    }
                }
                
            })
        }
    }
    
    func upadteActivityStatus(id: String){
        storage.uodateActivityStatus(id: id)
    }
    
    
    func saveImage(userID: String, image: UIImage){
        storage.saveImage(userID: userID, image: image)
    }
    
    func updateUser(user: User,completion: @escaping (Bool)->()){
        storage.updateUser(user: user, completion: completion)
    }
    
    func addActivityListener(user: User, activitiesVC: UIViewController) -> ListenerRegistration{
        return storage.db.collection("Users").document(user.id).collection("Notifications").addSnapshotListener { (snap, error) in
            if error != nil {
                return
            }else{
//                snap?.documentChanges.forEach { diff in
//                    Notifaction(dictionary: snap.)
//                    if (diff.type == .added) {
//                              activitiesVC.tabBarItem.badgeColor = .red
//                              activitiesVC.tabBarItem.badgeValue = ""
//                        }
//                }
                var num = 1
                snap?.documents.forEach({ (doc) in
                    if let notif = Notifaction(dictionary: doc){
                        if !notif.isViewed{
                            activitiesVC.tabBarItem.badgeColor = .red
                            activitiesVC.tabBarItem.badgeValue = "\(num)"
                            num+=1
                        }else{
                            if let num = Int(activitiesVC.tabBarItem.badgeValue ?? "0"), num == 0{
                                activitiesVC.tabBarItem.badgeValue = nil
                            }
                        }
                    }
                })
                
            }
        }

    }
    
      func addNewPostsListener(updateStatus: @escaping ([Post])->()) -> ListenerRegistration{
            return storage.db.collection("Posts").addSnapshotListener { (snap, error) in
                if error != nil {
                    return
                }else{
                    var posts = [Post]()
                    
                    snap?.documentChanges.forEach { diff in
                        if (diff.type == .added) {
                            if let p = Post(dictionary: diff.document){
                                if p.author.id != StoregeAPI.currentUser?.id{
                                    posts.append(p)
                                }
                                
                            }
                            
                        }
                    }
                    if !self.isFirstSnapShot, !posts.isEmpty{
                         updateStatus(posts)
                    }else{
                        self.isFirstSnapShot = false
                    }
                   
//                    var num = 1
//                    snap?.documents.forEach({ (doc) in
//                        if let notif = Notifaction(dictionary: doc){
//                            if !notif.isViewed{
//                                activitiesVC.tabBarItem.badgeColor = .red
//                                activitiesVC.tabBarItem.badgeValue = "\(num)"
//                                num+=1
//                            }
//                        }
//                    })
                    
                }
            }

        }
    
    
    func fetchUserPosts(from date: Date, completion: @escaping ([QueryDocumentSnapshot]?) -> ()){
        storage.fechUserPosts(from: date, completion: completion)
    }
    
    func removePost(post: Post){
        storage.removePost(post: post)
    }
    
    func deleteUserAccount(crendentials: AuthCredential, completion: @escaping (CustomError?)->()){
        storage.deleteUserAccount(crendentials: crendentials,completion: completion)
    }
    
    func updateUserName(newName: String, user: User){
        storage.updateUserName(newName: newName, user: user)
    }
    
    func requestPermissionForNotification() {
        notificationManeger?.registerForPushNotifications()
    }
    
    func reportPost(post: Post){
        storage.reportPost(post: post)
    }
    
   
    func reportComment(comment: Comment, inPost: Post) {
        storage.reportComment(comment: comment, inPost: inPost)
    }
      
      
      
}
