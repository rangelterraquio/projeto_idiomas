//
//  SelectLanguagesProtocols.swift
//  ProjetoIdiomas
//
//  Created by Rangel Cardoso Dias on 09/05/20.
//  Copyright © 2020 Rangel Cardoso Dias. All rights reserved.
//

import Foundation
import UIKit
//  var presenter: FeedInteratorToPresenter
public protocol SelectLanguagesInteratorToPresenter: class{
    
    
    
}

public protocol SelectLanguagesPresenterToView: class{
   
}
public protocol SelectLanguagesPresenterToInterator: class{
    
   
}

public protocol SelectLanguagesViewToPresenter: class {
    
    
}
public protocol SelectLanguagesToPresenter{
    func didSuccessfullyCreated(user: User)
    func cancelUserCreation()
    func didSelectTeachingLanguages(user: User, state: ViewState,languagesVC: SelectLanguageViewController)
}

public protocol WalkThroughOnBoardDelegate: class{
    func goNextPage(fowardTo page: PageOnBoarding)
    func goBeforePage(reverseTo page: PageOnBoarding)
}


public protocol OnBoardingPage: UIViewController{
    var pageDelegate: WalkThroughOnBoardDelegate? { get set }
}
