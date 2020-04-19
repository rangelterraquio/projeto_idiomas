//
//  FeedViewController.swift
//  ProjetoIdiomas
//
//  Created by Rangel Cardoso Dias on 14/04/20.
//  Copyright © 2020 Rangel Cardoso Dias. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController {


    var presenter: FeedViewToPresenter? = nil
    
    var posts: [Post] = [Post]()
    
    
    @IBOutlet weak var feedTableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
    }
    override func viewDidLoad() {
        super.viewDidLoad()

       
        ///setup tableView
        let cellXib = UINib.init(nibName: "FeedCell", bundle: nil)
        feedTableView.register(cellXib, forCellReuseIdentifier: "feedCell")
        
        feedTableView.delegate = self
        feedTableView.dataSource = self
        
        
        presenter?.updateFeed(in: [.english])
        
    }
    

    @IBAction func reloadTB(_ sender: Any) {
        print(self.posts)
                presenter?.updateFeed(in: [.english])

    }
    
}


extension FeedViewController: FeedPresenterToView{
    func showPosts(posts: [Post]) {
        self.posts = posts
        self.feedTableView.reloadData()
    }
    
    func showError() {
        print("errooou")
    }
    
}

extension FeedViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "feedCell") as? FeedCell{
            let post = posts[indexPath.row]
            
            cell.populate(post: post)
            if let url = post.author.photoURL{
                let uuid = presenter?.requestProfileImage(from: url, completion: { (result) in
                    do{
                        let image = try result.get()
                        cell.populateImage(image: image)
                    }catch{
                        cell.populateImage(image: UIImage(named: "blankProfile")!)
                        print(error as Any)
                    }
                })
                cell.onReuse = {
                    if let uuid = uuid{
                        self.presenter?.cancelImageRequest(uuid: uuid)
                    }
                }
            }
            
            
            return cell
        }
        
        fatalError("deu ruim com a cell")
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    
}
