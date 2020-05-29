//
//  StorageAPI.swift
//  ProjetoIdiomas
//
//  Created by Rangel Cardoso Dias on 13/04/20.
//  Copyright © 2020 Rangel Cardoso Dias. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth
import SystemConfiguration

import SystemConfiguration.CaptiveNetwork


//enum ComplationAddDataResult<Value>{
//    case failure(String)
//    case success(Void)
//}

public class StoregeAPI{
    
    
    private var db = Firestore.firestore()
    
    private var snapshots: [QueryDocumentSnapshot]? = nil
    
    var currentUser: User?
    func fechPosts(in languages: [Languages], from date: Date,completion: @escaping ([QueryDocumentSnapshot]?) -> ()){
        
        let num  = 50/languages.count
        
        let documentRef = db.collection("Posts")
        
        
        for language in languages{
            
            documentRef.order(by: "publicationDate", descending: true).start(at: [date]).whereField("language", isEqualTo: language.rawValue).limit(to: num).getDocuments { (querySnapshot, error) in
                
                if error != nil {
                    print("Tratar error")
                }else{
                  completion(querySnapshot?.documents)

                }
            }
        }
        
    }
    
    func fechComments(in post: Post,startingBy numOfVotes:Int32, completion: @escaping ([QueryDocumentSnapshot]?) -> ()){
        
        let num = 20
        
        let documentRef = db.collection("Posts").document(post.id).collection("Comments")
        
        
        documentRef.order(by: "upvote", descending: true).start(at: [numOfVotes]).limit(to: num).getDocuments{ (snapshot, error) in
            if error != nil {
                print("Tratar error")
                completion(nil)
            }else{
                completion(snapshot?.documents)
            }
        }
        
    }
    
    func createPost(title: String, text: String, language: Languages,completion: @escaping (Result<Void, CustomError>) -> Void){
        //let user  = Auth.auth().currentUser!
        
        ///quado tiver tudo funcionado eu vou ter a referencia do user q estiver logado
        
        if !hasInternet(){
            completion(.failure(.internetError))
            return
        }
        guard let user = currentUser else {return}
        
        let newPost = Post(id: UUID().uuidString, title: title, message: text, language: language.rawValue, upvote: 0, downvote: 0, publicationDate: Date(), author: user)
        
        db.collection("Posts").addDocument(data: newPost.dictionary) { (error) in
            if error != nil{
                completion(.failure(.operationFailed))
            }else{
                completion(.success(Void()))
            }
        }

    }
    
    
    func createComment(text: String, postID: String, completion: @escaping (Result<Comment, CustomError>) -> Void){
        if !hasInternet(){
            completion(.failure(.internetError))
            return
        }
        guard let user = currentUser else {return}

        
        let comment = Comment(authorId: user.id, upvote: 0, downvote: 0, commentText: text, id: UUID().uuidString, authorName: user.name, authorPhotoURL: user.photoURL)
        
            db.collection("Posts").document(postID).collection("Comments").addDocument(data: comment.dictionary) { (error) in
            if error != nil{
                completion(.failure(.operationFailed))
            }else{
                completion(.success(comment))
            }
        }

    }
    
    func createUser(user: User, completion: @escaping (Result<Void, CustomError>) -> Void){
        
        
       
        db.collection("Users").document(user.id).setData(user.dictionary) { (error) in
            if error != nil{
                completion(.failure(.operationFailed))
            }else{
                self.currentUser = user
                completion(.success(Void()))
            }
        }

    }
    
    private func hasInternet() -> Bool{
        return Reachability.isConnectedToNetwork()
    }
    
    func updateVotes<T : DocumentSerializable >(from voteType: String, inDocument: T, with comment: Comment?){
        //quando a criação de post tiver ok deixa mudar o id
        let documentRef = db.collection("Posts").document(inDocument.id)
        
        if let document = inDocument as? Post, var num = document.dictionary[voteType] as? Int32 {
            num += 1
            documentRef.setData([voteType : num], merge: true)
        }
        if let comment = comment, var num = comment.dictionary[voteType] as? Int32{
            num += 1
           let newDoc = documentRef.collection("Comments").document(comment.id)
            newDoc.setData([voteType : num], merge: true)
            
        }
        
        
        
        
    }
    
    func fetchUser(completion: @escaping ()->()){
        if let user = Auth.auth().currentUser {
            let documentRef = db.collection("Users")
            
            documentRef.whereField("id", isEqualTo: user.uid).getDocuments { [weak self] (query, error) in
                if error != nil {
                    print("error na hora de buscar o user")
                    completion()
                }else{
                    if let document = query?.documents.first{
                       let newUser = User(dictionary: document)
                         self!.currentUser = newUser
                    }
                    completion()

                }
            }
            
        }
    }
        
//        guard document = inDocument as? (Post || Comment), var num = inDocument.dictionary[voteType] as? Int16 else {
//            print("error")
//            return
//        }
        
        
    }
    
    func saveImage(userID: String, image: UIImage){
        // Get a reference to the storage service using the default Firebase App
        let storage = Storage.storage()

        // Create a storage reference from our storage service
        let storageRef = storage.reference()
            
        let imageRef = storageRef.child("Users").child(userID).child("profileImage")
        
        if let data = image.pngData(){
            let metadata = StorageMetadata()
            imageRef.putData(data, metadata: metadata) { (metadata, erro) in
                if erro != nil{
                    print(erro as Any)
                }else{
                    print("deu bommmmmm")
                }
                
                
                imageRef.downloadURL { (url, error) in
                     if erro != nil{
                        print(erro as Any)
                     }else{
//                        print(url?.absoluteString)
                    }
                }
                
                
            }
        }
        
    }
    


//
//
//

//MARK: -> User CRUD
extension StoregeAPI{
    
    
    
}

//MARK: -> Verify Internet
public class Reachability {
    public static func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)

        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return false
        }

        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        if flags.isEmpty {
            return false
        }

        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)

        return (isReachable && !needsConnection)
    }
}
