//
//  ViewPostProtocols.swift
//  ProjetoIdiomas
//
//  Created by Rangel Cardoso Dias on 11/05/20.
//  Copyright © 2020 Rangel Cardoso Dias. All rights reserved.
//


import Foundation
import UIKit
//  var presenter: FeedInteratorToPresenter
public protocol ViewPostInteratorToPresenter: class{
    
    func createPostSuccessefull()-> Void
    func feactPostFailed(error msg: String) -> Void
     func commentValidated(isValid: Bool)-> Void
}

public protocol ViewPostPresenterToView: class{
    
    func commentValidated(isValid: Bool)-> Void
    func showAlertError(error msg: String) -> Void
}
public protocol ViewPostPresenterToInterator: class{
   func requestImage(from url: String, completion: @escaping (Result<UIImage, Error>) -> Void) -> UUID?
   func cancelImageRequest(uuid token: UUID)
   func requestUpdateVotes<T: DocumentSerializable>(from: String, inDocument: T)
   func createComent(comment: String) -> Void
   func validadeComment(text: String?) ->Void
}

public protocol ViewPostViewToPresenter: class {
    func createComent(comment: String) -> Void
    func requestProfileImage(from url: String, completion:  @escaping  (Result<UIImage, Error>) -> Void) -> UUID?
    func cancelImageRequest(uuid token: UUID)
    func validadeComment(text: String?) ->Void
    func updateVotes<T: DocumentSerializable>(from: String, inDocument: T)
}
