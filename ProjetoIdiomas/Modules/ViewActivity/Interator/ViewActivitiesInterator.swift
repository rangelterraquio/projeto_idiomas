//
//  ViewActivitiesInterator.swift
//  ProjetoIdiomas
//
//  Created by Rangel Cardoso Dias on 04/06/20.
//  Copyright © 2020 Rangel Cardoso Dias. All rights reserved.
//

import Foundation
import UIKit


public class ViewActivitiesInterator:ViewActivitiesPresenterToInterator{
    
    
    
    var activiteis: [Notifaction] = [Notifaction](){
        didSet{
            
            if activiteis.isEmpty{
                presenter?.fetcheActivitiesFailed(error: "There is no notifications")
            }else{
                presenter?.activitiesFetched(activities: activiteis)
            }
        }
        
    }
    
    var stateController: StateController!
    var presenter: ViewActivitiesInteratorToPresenter? = nil

    init(stateController: StateController) {
        self.stateController = stateController
    }
    
    public func requestImage(from url: String?, completion: @escaping (Result<UIImage, CustomError>) -> Void) -> UUID? {
        stateController.imageLoader.loadImgage(url: url, completion: completion)
    }
    
    public func cancelImageRequest(uuid token: UUID) {
        stateController.imageLoader.cancelLoadRequest(uuid: token)
    }
    
    public func fectchActivities() {
        stateController.fetchActivites { (snapDocuments) in
            
            var data: [Notifaction] = [Notifaction]()
                
                for snap in snapDocuments!{
                    
                    if let notification = Notifaction(dictionary: snap){
                        data.append(notification)
                    }
                }
                self.activiteis = data
            }
    
    }
    
    public func updateAcitivityStatus(activity: Notifaction) {
        if activity.isViewed {return}
        stateController.upadteActivityStatus(id: activity.id)
    }
    
    
    
    
}

