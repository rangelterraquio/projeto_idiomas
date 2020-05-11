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
    
    func createPost(title: String, text: String, language: Languages,completion: @escaping (Result<Void, CustomError>) -> Void){
        //let user  = Auth.auth().currentUser!
        
        ///quado tiver tudo funcionado eu vou ter a referencia do user q estiver logado
        
        if !hasInternet(){
            completion(.failure(.internetError))
            return
        }
         let user = User(id: UUID().uuidString, name: "Joao", photoURL: "sadadad", score: 1, rating: 44, fluentLanguage: ["en","pt"], learningLanguage: ["fr","sp"], idPosts: ["dd","dsada"], idCommentedPosts: ["dd"])
        
        
        let newPost = Post(id: UUID().uuidString, title: title, message: text, language: language.rawValue, upvote: 0, downvote: 0, publicationDate: Date(), author: user)
        
        db.collection("Posts").addDocument(data: newPost.dictionary) { (error) in
            if error != nil{
                completion(.failure(.operationFailed))
            }else{
                completion(.success(Void()))
            }
        }

    }
    
    private func hasInternet() -> Bool{
        return Reachability.isConnectedToNetwork()
    }
    
    func updateVotes(from voteType: String, inPost: Post){
        //quando a criação de post tiver ok deixa mudar o id
        let documentRef = db.collection("Posts").document(inPost.id)
        guard var num = inPost.dictionary[voteType] as? Int16 else {
            print("error")
            return
        }
        num += 1
        documentRef.setData([voteType : num], merge: true)
        
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