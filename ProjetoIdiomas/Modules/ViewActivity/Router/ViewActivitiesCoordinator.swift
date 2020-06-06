//
//  ViewActivitiesCoordinator.swift
//  ProjetoIdiomas
//
//  Created by Rangel Cardoso Dias on 05/06/20.
//  Copyright © 2020 Rangel Cardoso Dias. All rights reserved.
//

import Foundation
import UIKit


protocol ViewActivitiesDelegate:class {
    func finishedViewNotication(coordinator: Coordinator)
    func goToPost(id: String)
}


public class ViewActivitiesCoordinator: Coordinator{
    
  
        
        
        fileprivate var stateManeger: StateController!
        fileprivate var tabBarController: UITabBarController!
        
        var delegate: ViewActivitiesDelegate? = nil
        
        init(stateController: StateController, tabBarController: UITabBarController) {
            self.tabBarController = tabBarController
            self.stateManeger = stateController
        }
        
        
        func start(user: User) -> UIViewController{
            let vc = ViewActivityViewController(nibName: "ViewActivityViewController", bundle: nil)
            let presenter = ViewActivitiesPresenter()
            let interator = ViewActivitiesInterator(stateController: stateManeger)
            presenter.interator = interator
            presenter.view = vc
            presenter.router = self
            vc.presenter = presenter
            interator.presenter = presenter
            
            vc.listener = stateManeger.addActivityListener(user: user, activitiesVC: vc)
            
            
            return vc
            //modo de apresentação
            //             vc.modalPresentationStyle = .overCurrentContext
            //            if let oldVc = tabBarController.viewControllers?.first as? UINavigationController{
            //                oldVc.definesPresentationContext = true
            //                oldVc.title = "Create Post"
            //                oldVc.pushViewController(vc, animated: true)
            //            }
        }
        

 

}


extension ViewActivitiesCoordinator: ViewActivitiesPresenterToRouter{
    public func goTPost(postID: String) {
        delegate?.goToPost(id: postID)
    }
    
    public func finishedViewNotication() {
        delegate?.finishedViewNotication(coordinator: self)
    }
    
 }
