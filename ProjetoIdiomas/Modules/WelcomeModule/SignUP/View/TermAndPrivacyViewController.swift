//
//  TermAndPrivacyViewController.swift
//  ProjetoIdiomas
//
//  Created by Rangel Cardoso Dias on 05/08/20.
//  Copyright © 2020 Rangel Cardoso Dias. All rights reserved.
//

import UIKit

class TermAndPrivacyViewController: UIViewController {

    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.title = "Privacy & Terms"
        self.navigationController?.navigationBar.tintColor = UIColor(red: 29/255, green: 37/255, blue: 100/255, alpha: 1.0)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

     
    }


    @IBAction func didAccept(_ sender: Any) {
        UserDefaults.standard.set(true, forKey: "AcceptedTerms")
        self.navigationController?.popViewController(animated: true)
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
