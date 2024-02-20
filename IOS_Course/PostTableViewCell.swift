//
//  PostTableViewCell.swift
//  IOS_Course
//
//  Created by Dmytro Kharchenko on 20.02.2024.
//

import UIKit

class PostTableViewCell: UITableViewCell {

    
    @IBOutlet weak var authorName: UILabel!
    
    @IBOutlet weak var timePassed: UILabel!
    
    
    @IBOutlet weak var domain: UILabel!
    
    @IBOutlet weak var savedBtn: UIButton!
    
    @IBOutlet weak var postTitle: UILabel!
    
    
    @IBOutlet var img: UIImageView!
    
    @IBOutlet weak var commentsBtn: UIButton!
    
    @IBOutlet weak var shareBtn: UIButton!
    
    @IBOutlet weak var ratingBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func config(redditPost:Post) {
        let myPost = MyPost(redditPost: redditPost)
        self.authorName.text = myPost.author
        self.timePassed.text = myPost.timePassed
        self.postTitle.text = myPost.title
        self.domain.text = myPost.domain
        // temporary
        self.savedBtn.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: myPost.image) {
                DispatchQueue.main.async {
                    self?.img?.image = UIImage(data: data)
                }
            }
        }
        self.commentsBtn.setTitle(String(myPost.rating), for: .normal)
        self.ratingBtn.setTitle(String(myPost.comments), for: .normal)
        // temporary
    }

}

struct MyPost {
    let author: String
    let timePassed: String
    let domain: String
    let title: String
    let saved: Bool
    let image: URL
    let rating: Int
    let comments: Int
    
    init(redditPost:Post) {
        self.author = redditPost.data.children[0].data.author
        // temporary
        self.timePassed = "10h"
        self.domain = redditPost.data.children[0].data.domain
        self.title = redditPost.data.children[0].data.title
        self.comments = redditPost.data.children[0].data.numComments
        self.rating = redditPost.data.children[0].data.ups + redditPost.data.children[0].data.downs
        
        let resImg = redditPost.data.children[0].data.preview.images[0].source
        self.image = URL(string: resImg.url.replacingOccurrences(of: "&amp", with: "&"))!
        // temporary
        self.saved = false
    }
}
