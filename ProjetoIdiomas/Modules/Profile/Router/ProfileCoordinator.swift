//
//  ProfileCoordinator.swift
//  ProjetoIdiomas
//
//  Created by Rangel Cardoso Dias on 05/06/20.
//  Copyright © 2020 Rangel Cardoso Dias. All rights reserved.
//

//
import Foundation
import UIKit


protocol ProfileDelegate:class {
    func goToEditInfoView(user: User, image: UIImage?)
}


public class ProfileCoordinator: Coordinator{
    
  
        
        
        fileprivate var stateManeger: StateController!
        fileprivate var tabBarController: UITabBarController!
        
        var delegate: ProfileDelegate? = nil
        
        init(stateController: StateController, tabBarController: UITabBarController) {
            self.tabBarController = tabBarController
            self.stateManeger = stateController
        }
        
        
       func start(user: User, image: UIImage?) -> UIViewController{
            let vc = ProfileViewController(nibName: "ProfileViewController", bundle: nil)
            vc.imageProfile = image
            vc.user = user
            let presenter = ProfilePresenter()
            presenter.router = self
            let interator = ProfileInterator(stateController: stateManeger)
            presenter.interator = interator
            vc.presenter = presenter
            return vc
        
        }
        

 

}


extension ProfileCoordinator: ProfilePresenterToRouter{
   
    
    public func goToEditInfoView(user: User, image: UIImage?) {
        delegate?.goToEditInfoView(user: user, image: image)
    }
    
    
    
}
//
//extension ViewActivitiesCoordinator: ViewActivitiesPresenterToRouter{
//    public func goTPost(postID: String) {
//        delegate?.goToPost(id: postID)
//    }
//    
//    public func finishedViewNotication() {
//        delegate?.finishedViewNotication(coordinator: self)
//    }
//    
// }
