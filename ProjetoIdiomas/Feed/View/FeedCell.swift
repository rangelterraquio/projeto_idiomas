//
//  FeedCell.swift
//  ProjetoIdiomas
//
//  Created by Rangel Cardoso Dias on 15/04/20.
//  Copyright © 2020 Rangel Cardoso Dias. All rights reserved.
//

import UIKit

class FeedCell: UITableViewCell {

    @IBOutlet weak var userPictureView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var postTitleLabel: UILabel!
    @IBOutlet weak var postText: UITextView!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var reactionButton: UIButton!
    
    @IBOutlet weak var feedIndicator: UIActivityIndicatorView!
    @IBOutlet weak var profilePicIndicator: UIActivityIndicatorView!
    
    var onReuse: () -> () = {}

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        profilePicIndicator.startAnimating()
        feedIndicator.startAnimating()
        feedIndicator.hidesWhenStopped = true
        profilePicIndicator.hidesWhenStopped = true
        
        
        ///setup profile image view
        userPictureView.translatesAutoresizingMaskIntoConstraints = false
        userPictureView.layer.cornerRadius = 24
        userPictureView.layer.masksToBounds = true
        userPictureView.contentMode = .scaleAspectFill
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func populate(post: Post){
        self.postText.text = post.message
        self.userNameLabel.text = post.author.name
        self.postTitleLabel.text = post.title
        self.feedIndicator.stopAnimating()
        
//        if let photoURL = post.author.photoURL{
//            self.userPictureView.loadImagefromURL(from: photoURL) {
//                self.profilePicIndicator.stopAnimating()
//            }
//        }
    }
    
    func populateImage(image: UIImage){
        DispatchQueue.main.async {
            self.userPictureView.image = image
            self.profilePicIndicator.stopAnimating()
        }
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.userPictureView.image = nil
        onReuse()
    }
}
