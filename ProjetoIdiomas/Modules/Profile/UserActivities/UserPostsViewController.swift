//
//  UserPostsViewController.swift
//  ProjetoIdiomas
//
//  Created by Rangel Cardoso Dias on 19/06/20.
//  Copyright © 2020 Rangel Cardoso Dias. All rights reserved.
//

import UIKit

class UserPostsViewController: UITableViewController {
    
    var stateController: StateController!
    weak var delegate: FeedCoordinatorDelegate? = nil

    var posts = [Post](){
        didSet{
            if oldValue.isEmpty || oldValue.count < posts.count{
                self.tableView.reloadData()
            }
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        self.navigationItem.title = "My Posts"
        self.navigationController?.navigationBar.tintColor = UIColor(red: 29/255, green: 37/255, blue: 100/255, alpha: 1.0)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

      

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        let cellXib = UINib.init(nibName: "FeedCell", bundle: nil)
        self.tableView.register(cellXib, forCellReuseIdentifier: "feedCell")
        self.fetchPosts(from: Date())
        self.tableView.separatorStyle = .none
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return posts.count
    }

    
      override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 300
       }
       
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      if let cell = tableView.dequeueReusableCell(withIdentifier: "feedCell") as? FeedCell{
           let post = posts[indexPath.row]
           print(post.publicationDate)
           cell.populate(post: post)
           
        let uuid = stateController.imageLoader.loadImgage(url: post.author.photoURL, completion: { (result) in
               do{
                   let image = try result.get()
                   cell.populateImage(image: image)
               }catch{
                   print(error as Any)
                   cell.populateImage(image: UIImage(named: "blankProfile")!)
               }
           })
           cell.onReuse = {
               if let uuid = uuid{
                   self.stateController.imageLoader.cancelLoadRequest(uuid: uuid)
               }
           }
           
           
           cell.upvoted = { self.stateController.updateVotes(from: "upvote", inDocument: post, with: nil)}
           cell.downVoted = {self.stateController.updateVotes(from: "downvote", inDocument: post, with: nil)}
           return cell
       }
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell =  tableView.cellForRow(at: indexPath) as?  FeedCell else {return}
        var post = posts[indexPath.row]
        post.downvote = Int32(cell.downVoteLabel.text!)!
        post.upvote = Int32(cell.upVoteLabel.text!)!
        
        delegate?.chooseViewPostDetails(post: post, imageProfile: cell.userPictureView.image, vc: self)
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
         let lastVisibleIndexPath = tableView.numberOfRows(inSection: 0)
            
        
        ///aqui eu faço a requisição de mais posts, tenho que testar dps
        if indexPath.row == lastVisibleIndexPath, !posts.isEmpty {
            fetchPosts(from: posts.last!.publicationDate)
        }
        
    }

    
     //verride to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
         //Return false if you do not want the specified item to be editable.
        return true
    }


    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
          //  removePost(post: posts[indexPath.row])
            posts.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
          //  tableView.reloadData()
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func fetchPosts(from date: Date){
        stateController.fetchUserPosts(from: date) {(snapshot) in

            var data: [Post] = [Post]()
            
            for snap in snapshot!{
                
                if let post = Post(dictionary: snap){
                    data.append(post)
                }
            }
            if data.count > self.posts.count{
                 self.posts = data
            }else{
                self.posts.append(contentsOf: data)
            }
        }
    }
    
    
    func removePost(post: Post){
        stateController.removePost(post: post)
    }
    
}
