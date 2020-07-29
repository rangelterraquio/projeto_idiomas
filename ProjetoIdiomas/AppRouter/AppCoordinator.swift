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
    fileprivate var user: User!
    var pushNotificationManeger: PushNotificationManager!
    
    init(tabBarController: UITabBarController) {
        self.tabBarController = tabBarController
//        signUpAPI.signOut()
        stateManeger = StateController(storage:storage)
    }
    
    
    func start(){
        
        
        if signUpAPI.userHasAValidSession(){
            addLoadScreen()
            storage.fetchUser { user,Error in
                self.setupTabBar(user: user!)
                self.user = user!
            }
            
        }else{
            
            let vc = showAuthentication()
            let nav = UINavigationController(rootViewController: vc)
            tabBarController.viewControllers = [nav]
        }
    }
    
    
    private func addLoadScreen(){
        let loadScreen = LoadingScreen(frame: CGRect(origin:UIScreen.main.bounds.origin, size: UIScreen.main.bounds.size))
        let vcTemp = ViewController()
        vcTemp.view.addSubview(loadScreen)
        self.tabBarController.viewControllers = [vcTemp]
    }
    private func setupTabBar(user: User){
        
        
        
        if let feedControler = showFeed(){
            feedControler.tabBarItem = UITabBarItem(title: "Feed", image: UIImage(named: "feedIcon"), tag: 0)
            (feedControler as! FeedViewController).user = user
            let activitiesVC =  showCreatePost()//showActivities(user: user)
            
            activitiesVC.tabBarItem = UITabBarItem(title: "Add Post", image: UIImage(named: "addPost"), tag: 1)//UITabBarItem(tabBarSystemItem: .history, tag: 1)
            
            let profileVC = showActivities(user: user)//showProfile(user: user)
            profileVC.tabBarItem = UITabBarItem(title: "Notifications", image: UIImage(named: "Notification"), tag: 2)
            
            
           
            let controllers = [feedControler,activitiesVC,profileVC].map { (viewController) -> UINavigationController in
                UINavigationController(rootViewController: viewController)
            
        }
            
            
            tabBarController.viewControllers = controllers
            
            //Appearence
            tabBarController.tabBar.barTintColor = .white
            tabBarController.tabBar.tintColor = UIColor(red: 29/255, green: 37/255, blue: 100/255, alpha: 1.0)

            
            if PushNotificationManager.flag{
                showViewPostInDetails(postID: PushNotificationManager.postID!) { (vc) in
                    feedControler.navigationController?.pushViewController(vc, animated: true)
                }
            }
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
    
    func showOnBoard(with user: User, state: ViewState, languagesVC: SelectLanguageViewController?){
        let vc = state == .learningLanguagesSection ? LearningOnBoardViewController(nibName: "LearningOnBoardViewController", bundle: nil) : TeachingOnBoardViewController(nibName: "TeachingOnBoardViewController", bundle: nil)
        vc.user = user
        vc.languagesVC = languagesVC
//        let coordinator = SelectLanguagesCoordinator(user: user, tabBarController: tabBarController)
//        coordinator.delegate = self
//        coordinator.stat(user: user)
//        childCoordinators.append(coordinator)
//
        vc.delegate = self
        vc.modalPresentationStyle = .overCurrentContext
        if let oldVc = self.tabBarController.selectedViewController as? UINavigationController{
            oldVc.definesPresentationContext = true
            
            oldVc.pushViewController(vc, animated: true)
        }
    }
    
    func showSignInWithEmail(){
        let coordinator = SignInEmailPasswordCoordinator(signUpAPI: signUpAPI, storage: storage, tabBarController: tabBarController)
        coordinator.delegate = self
        coordinator.start()
        childCoordinators.append(coordinator)
    }
    func showCreatePost() -> UIViewController{
        let coordinator = CreatePostCoordinator(stateController: stateManeger, tabBarController: tabBarController)
        coordinator.delegate = self
        childCoordinators.append(coordinator)
        return coordinator.start()

    }
    
    func showViewPostInDetails(post: Post,imageProfile: UIImage?,vc: UIViewController?){
         let coordinator = ViewPostCoordinator(stateController: stateManeger, tabBarController: tabBarController)
        coordinator.delegate = self
//        coordinator.start(post: post,imageProfile: imageProfile)
        coordinator.start(post: post, imageProfile: imageProfile, feedVC: vc)
        childCoordinators.append(coordinator)
        
    }
    func showViewPostInDetails(postID: String,completio: @escaping (UIViewController)->()){
//        storage.fetchUser {_,_ in}
         let coordinator = ViewPostCoordinator(stateController: stateManeger, tabBarController: tabBarController)
        coordinator.delegate = self
        
        childCoordinators.append(coordinator)
        coordinator.start(postID: postID, completio: completio)
    }
    
    func showViewPostInDetails(postID: String){
        let coordinator = ViewPostCoordinator(stateController: stateManeger, tabBarController: tabBarController)
        coordinator.delegate = self
        
        childCoordinators.append(coordinator)
        coordinator.start(postID: postID)
    }
    func showActivities(user: User) -> UIViewController{
        let coordinator = ViewActivitiesCoordinator(stateController: stateManeger, tabBarController: tabBarController)
        coordinator.delegate = self
        childCoordinators.append(coordinator)
        return coordinator.start(user: user)
    }
    
    func showProfile(user: User){
         let coordinator = ProfileCoordinator(stateController: stateManeger, tabBarController: tabBarController)
         coordinator.delegate = self
         childCoordinators.append(coordinator)
         coordinator.start(user: user, notificationManeger: pushNotificationManeger)
     }
    
    func showReauthetication(){
        let coordinator = ReAutheticationCoordinator(stateController: stateManeger, signUpAPI: signUpAPI, tabBarController: tabBarController)
        coordinator.manegeAccountelegate = self
        childCoordinators.append(coordinator)
        coordinator.start()
    }
    
    func showEditInfoView(user: User, image: UIImage?){
        let vc = EditInformationViewController(nibName: "EditInformationViewController", bundle: nil)
        vc.stateController = stateManeger
        vc.user = user
        vc.image = image
        vc.manegeAccountelegate = self
        
        vc.modalPresentationStyle = .overCurrentContext
        if let oldVc = self.tabBarController.selectedViewController as? UINavigationController{
            oldVc.definesPresentationContext = true
          
            oldVc.pushViewController(vc, animated: true)
        }
    }
    
    
    func showSettingsView(){
           let vc = SettingsViewController(nibName: "SettingsViewController", bundle: nil)
           vc.notificationManeger = pushNotificationManeger
           vc.modalPresentationStyle = .overCurrentContext
           if let oldVc = self.tabBarController.selectedViewController as? UINavigationController{
               oldVc.definesPresentationContext = true
             
               oldVc.pushViewController(vc, animated: true)
           }
       }
    
    func showUserPostsView(){
        let vc = UserPostsViewController(nibName: "UserPostsViewController", bundle: nil)
        vc.stateController = stateManeger
        vc.delegate = self
        vc.modalPresentationStyle = .overCurrentContext
        if let oldVc = self.tabBarController.selectedViewController as? UINavigationController{
            oldVc.definesPresentationContext = true
          
            oldVc.pushViewController(vc, animated: true)
        }
    }
}


//MARK: -> Authetication Delegate
extension AppCoordinator: AuthenticationCoordinatorDelegate{
    func didChooseSignWithEmail() {
        showSignInWithEmail()
    }
    
    func coordinatorDidAuthenticateWithUser(coordinator: Coordinator) {
        removeCoordinator(coordinator: coordinator)
        self.setupTabBar(user: StoregeAPI.currentUser!)
    }
    
    
    
    func coordinatorDidAuthenticate(coordinator: SignUpCoordinator,user: User) {
        //chamar selecte language
//       removeCoordinator(coordinator: coordinator)
//        showOnBoard(with: user, state:  .learningLanguagesSection, languagesVC: nil)
        
        let pageViewController = PageViewController()
        let teachOnBoard = TeachingOnBoardViewController(nibName: "TeachingOnBoardViewController", bundle: nil)
        teachOnBoard.pageDelegate = pageViewController
        let learnOnBoard = LearningOnBoardViewController(nibName: "LearningOnBoardViewController", bundle: nil)
         learnOnBoard.pageDelegate = pageViewController
        let coordinator = SelectLanguagesCoordinator(user: user, tabBarController: tabBarController)
        coordinator.delegate = self
        let selectLanguage = coordinator.stat(user: user)
        childCoordinators.append(coordinator)
        selectLanguage.pageDelegate = pageViewController
        let pageModel = PageOnBoardingModel(user: user, learningOnBoard: learnOnBoard, selectLanguageVC: selectLanguage, teachingOnBoard: teachOnBoard)
        
        pageViewController.pageModel = pageModel
        
        pageViewController.modalPresentationStyle = .overCurrentContext
        if let oldVc = self.tabBarController.selectedViewController as? UINavigationController{
            oldVc.definesPresentationContext = true
            
            oldVc.pushViewController(pageViewController, animated: true)
        }
        
        
    }
    
    
    fileprivate func removeCoordinator(coordinator:Coordinator) {
        let newArray = childCoordinators.filter {$0 !== coordinator}
        childCoordinators = newArray
        
    }
    
}

//MARK: -> Authetication Delegate
extension AppCoordinator: OnBoardCoordinatorDelegate{
    
    
    
    
    func showSelectLanguages(user: User) {
       let coordinator = SelectLanguagesCoordinator(user: user, tabBarController: tabBarController)
       coordinator.delegate = self
       coordinator.stat(user: user)
       childCoordinators.append(coordinator)
    }
    
    func showSelectLanguages(user: User,languagesVC: SelectLanguageViewController){
//        languagesVC.modalPresentationStyle = .overCurrentContext
//        if let oldVc = self.tabBarController.selectedViewController as? UINavigationController{
//            oldVc.definesPresentationContext = true
//
//            oldVc.pushViewController(languagesVC, animated: true)
//        }
        let coordinator = SelectLanguagesCoordinator(user: user, tabBarController: tabBarController)
        coordinator.delegate = self
        coordinator.stat(user: user)
        childCoordinators.append(coordinator)
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
        
        
       
        childCoordinators.forEach { (coordinator) in
            DispatchQueue.main.async {
                if let coo = coordinator as? SignUpCoordinator{
                    let vc = coo.start()
                    vc.modalPresentationStyle = .overCurrentContext
                    if let oldVc = self.tabBarController.viewControllers?.first as? UINavigationController{
                        oldVc.definesPresentationContext = true
                        oldVc.pushViewController(vc, animated: true)
                        self.removeCoordinator(coordinator: coordinator)
                    }
                }
            }
        }
    }
    
    func didSelectTeachingLanguages(user: User, state: ViewState, languagesVC: SelectLanguageViewController){
        showOnBoard(with: user, state: state,languagesVC: languagesVC)
    }

    
    
}


//MARK: -> Create Post Delegate
extension AppCoordinator: CreatePostDelegate{
    func createPostFinished(coordinator: Coordinator) {
        removeCoordinator(coordinator: coordinator)
//        navigationController.popViewController(animated: true)
        self.tabBarController.selectedIndex = 0
//        if let nav = tabBarController.viewControllers?.first as? UINavigationController{
//
//            tabBarController.show(<#T##vc: UIViewController##UIViewController#>, sender: <#T##Any?#>)
//            nav.popViewController(animated: true)
//        }
    }
}

//MARK: -> Create Post Delegate
extension AppCoordinator: FeedCoordinatorDelegate{
    
    
    
    func chooseProfile() {
        showProfile(user: self.user)
    }
    
  
    
    func chooseCreatePostView() {
        showCreatePost()
    }
    
    func chooseViewPostDetails(post: Post,imageProfile: UIImage?, vc: UIViewController?) {
        showViewPostInDetails(post: post,imageProfile: imageProfile, vc: vc)
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


//MARK: -> Profile Delegate
extension AppCoordinator: ProfileDelegate{
    
    func goToUserActivities() {
        showUserPostsView()
    }
    
    func goToEditInfoView(user: User, image: UIImage?) {
        showEditInfoView(user: user, image: image)
    }
    
    
    func goToSettings() {
        showSettingsView()
    }
    
}


//MARK: -> Manege Account Delegate
extension AppCoordinator: ManegeAccountDelegate{
    func reauthetication() {
        showReauthetication()
    }
    
    func signOut() {
        signUpAPI.signOut()
        start()
    }
    
    func deleteAccount() {
        signUpAPI.signOut()
        start()
    }
    
    
}
