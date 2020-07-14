//
//  ProfileProtocols.swift
//  ProjetoIdiomas
//
//  Created by Rangel Cardoso Dias on 05/06/20.
//  Copyright © 2020 Rangel Cardoso Dias. All rights reserved.
//

import Foundation
import UIKit

//  var presenter: ViewActivitiesInteratorToPresenter
public protocol ProfileInteratorToPresenter: class{
    
    func activitiesFetched(activities: [Notifaction]) -> Void
    func fetcheActivitiesFailed(error msg: String) -> Void
 
}

public protocol ProfilePresenterToView: class{
    
    func activitiesFetched(activities: [Notifaction]) -> Void
    func showAlertError(error msg: String) -> Void
    
}
public protocol ProfilePresenterToInterator: class{
   func requestImage(from url: String?, completion: @escaping (Result<UIImage, CustomError>) -> Void) -> UUID?
   func cancelImageRequest(uuid token: UUID)
   

}

public protocol ProfileViewToPresenter: class {
    func requestProfileImage(from url: String?, completion:  @escaping  (Result<UIImage, CustomError>) -> Void) -> UUID?
    func cancelImageRequest(uuid token: UUID)
    func goToEditInfoView(user: User, image: UIImage?)
    func goToSettings()
    func goToUserActivities()
}


public protocol ProfilePresenterToRouter: class{
    func goToEditInfoView(user: User, image: UIImage?)
    func goToSettings()
    func goToUserActivities()
}
