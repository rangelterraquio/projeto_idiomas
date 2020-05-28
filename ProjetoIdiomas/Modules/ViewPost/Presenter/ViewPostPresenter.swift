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
    
    
    
    
    
    
    var interator: ViewPostPresenterToInterator? = nil
    var view: ViewPostPresenterToView? = nil
    
    func createComent(comment: String) {
        interator?.createComent(comment: comment)
    }
    
    func requestProfileImage(from url: String, completion: @escaping (Result<UIImage, Error>) -> Void) -> UUID? {
         return UUID()
    }
    
    func cancelImageRequest(uuid token: UUID) {
         print("")
    }
    
    func validadeComment(text: String?) {
        interator?.validadeComment(text: text)
    }
    
   
    func updateVotes<T>(from: String, inDocument: T) where T : DocumentSerializable {
        interator?.requestUpdateVotes(from: from, inDocument: inDocument)
    }

    
}

extension ViewPostPresenter: ViewPostInteratorToPresenter{
    func createPostSuccessefull() {
        print("")
    }
    
    func feactPostFailed(error msg: String) {
        print("")
    }
    
    func commentValidated(isValid: Bool)-> Void{
        view?.commentValidated(isValid: isValid)
    }

}
