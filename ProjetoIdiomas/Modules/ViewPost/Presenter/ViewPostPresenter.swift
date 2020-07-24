//
//  ViewPostPresenter.swift
//  ProjetoIdiomas
//
//  Created by Rangel Cardoso Dias on 12/05/20.
//  Copyright © 2020 Rangel Cardoso Dias. All rights reserved.
//

import Foundation
import UIKit
class ViewPostPresenter: ViewPostViewToPresenter{
    
    
    
    
    
    
    
    var router: ViewPostPresenterToRouter? = nil
    var interator: ViewPostPresenterToInterator? = nil
    var view: ViewPostPresenterToView? = nil
    
    func createComent(comment: String, post: Post) {
        interator?.createComent(comment: comment, post: post)
    }
    
    func requestProfileImage(from url: String?, completion: @escaping (Result<UIImage, CustomError>) -> Void) -> UUID? {
        interator?.requestImage(from: url, completion: completion)
    }
    
    func cancelImageRequest(uuid token: UUID) {
        interator?.cancelImageRequest(uuid: token)
    }
    
    func validadeComment(text: String?) {
        interator?.validadeComment(text: text)
    }
    
   
    func updateVotes<T>(from: String, inDocument: T, with comment: Comment?) where T : DocumentSerializable {
        interator?.requestUpdateVotes(from: from, inDocument: inDocument, with: comment)
    }
    
    func finishViewPostSession() {
        router?.finishedViewPostOperation()
    }

    func updateFeed(from post: Post, startingBy votesNum: Int32) {
        interator?.fetchCommments(in: post, startingBy: votesNum)
    }
    
}

extension ViewPostPresenter: ViewPostInteratorToPresenter{
  
    func fetchedAll(_ isFetched: Bool) {
        view?.fetchedAll(isFetched)
    }

    func fetchCommentSuccessefull(comments: [Comment]) {
        view?.showComments(comments: comments)
    }
    
    func fetcheCommentFailed(error msg: String) {
        ///no futuro posso tratar algum erro aqui
        print("Post sem comentários")
        view?.showComments(comments: [Comment]())
    }
    
    func createCommentSuccessefull(comment: Comment) {
        view?.commentCreated(comment: comment)
    }
    
    func createCommentFailed(error msg: String) {
        view?.showAlertError(error: msg)
    }
    
    func commentValidated(isValid: Bool)-> Void{
        view?.commentValidated(isValid: isValid)
    }

}
