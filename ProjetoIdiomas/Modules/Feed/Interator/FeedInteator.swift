//
//  FeedInteator.swift
//  ProjetoIdiomas
//
//  Created by Rangel Cardoso Dias on 13/04/20.
//  Copyright © 2020 Rangel Cardoso Dias. All rights reserved.
//

import Foundation
import FirebaseFirestore

public class FeedInterator: FeedPresenterToInterator{
    
    
    
    
   
    var posts: [Post] = [Post]()//{
//        didSet{
//
//            if !posts.isEmpty{
//                presenter?.fecthPostsFailed(fetchedAll: false)
//            }else{
//
//                presenter?.fechedPosts(posts: posts)
//            }
//        }
//    }
    var profiles: [User]?
    var stateController: StateController!
    var presenter: FeedInteratorToPresenter? = nil
    
  
    var listener: ListenerRegistration!
    init(stateController: StateController) {
        self.stateController = stateController
        
       
    }
    
    func addListener(){
        let updateStatus: ([Post])->() = {posts in
            self.presenter?.newPostAdded(posts: posts)
        }
        listener = stateController.addNewPostsListener(updateStatus: updateStatus)
    }
    
    public func fechePosts(in languages: [Languages],from date: Date) {
        
        stateController.fecthPosts(in: languages, from: date) {(snapshot) in

            var data: [Post] = [Post]()
            
            for snap in snapshot!{
                
                if let post = Post(dictionary: snap){
                    data.append(post)
                }
            }
            self.posts = data
            
            if self.posts.isEmpty{
                self.presenter?.fecthPostsFailed(fetchedAll: true)
            }else{
                if self.posts.count < 50{
                    self.presenter?.fecthPostsFailed(fetchedAll: true)
                }else{
                    self.presenter?.fecthPostsFailed(fetchedAll: false)
                }
                self.presenter?.fechedPosts(posts: self.posts, languages: languages)
            }
        }

    }
 
    public func requestImage(from url: String?, completion: @escaping (Result<UIImage, CustomError>) -> Void) -> UUID? {
        stateController.imageLoader.loadImgage(url: url, completion: completion)
    }
    
    public func cancelImageRequest(uuid token: UUID) {
        stateController.imageLoader.cancelLoadRequest(uuid: token)
    }
    
    
    public func requestUpdateVotes<T : DocumentSerializable >(from: String, inDocument: T, with comment: Comment?) {
        stateController.updateVotes(from: from, inDocument: inDocument, with: comment)
    }
    
    deinit {
        listener.remove()
    }
    
}
