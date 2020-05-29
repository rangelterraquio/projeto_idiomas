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
}
class SelectLanguagesCoordinator: Coordinator {
    
    var user: User!
    var navigationController: UINavigationController
    var delegate: SelectLanguagesCoordinatorDelegate? = nil
    
    init(user: User, navigation: UINavigationController) {
        self.user = user
        self.navigationController = navigation
    }
    
    func stat(user: User) -> Void {
        let vc = SelectLanguageViewController(nibName: "SelectLanguageViewController", bundle: nil)
        vc.user = user
        vc.router = self
       guard let topViewController = navigationController.topViewController else {
           return navigationController.setViewControllers([vc], animated: false)
       }
       
       UIView.transition(from:topViewController.view, to: vc.view, duration: 0.50, options: .transitionCrossDissolve) {[unowned self] (_) in
           self.navigationController.setViewControllers([vc], animated: false)
       }
    }
    
}

extension SelectLanguagesCoordinator: SelectLanguagesToPresenter{
    func didSuccessfullyCreated(user: User) {
        delegate?.coordinatorDidCreate(coordinator: self, user: user)
        
    }
    
    func cancelUserCreation() {
        delegate?.coordinatorDidCancel(coordinator: self)
    }
    
}
