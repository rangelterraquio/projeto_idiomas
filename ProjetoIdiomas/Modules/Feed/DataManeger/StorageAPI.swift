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
    
   
    var db = Firestore.firestore()
    
    private var snapshots: [QueryDocumentSnapshot]? = nil
    let imageLoader = ImageLoader()
    static var currentUser: User?
    func fechPosts(in languages: [Languages], from date: Date,completion: @escaping ([QueryDocumentSnapshot]?) -> ()){
        
        let num  = 50
        
        let documentRef = db.collection("Posts")
        
        var idiomas = [String]()
        for language in languages{
            idiomas.append(language.rawValue)
           
        }
        
        documentRef.order(by: "publicationDate", descending: true).start(at: [date]).limit(to: num).getDocuments { (querySnapshot, error) in
            
            if error != nil {
                print("Tratar error")
            }else{
                completion(querySnapshot?.documents)
                
            }
        }
        
    }
    
    func fechUserPosts(from date: Date, completion: @escaping ([QueryDocumentSnapshot]?) -> ()){
        
        
        let documentRef = db.collection("Posts")
        
        guard let user = StoregeAPI.currentUser else{return}

        documentRef.order(by: "publicationDate", descending: true).start(at: [date]).whereField("author.id", isEqualTo: user.id).limit(to: 50).getDocuments { (querySnapshot, error) in
                
                if error != nil {
                    print("Tratar error")
                }else{
                  completion(querySnapshot?.documents)

                }
            }
    }
    
    func fetchPostBy(id: String,completion: @escaping (DocumentSnapshot?) -> ()) {
        let documentRef = db.collection("Posts").document(id)
        documentRef.getDocument { (querySnapshot, error) in
            if error != nil {
                print("Tratar error")
            }else{
                completion(querySnapshot)
            }
        }
    }
    
    func fechComments(in post: Post,startingBy numOfVotes:Int32, completion: @escaping ([QueryDocumentSnapshot]?) -> ()){
        
        let num = 20
        
        let documentRef = db.collection("Posts").document(post.id).collection("Comments")
        
        
        documentRef.order(by: "upvote", descending: true).limit(to: num).getDocuments{ (snapshot, error) in
            if error != nil {
                print("Tratar error")
                completion(nil)
            }else{
                completion(snapshot?.documents)
            }
        }
        
    }
    
    
    func fetchActivities(from date: Date,completion: @escaping ([QueryDocumentSnapshot]?) -> ()){
        
        guard let user = StoregeAPI.currentUser else{return}
        let documentRef = db.collection("Users").document(user.id).collection("Notifications").order(by: "date", descending: true).start(at: [date]).limit(to: 20)

        documentRef.getDocuments { (snapshot, error) in
            if error != nil {
                completion(nil)
            }else{
                completion(snapshot?.documents)
            }
        }
    }
    
    func createActivity(post: Post, msg: String,completion: @escaping (Result<Void, CustomError>) -> Void){
        if !hasInternet(){
            completion(.failure(.internetError))
            return
        }
        guard let user = StoregeAPI.currentUser else {return}
        
        let notif = Notifaction(id: UUID().uuidString, postID: post.id, authorID: post.author.id, msg: msg, date: Date(), authorImageURL: user.photoURL, isViewed: false)
        let docRef = db.collection("Users").document(post.author.id).collection("Notifications")
        
        docRef.addDocument(data: notif.dictionary) { (error) in
            if error != nil{
                completion(.failure(.operationFailed))
            }else{
                completion(.success(Void()))
            }
        }
    }
    
    func uodateActivityStatus(id: String) -> Void {
        guard let user = StoregeAPI.currentUser else{return}

        let documentRef = db.collection("Users").document(user.id).collection("Notifications").document(id)
        
        documentRef.setData(["isViewed" : true], merge: true)
        
    }
    
    
    
    func createPost(title: String, text: String, language: Languages,completion: @escaping (Result<Void, CustomError>) -> Void){
        //let user  = Auth.auth().currentUser!
        
        ///quado tiver tudo funcionado eu vou ter a referencia do user q estiver logado
        
        if !hasInternet(){
            completion(.failure(.internetError))
            return
        }
        guard let user = StoregeAPI.currentUser else {return}
        
        let newPost = Post(id: UUID().uuidString, title: title, message: text, language: language.rawValue, upvote: 0, downvote: 0, publicationDate: Date(), author: user)
        
        db.collection("Posts").addDocument(data: newPost.dictionary) { (error) in
            if error != nil{
                completion(.failure(.operationFailed))
            }else{
                completion(.success(Void()))
            }
        }

    }
    
    
    func createComment(text: String, post: Post, completion: @escaping (Result<Comment, CustomError>) -> Void){
        if !hasInternet(){
            completion(.failure(.internetError))
            return
        }
        guard let user = StoregeAPI.currentUser else {return}

        
        let comment = Comment(authorId: user.id, upvote: 0, downvote: 0, commentText: text, id: UUID().uuidString, authorName: user.name, authorPhotoURL: user.photoURL, fcmToken: user.fcmToken)
        
        db.collection("Posts").document(post.id).collection("Comments").addDocument(data: comment.dictionary) { (error) in
            if error != nil{
                completion(.failure(.operationFailed))
            }else{
                completion(.success(comment))
                
                
                
                
            }
        }

    }
    
    func createUser(user: User, completion: @escaping (Result<Void, CustomError>) -> Void){
        
        
        db.collection("Users").document(user.id).getDocument { (document, error) in
            
            if error != nil || document?.data() == nil{
                
                
                self.db.collection("Users").document(user.id).setData(user.dictionary) { (error) in
                    if error != nil{
                        completion(.failure(.operationFailed))
                    }else{
                        StoregeAPI.currentUser = user
                        completion(.success(Void()))
                    }
                }
                
            }else{
                StoregeAPI.currentUser = user
                completion(.success(Void()))
            }
        }
       
        

    }
    
    
    func updateUser(user: User, completion: @escaping (Bool)->()){
        
        let batch : WriteBatch  = db.batch()

           let docRef02 = db.collection("Users").document(user.id)
           docRef02.getDocument { (snapshot, error) in
               if error == nil {
                   
                   if let snap = snapshot{
                    batch.updateData(["fluentLanguage" : user.fluentLanguage, "learningLanguage" : user.learningLanguage as Any], forDocument: snap.reference)
                       completion(true)
                       batch.commit()
                   }
               
               }else{
                    completion(false)
               }
               
           }
           
       }
    
       
    private func hasInternet() -> Bool{
        return Reachability.isConnectedToNetwork()
    }
    
    func updateVotes<T : DocumentSerializable >(from voteType: String, inDocument: T, with comment: Comment?){
       
        let documentRef = db.collection("Posts").document(inDocument.id)
        var newDoc: DocumentReference?
       if let comment = comment{
           let auxDoc = documentRef.collection("Comments").document(comment.id)
            newDoc = auxDoc
       }else{
            newDoc = documentRef
        }
        
        
        guard let sfReference = newDoc else {return}
        db.runTransaction({ (transaction, errorPointer) -> Any? in
            let sfDocument: DocumentSnapshot
            do {
                try sfDocument = transaction.getDocument(sfReference)
            } catch let fetchError as NSError {
                errorPointer?.pointee = fetchError
                return nil
            }

            guard let oldVotes = sfDocument.data()?[voteType] as? Int32 else {
                let error = NSError(
                    domain: "AppErrorDomain",
                    code: -1,
                    userInfo: [
                        NSLocalizedDescriptionKey: "Unable to retrieve votes from snapshot \(sfDocument)"
                    ]
                )
                errorPointer?.pointee = error
                return nil
            }

            // Note: this could be done without a transaction
            //       by updating the population using FieldValue.increment()
            transaction.updateData([voteType: oldVotes + 1], forDocument: sfReference)
            return nil
        }) { (object, error) in
            if let error = error {
                print("Transaction failed: \(error)")
            } else {
                print("Transaction successfully committed!")
            }
        }
        
        
        
    }
    
    
    func removePost(post: Post){
        let documentRef = db.collection("Posts")
        documentRef.document(post.id).delete()
    }

   
    func fetchUser(completion: @escaping (User?, CustomError?)->()){
        if let user = Auth.auth().currentUser {
            let documentRef = db.collection("Users")
            documentRef.whereField("id", isEqualTo: user.uid).getDocuments { (query, error) in
                if error != nil {
                    print("error na hora de buscar o user")
                    completion(nil,.operationFailed)
                }else{
                    if let document = query?.documents.first{
                       let newUser = User(dictionary: document)
                         StoregeAPI.currentUser = newUser
                        completion(newUser,nil)
                    }else{
                        completion(nil, .operationFailed)
                    }
                    

                }
            }
            
        }
    }
 
        
     public func saveImage(userID: String, image: UIImage){
            // Get a reference to the storage service using the default Firebase App
            let storage = Storage.storage()

            // Create a storage reference from our storage service
            let storageRef = storage.reference()
                
            let imageRef = storageRef.child("Users").child(userID).child("profileImage")
            
            if let data = image.jpegData(compressionQuality: 0.2) {
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
                            self.updateUserPhotoUrl(url: url!.absoluteString)
                        }
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
    func teste(){
       
    }
    
    
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


//MARK: -> Update User data
extension StoregeAPI{
    private func updateUserPhotoUrl(url: String){
           guard let user = StoregeAPI.currentUser else{return}

           let batch : WriteBatch  = db.batch()

           updatePosts(url: url, user: user, batch: batch) { (completed) in
               if completed{
                   batch.commit()
                   self.updateComments(url: url, user: user, batch: self.db.batch()) { (completed) in
                       
                       if completed{
                           self.updateUser(url: url, user: user, batch: self.db.batch()) { (completed) in
                               if completed{
                                   self.imageLoader.removeImagefromCache(url: user.photoURL ?? "")
                               }
                           }
                       }
                       
                   }
               }
           }
     
       }
       
       
       
       private func updatePosts(url: String, user: User,batch : WriteBatch , completion: @escaping (Bool)->()){
         
                   
                   let docRef01 = db.collection("Posts").whereField("author.id", isEqualTo: user.id)
                   docRef01.getDocuments { (snapshot, error) in
                       if error == nil {
                   
                           if let snap = snapshot{
                               for doc in snap.documents{
                                   batch.updateData(["author.photoURL" : url], forDocument: doc.reference)
                               }
                               completion(true)
                           }
                           
                       }else{
                           completion(false)
                       }
                   }
       }
       
       
       private func updateComments(url: String, user: User,batch: WriteBatch, completion: @escaping (Bool)->()){
           let docRef03 = db.collection("Posts").document().collection("Comments").whereField("authorId", isEqualTo: user.id)
           
           docRef03.getDocuments { (snapshot, error) in
               if error == nil {
                   
                   if let snap = snapshot{
                       for doc in snap.documents{
                           batch.updateData(["authorPhotoURL" : url], forDocument: doc.reference)
                       }
                       batch.commit()
                      completion(true)
                   }
                   
               }
               completion(false)
           }
       }
       
       private func updateUser(url: String, user: User,batch: WriteBatch, completion: @escaping (Bool)->()){
           let docRef02 = db.collection("Users").document(user.id)
           docRef02.getDocument { (snapshot, error) in
               if error == nil {
                   
                   if let snap = snapshot{
                       batch.updateData(["photoURL" : url], forDocument: snap.reference)
                       completion(true)
                       batch.commit()
                   }
               
               }
               completion(false)
           }
           
       }
    
    
    
    func updateUserName(newName: String, user: User){
        let batch = db.batch()
        let docRef01 = db.collection("Posts").whereField("author.id", isEqualTo: user.id)
        docRef01.getDocuments { (snapshot, error) in
            if error == nil {
                
                if let snap = snapshot{
                    for doc in snap.documents{
                        batch.updateData(["author.name" : newName], forDocument: doc.reference)
                    }
                    batch.commit()
                    self.updateUserNameInComments(newName: newName, user: user)
                }
                
            }
        }
        
    }
    
    private func updateUserNameInComments(newName: String, user: User){
        //segunda atualizacao
        let batch = db.batch()
        let docRef03 = self.db.collection("Posts").document().collection("Comments").whereField("authorId", isEqualTo: user.id)
        
        docRef03.getDocuments { (snapshot, error) in
            if error == nil {
                
                if let snap = snapshot{
                    for doc in snap.documents{
                        batch.updateData(["authorName" : newName], forDocument: doc.reference)
                    }
                    batch.commit()
                    self.updateNameInUser(newName: newName, user: user)
                }
                
            }
            
        }
    }
    
    func updateNameInUser(newName: String, user: User){
        let batch = db.batch()
        let docRef02 = db.collection("Users").document(user.id)
        docRef02.getDocument { (snapshot, error) in
            if error == nil {
                if let snap = snapshot{
                    batch.updateData(["name" : newName], forDocument: snap.reference)
                    batch.commit()
                }
            
            }
        
        }
    }
       
}



//MARK: -> Delete User data
extension StoregeAPI{
    func deleteUserAccount(crendentials: AuthCredential,completion: @escaping (CustomError?)->()){
        guard let user = StoregeAPI.currentUser else{
            completion(.operationFailed)
            return
        }
        
        if !hasInternet(){
            completion(.internetError)
            return
        }
        
        deleteUserPhoto(user: user) { [weak self](completed) in
            guard let self = self else {return}
            if completed{
                let batch : WriteBatch  = self.db.batch()
                
                self.deletePosts(user: user, batch: batch) { (completed) in
                    if completed{
                        batch.commit()
                        self.deleteUser(user: user, batch: self.db.batch()) { (completed) in
                            if completed{
                                
                                Auth.auth().currentUser?.reauthenticate(with: crendentials, completion: { (_, error) in
                                    if let _ = error{
                                        completion(.operationFailed)
                                    }else{
                                        Auth.auth().currentUser?.delete(completion: { (error) in
                                            completion(.none)
                                        })
                                    }
                                })
                                
                            }
                        }
                    }
                }
            }else{
                completion(.operationFailed)
            }
        }
        
    }
       
       
       
       private func deletePosts(user: User,batch : WriteBatch , completion: @escaping (Bool)->()){
         
                   
                   let docRef01 = db.collection("Posts").whereField("author.id", isEqualTo: user.id)
                   docRef01.getDocuments { (snapshot, error) in
                       if error == nil {
                   
                           if let snap = snapshot{
                               for doc in snap.documents{
                                   batch.deleteDocument(doc.reference)
                               }
                               completion(true)
                           }
                           
                       }else{
                           completion(false)
                       }
                   }
       }
       
       
    
       
       private func deleteUser(user: User,batch: WriteBatch, completion: @escaping (Bool)->()){
           let docRef02 = db.collection("Users").document(user.id)
           docRef02.getDocument { (snapshot, error) in
               if error == nil {
                   
                   if let snap = snapshot{
                       batch.deleteDocument(snap.reference)
                       completion(true)
                       batch.commit()
                   }
               
               }
               completion(false)
           }
           
       }
    
    
    private func deleteUserPhoto(user: User, completion: @escaping (Bool)->()){
       
        let storage = Storage.storage()
        
        // Create a storage reference from our storage service
        let storageRef = storage.reference()
        
        let imageRef = storageRef.child("Users").child(user.id).child("profileImage")
        
        imageRef.delete { (_) in
           completion(true)
        }
        
    }
         
       
}
