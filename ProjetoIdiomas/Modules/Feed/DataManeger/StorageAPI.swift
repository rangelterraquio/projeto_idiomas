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
