//
//  ViewActivitiesPresenter.swift
//  ProjetoIdiomas
//
//  Created by Rangel Cardoso Dias on 04/06/20.
//  Copyright © 2020 Rangel Cardoso Dias. All rights reserved.
//

import Foundation
import UIKit
class ViewActivitiesPresenter: ViewActivitiesViewToPresenter{
   
     var interator: ViewActivitiesPresenterToInterator? = nil
    
    var view: ViewActivitiesPresenterToView? = nil
    
     var router: ViewActivitiesPresenterToRouter? = nil
    
    func requestProfileImage(from url: String?, completion: @escaping (Result<UIImage, CustomError>) -> Void) -> UUID? {
            interator?.requestImage(from: url, completion: completion)
    }
    
    func cancelImageRequest(uuid token: UUID) {
        interator?.cancelImageRequest(uuid: token)
    }
    
    func updateActivities() {
        interator?.fectchActivities()
    }
    
    func goToPost(activity: Notifaction) {
        interator?.updateAcitivityStatus(activity: activity)
        router?.goTPost(postID: activity.postID)
    }
    
    func finishedViewNotication() {
        router?.finishedViewNotication()
    }
   
    
    
    
    
}

extension ViewActivitiesPresenter: ViewActivitiesInteratorToPresenter{
    func activitiesFetched(activities: [Notifaction]) -> Void{
        view?.activitiesFetched(activities: activities)
    }
    
    func fetcheActivitiesFailed(error msg: String) -> Void{
        view?.showAlertError(error: msg)
    }
    
}
