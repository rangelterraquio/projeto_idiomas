//
//  AppCoordinator.swift
//  ProjetoIdiomas
//
//  Created by Rangel Cardoso Dias on 28/05/20.
//  Copyright © 2020 Rangel Cardoso Dias. All rights reserved.
//

import Foundation
import UIKit
public class Coordinator: NSObject {}

final class AppCoordinator: Coordinator{
    
    fileprivate let tabBarController: UITabBarController!
    fileprivate var childCoordinators = [Coordinator]()
    fileprivate let storage = StoregeAPI()
    fileprivate var stateManeger: StateController!
    fileprivate let signUpAPI = SignUpAPI()
    
    init(tabBarController: UITabBarController) {
        self.tabBarController = tabBarController
//        signUpAPI.signOut()
        stateManeger = StateController(storage:storage)
    }
    
    
    func start(){
        if signUpAPI.userHasAValidSession(){
            storage.fetchUser { user,Error in
                self.setupTabBar(user: user!)
            }
            
        }else{
            
            let vc = showAuthentication()
            let nav = UINavigationController(rootViewController: vc)
            tabBarController.viewControllers = [nav]
        }
    }
    
    
    
    private func setupTabBar(user: User){
        
        
        
        if let feedControler = showFeed(){
            feedControler.tabBarItem = UITabBarItem(tabBarSystemItem: .mostViewed, tag: 0)
            
            let activitiesVC = showActivities(user: user)
            
            activitiesVC.tabBarItem = UITabBarItem(tabBarSystemItem: .history, tag: 1)
            
            let profileVC = showProfile(user: user)
            profileVC.tabBarItem = UITabBarItem(tabBarSystemItem: .contacts, tag: 2)
            
            let controllers = [feedControler,activitiesVC,profileVC].map { (viewController) -> UINavigationController in
                UINavigationController(rootViewController: viewController)
            
        }
            
            
            tabBarController.viewControllers = controllers
            
            //Appearence
            tabBarController.tabBar.barTintColor = .green

            
        }
        
        
        
    }
    
    
    func showFeed() -> UIViewController?{
        //return
//        let newChild = childCoordinators.first(where: {$0 is ViewPostCoordinator})
//        if let _  = newChild {
//            return nil
//        }
        let coordinator = FeedCoordinator(stateController: stateManeger, tabBarController: tabBarController)
        childCoordinators.append(coordinator)
        coordinator.delegate = self
        let newArray = childCoordinators.filter {!($0 is SignUpCoordinator)}
        childCoordinators = newArray
        return coordinator.start()

    }
    
    func showAuthentication() -> UIViewController{
        let signUpCoordinator = SignUpCoordinator(signUpAPI: signUpAPI, tabBarController: tabBarController)
        signUpCoordinator.delegate = self
        childCoordinators.append(signUpCoordinator)//adiciono no childrem para o appcoordinator nao ser desalocado
        
         return signUpCoordinator.start()
    }
    
    func showSelectLanguage(with user: User){
        let coordinator = SelectLanguagesCoordinator(user: user, tabBarController: tabBarController)
        coordinator.delegate = self
        coordinator.stat(user: user)
        childCoordinators.append(coordinator)
    }
    
    func showCreatePost(){
        let coordinator = CreatePostCoordinator(stateController: stateManeger, tabBarController: tabBarController)
        coordinator.delegate = self
        childCoordinators.append(coordinator)
        coordinator.start()

    }
    
    func showViewPostInDetails(post: Post,imageProfile: UIImage?){
         let coordinator = ViewPostCoordinator(stateController: stateManeger, tabBarController: tabBarController)
        coordinator.delegate = self
        coordinator.start(post: post,imageProfile: imageProfile)
//        coordinator.start(post: post, imageProfile: imageProfile, currentView: vc)
        childCoordinators.append(coordinator)
        
    }
    func showViewPostInDetails(postID: String){
        storage.fetchUser {_,_ in}
         let coordinator = ViewPostCoordinator(stateController: stateManeger, tabBarController: tabBarController)
        coordinator.delegate = self
        coordinator.start(postID: postID)
        childCoordinators.append(coordinator)
        
    }
    
    func showActivities(user: User) -> UIViewController{
        let coordinator = ViewActivitiesCoordinator(stateController: stateManeger, tabBarController: tabBarController)
        coordinator.delegate = self
        childCoordinators.append(coordinator)
        return coordinator.start(user: user)
    }
    
