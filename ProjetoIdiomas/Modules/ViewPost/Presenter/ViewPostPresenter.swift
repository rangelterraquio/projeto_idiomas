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
    
    func createComent(comment: String, postID: String) {
        interator?.createComent(comment: comment, postID: postID)
    }
    
    func requestProfileImage(from url: String, completion: @escaping (Result<UIImage, Error>) -> Void) -> UUID? {
        interator?.requestImage(from: url, completion: completion)
    }
    
    func cancelImageRequest(uuid token: UUID) {
        interator?.cancelImageRequest(uuid: token)
    }
    
    func validadeComment(text: String?) {
        interator?.validadeComment(text: text)
    }
    
   
    func updateVotes<T>(from: String, inDocument: T) where T : DocumentSerializable {
        interator?.requestUpdateVotes(from: from, inDocument: inDocument)
    }
    
    func finishViewPostSession() {
        router?.finishedViewPostOperation()
    }

    
}

extension ViewPostPresenter: ViewPostInteratorToPresenter{
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
