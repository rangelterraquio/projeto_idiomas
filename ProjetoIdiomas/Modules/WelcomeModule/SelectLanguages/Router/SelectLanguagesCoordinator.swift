//
//  SelectLanguagesCoordinator.swift
//  ProjetoIdiomas
//
//  Created by Rangel Cardoso Dias on 28/05/20.
//  Copyright © 2020 Rangel Cardoso Dias. All rights reserved.
//

import Foundation
import UIKit


protocol SelectLanguagesCoordinatorDelegate:class {
    func coordinatorDidCreate(coordinator: Coordinator, user: User)
    func coordinatorDidCancel(coordinator: Coordinator)
    func didSelectTeachingLanguages(user: User, state: ViewState, languagesVC: SelectLanguageViewController)

}
class SelectLanguagesCoordinator: Coordinator {
    
    var user: User!
    var tabBarController: UITabBarController!
    var delegate: SelectLanguagesCoordinatorDelegate? = nil
    
    init(user: User, tabBarController: UITabBarController) {
        self.user = user
        self.tabBarController = tabBarController
    }
    
    func stat(user: User) -> SelectLanguageViewController {
        let vc = SelectLanguageViewController(nibName: "SelectLanguageViewController", bundle: nil)
        vc.user = user
        vc.router = self
        
        return vc
//        vc.modalPresentationStyle = .overCurrentContext
//        if let oldVc = tabBarController.viewControllers?.first as? UINavigationController{
//            oldVc.definesPresentationContext = true
//            oldVc.title = "Sign In"
//            oldVc.pushViewController(vc, animated: true)
//        }
//       guard let topViewController = navigationController.topViewController else {
//           return navigationController.setViewControllers([vc], animated: false)
//       }
//
//       UIView.transition(from:topViewController.view, to: vc.view, duration: 0.50, options: .transitionCrossDissolve) {[unowned self] (_) in
//           self.navigationController.setViewControllers([vc], animated: false)
//       }
    }
    
}

extension SelectLanguagesCoordinator: SelectLanguagesToPresenter{
    func didSelectTeachingLanguages(user: User, state: ViewState,languagesVC: SelectLanguageViewController) {
        delegate?.didSelectTeachingLanguages(user: user, state: state, languagesVC: languagesVC)
    }
    
    func didSuccessfullyCreated(user: User) {
        delegate?.coordinatorDidCreate(coordinator: self, user: user)
        
    }
    
    func cancelUserCreation() {
        delegate?.coordinatorDidCancel(coordinator: self)
    }
    
}