    func showProfile(user: User) -> UIViewController{
         let coordinator = ProfileCoordinator(stateController: stateManeger, tabBarController: tabBarController)
         coordinator.delegate = self
         childCoordinators.append(coordinator)
        return coordinator.start(user: user, image: UIImage(named: "joseph"))
     }
    
    func showEditInfoView(user: User, image: UIImage?){
        let vc = EditInformationViewController(nibName: "EditInformationViewController", bundle: nil)
        vc.stateController = stateManeger
        vc.user = user
        vc.image = image
        
        vc.modalPresentationStyle = .overCurrentContext
        if let oldVc = self.tabBarController.selectedViewController as? UINavigationController{
            oldVc.definesPresentationContext = true
          
            oldVc.pushViewController(vc, animated: true)
        }
    }
    
}


//MARK: -> Authetication Delegate
extension AppCoordinator: AuthenticationCoordinatorDelegate{
    func coordinatorDidAuthenticateWithUser(coordinator: SignUpCoordinator) {
        removeCoordinator(coordinator: coordinator)
        self.setupTabBar(user: StoregeAPI.currentUser!)
    }
    
    
    
    func coordinatorDidAuthenticate(coordinator: SignUpCoordinator,user: User) {
        //chamar selecte language
//        removeCoordinator(coordinator: coordinator)
        showSelectLanguage(with: user)
    }
    
    
    fileprivate func removeCoordinator(coordinator:Coordinator) {
        let newArray = childCoordinators.filter {$0 !== coordinator}
        childCoordinators = newArray
        
    }
    
}
//MARK: -> Select Language Delegate
extension AppCoordinator: SelectLanguagesCoordinatorDelegate{
  
    
    func coordinatorDidCreate(coordinator: Coordinator, user: User) {
        removeCoordinator(coordinator: coordinator)
        stateManeger.createUser(user: user) { (result) in
            switch result{
            case .success(_):
                self.stateManeger.user = user
                self.start()
            case .failure(_):
                fatalError("Deu mt ruim cusão")
            }
        }
    }
    
    func coordinatorDidCancel(coordinator: Coordinator) {
        signUpAPI.deleteCurrentUser()
        removeCoordinator(coordinator: coordinator)
        
       
        childCoordinators.forEach { (coordinator) in
            DispatchQueue.main.async {
                if let coo = coordinator as? SignUpCoordinator{
                    let vc = coo.start()
                    vc.modalPresentationStyle = .overCurrentContext
                    if let oldVc = self.tabBarController.viewControllers?.first as? UINavigationController{
                        oldVc.definesPresentationContext = true
                        oldVc.title = "Create Post"
                        oldVc.pushViewController(vc, animated: true)
                    }
                }
            }
        }
    }
    
    
}


//MARK: -> Create Post Delegate
extension AppCoordinator: CreatePostDelegate{
    func createPostFinished(coordinator: Coordinator) {
        removeCoordinator(coordinator: coordinator)
//        navigationController.popViewController(animated: true)
        if let nav = tabBarController.viewControllers?.first as? UINavigationController{
            nav.popViewController(animated: true)
        }
    }
}

//MARK: -> Create Post Delegate
extension AppCoordinator: FeedCoordinatorDelegate{
  
    
    func chooseCreatePostView() {
        showCreatePost()
    }
    
    func chooseViewPostDetails(post: Post,imageProfile: UIImage?, vc: UIViewController) {
        showViewPostInDetails(post: post,imageProfile: imageProfile)
    }
    
    
}

//MARK: -> View Post Delegate
extension AppCoordinator: ViewPostDelegate{
    
    func viewPostFinished(coordinator: Coordinator) {
        removeCoordinator(coordinator: coordinator)
//        navigationController.popViewController(animated: true)
        childCoordinators.forEach { (coordinator) in
            DispatchQueue.main.async {
                if let coo = coordinator as? FeedCoordinator{
                    coo.start()
                    return
                }
            }
        }
        showFeed()
    }
}


extension AppCoordinator: UITabBarDelegate{
    
    
    func addTabBar(){
        
        
    }
}
//MARK: -> View activities Delegate
extension AppCoordinator: ViewActivitiesDelegate{
    func finishedViewNotication(coordinator: Coordinator) {
        removeCoordinator(coordinator: coordinator)

    }
    
    func goToPost(id: String) {
        showViewPostInDetails(postID: id)
    }
    
    
}


//MARK: -> View activities Delegate
extension AppCoordinator: ProfileDelegate{
    func goToEditInfoView(user: User, image: UIImage?) {
        showEditInfoView(user: user, image: image)
    }
    
    
    
    
    
    
    
    
}
