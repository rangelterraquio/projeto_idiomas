//
//  ViewController.swift
//  ProjetoIdiomas
//
//  Created by Rangel Cardoso Dias on 13/04/20.
//  Copyright © 2020 Rangel Cardoso Dias. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseStorage
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
//        service firebase.storage {
//          match /b/{bucket}/o {
//            match /{allPaths=**} {
//              allow read, write: if request.auth != null;
//            }
//          }
//        }
//        
//        Storage.
//
//        
        let db = Firestore.firestore()
//        let id: String
//        let title: String?
//        let message: String?
//        //let author: ProfileFeed?
//        let publicationDate: Date?
//        let language: Languages.Type?
//        var upvote: Int32?
//        var downvote: Int32?
        
//   
//        
       
//        
//        db.collection("Posts").document("ozE4mkvy97uwd4Oe1D9c").setData(["publicationDate" : Date()], merge: true)
      //  db.collection("Posts").document("gAqKjMeQmgxGoRZqoC1Y").setData(["publicationDate" : Date()], merge: true)
//        
//        
        let user = Profile(id: UUID().uuidString, name: "Joao", photoURL: "sadadad", score: 1, rating: 44, fluentLanguage: ["en","pt"], learningLanguage: ["fr","sp"], idPosts: ["dd","dsada"], idCommentedPosts: ["dd"])
        
//        db.collection("Posts").document("ozE4mkvy97uwd4Oe1D9c").setData(["author" : user.dictionary], merge: true)
        
        let post2 = Post(id: UUID().uuidString, title: "Text review", message: "During development, you can use the public rules in place of the default rules to set your files publicly readable and writable. This is very useful for prototyping, as you can get started without setting up Firebase Authentication. However, because Cloud Storage shares a bucket with your default Google App Engine app, this rule also makes any data used by .", language: Languages.english.rawValue, upvote: 444, downvote: 35, publicationDate: Date(), author: user)
        
      //  db.collection("Posts").addDocument(data: post2.dictionary)

        
        let storageRef = StoregeAPI()
        if let image = UIImage(named: "photo2"){

//
//            storageRef.saveImage(userID: "photo2", image: image)
        }
        
        
    }

    @IBAction func goToFeed(_ sender: Any) {
        
        let stateController = StateController(storage: StoregeAPI())
        let interator = FeedInterator(stateController: stateController)
        let presenter = FeedPresenter()
        presenter.interator = interator
        interator.presenter = presenter
        let vc = FeedViewController(nibName: "FeedViewController", bundle: nil)
        vc.presenter = presenter
        presenter.view = vc
        
        
        self.present(vc, animated: true, completion: nil)
        

        
    }
    
}

