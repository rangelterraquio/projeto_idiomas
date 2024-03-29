//
//  ViewActivitiesProtocols.swift
//  ProjetoIdiomas
//
//  Created by Rangel Cardoso Dias on 04/06/20.
//  Copyright © 2020 Rangel Cardoso Dias. All rights reserved.
//

import Foundation
import UIKit

//  var presenter: ViewActivitiesInteratorToPresenter
public protocol ViewActivitiesInteratorToPresenter: class{
    
    func activitiesFetched(activities: [Notifaction]) -> Void
    func fetcheActivitiesFailed(error msg: String) -> Void
     func fetchedAll(_ isFetched: Bool)
}

public protocol ViewActivitiesPresenterToView: class{
    
    func activitiesFetched(activities: [Notifaction]) -> Void
    func showAlertError(error msg: String) -> Void
    func fetchedAll(_ isFetched: Bool)
    
}
public protocol ViewActivitiesPresenterToInterator: class{
   func requestImage(from url: String?, completion: @escaping (Result<UIImage, CustomError>) -> Void) -> UUID?
   func cancelImageRequest(uuid token: UUID)
   func fectchActivities(from date: Date) -> Void
   func updateAcitivityStatus(activity: Notifaction)
   func requestPermissionForNotification()

}

public protocol ViewActivitiesViewToPresenter: class {
    func requestProfileImage(from url: String?, completion:  @escaping  (Result<UIImage, CustomError>) -> Void) -> UUID?
    func cancelImageRequest(uuid token: UUID)
    func updateActivities(from date: Date)
    func goToPost(activity: Notifaction)
    func finishedViewNotication()
    func requestPermissionForNotification()

}


public protocol ViewActivitiesPresenterToRouter: class{
    func finishedViewNotication()
    func goTPost(postID: String)
    //func showErrorAlert(error: String)
}
