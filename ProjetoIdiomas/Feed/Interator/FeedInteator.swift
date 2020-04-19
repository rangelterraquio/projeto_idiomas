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
   
    var posts: [Post] = [Post](){
        didSet{
            
            if posts.isEmpty{
                presenter?.fecthPostsFailed()
            }else{
                
                presenter?.fechedPosts(posts: posts)
            }
        }
    }
    var profiles: [Profile]?
    var stateController: StateController!
     var presenter: FeedInteratorToPresenter? = nil
    init(stateController: StateController) {
        self.stateController = stateController
        
        
    }
    
    
    public func fechePosts(in languages: [Languages]) {
        
        stateController.fecthPosts(in: languages) {(snapshot) in

            var data: [Post] = [Post]()
            
            for snap in snapshot!{
                
                if let post = Post(dictionary: snap){
                    data.append(post)
                }
            }
            self.posts = data
        }

    }
 
    public func requestImage(from url: String, completion: @escaping (Result<UIImage, Error>) -> Void) -> UUID? {
        stateController.imageLoader.loadImgage(url: url, completion: completion)
    }
    
    public func cancelImageRequest(uuid token: UUID) {
        stateController.imageLoader.cancelLoadRequest(uuid: token)
    }
    
         
         
   
    
}
