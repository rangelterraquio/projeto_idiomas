//
//  LearningOnBoardViewController.swift
//  ProjetoIdiomas
//
//  Created by Rangel Cardoso Dias on 18/07/20.
//  Copyright © 2020 Rangel Cardoso Dias. All rights reserved.
//

import UIKit

class LearningOnBoardViewController: UIViewController,OnBoardingPage {
    
    @IBOutlet weak var backgroundImage: UIImageView!
    
    var pageDelegate: WalkThroughOnBoardDelegate?
    var user: User!
    var languagesVC: SelectLanguageViewController!
    weak var delegate: OnBoardCoordinatorDelegate? = nil
    
    let screenHeight = UIScreen.main.bounds.height

    override func viewDidLoad() {
        super.viewDidLoad()

        let imageName = screenHeight != 736 ? "onBoard1" : "onBoard1-iphone8"
        backgroundImage.image = UIImage(named: imageName)
    }

    @IBAction func tappedOnButton(_ sender: Any) {
        pageDelegate?.goNextPage(fowardTo: .selectLanguageLearning)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


public protocol OnBoardCoordinatorDelegate: class{
    func showSelectLanguages(user: User)
    func showSelectLanguages(user: User,languagesVC: SelectLanguageViewController)
}
