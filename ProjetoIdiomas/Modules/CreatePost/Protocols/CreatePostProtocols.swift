//
//  CreatePostProtocols.swift
//  ProjetoIdiomas
//
//  Created by Rangel Cardoso Dias on 10/05/20.
//  Copyright © 2020 Rangel Cardoso Dias. All rights reserved.
//

import Foundation
import Foundation

//  var presenter: FeedInteratorToPresenter
public protocol CreatePostInteratorToPresenter: class{
    
    func createPostSuccessefull()-> Void
    func createPostFailed(error msg: String) -> Void
    
}

public protocol CreatePostPresenterToView: class{
    
    func updateDoneStatus() -> Void
    func showAlertError(error msg: String) -> Void
}
public protocol CreatePostPresenterToInterator: class{
    
   func postIsValid(title: String, text: String, language: Languages?)  -> Bool
   func createPost(title: String, text: String, language: Languages?) -> Void
}

public protocol CreatePostViewToPresenter: class {
    func createPost(title: String, text: String, language: Languages?) -> Void
    func validatePost(title: String, text: String, language: Languages?) -> Void
    
}