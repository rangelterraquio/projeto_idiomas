//
//  ViewPostInterator.swift
//  ProjetoIdiomas
//
//  Created by Rangel Cardoso Dias on 27/05/20.
//  Copyright © 2020 Rangel Cardoso Dias. All rights reserved.
//

import Foundation
import UIKit
class ViewPostInterator: ViewPostPresenterToInterator {
    
    var stateController: StateController!
    var presenter: ViewPostInteratorToPresenter? = nil
    
    var comments: [Comment] = [Comment](){
        didSet{
            if comments.isEmpty{
                presenter?.fetcheCommentFailed(error: "Não tem comentários")
            }else{
                presenter?.fetchCommentSuccessefull(comments: comments)
            }
        }
    }
    init(stateController: StateController) {
        self.stateController = stateController
        
        
    }
    
    
    func createComent(comment: String, post: Post) {
        stateController.createComment(text: comment, post: post) { (result) in
            
            switch result {
            case .failure(let error):
                switch error {
                case .internetError:
                    self.presenter?.createCommentFailed(error: "The phone has no Internet connection")
                case .operationFailed:
                    self.presenter?.createCommentFailed(error: "Sorry, an error occurred.")
                }
            case .success(let com):
                self.presenter?.createCommentSuccessefull(comment: com)
                self.stateController.sendNotification(post: post, comment: com)
            }
            
        }
    }
    
    
    func fetchCommments(in post: Post, startingBy num: Int32){
        
        stateController.fetchComments(in: post, startingBy: num) { (snapshotQuery) in
            
            guard let snapshot = snapshotQuery else {return}
            var data: [Comment] = [Comment]()
            
            for snap in snapshot{
                if let comment = Comment(dictionary: snap){
                    data.append(comment)
                }
            }
            self.comments = data
            
            if self.comments.count < 20{
                self.presenter?.fetchedAll(true)
            }else{
                self.presenter?.fetchedAll(false)
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
    
    func validadeComment(text: String?) {
        
        presenter?.commentValidated(isValid: !(text?.isEmpty ?? true) )
    }
    
    
    func reportPost(post: Post) {
        self.stateController.reportPost(post: post)
    }
     
     func reportComment(comment: Comment, inPost: Post) {
         self.stateController.reportComment(comment: comment, inPost: inPost)
     }
     
    
}
