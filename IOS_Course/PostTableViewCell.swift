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
    func configure(redditPost:Child) {
        let myPost = MyPost(redditPost: redditPost)
        DispatchQueue.main.async {
            self.authorName.text = myPost.author
            self.timePassed.text = myPost.timePassed
            self.postTitle.text = myPost.title
            self.domain.text = myPost.domain
            // temporary
            self.savedBtn.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
            if let image = myPost.image {
                DispatchQueue.global().async { [weak self] in
                    if let data = try? Data(contentsOf: image) {
                        DispatchQueue.main.async {
                            self?.img?.image = UIImage(data: data)
                        }
                    }
                }
            }
            self.commentsBtn.setTitle(String(myPost.rating), for: .normal)
            self.ratingBtn.setTitle(String(myPost.comments), for: .normal)
        }
    }

}

struct MyPost {
    let author: String
    let timePassed: String
    let domain: String
    let title: String
    let saved: Bool
    let image: URL?
    let rating: Int
    let comments: Int
    
    init(redditPost:Child) {
        if let author = redditPost.data.authorFullname {
            self.author = author
        } else {
            self.author = "No author"
        }
        // temporary
        self.timePassed = "10h"
        if let domain = redditPost.data.domain {
            self.domain = domain
        } else {
            self.domain = "No domain"
        }
        if let title = redditPost.data.title {
            self.title = title
        } else {
            self.title = "No title"
        }
        if let comments = redditPost.data.numComments {
            self.comments = comments
        } else {
            self.comments = 0
        }
        if let ups = redditPost.data.ups {
            if let downs = redditPost.data.downs {
                self.rating = ups + downs
            } else {
                self.rating = ups
            }
        } else if let downs = redditPost.data.downs {
            self.rating = downs
        } else {
            self.rating = 0
        }
        
        if let imgPreview = redditPost.data.preview {
            self.image = URL(string: imgPreview.images[0].source.url.replacingOccurrences(of: "&amp", with: "&"))!
        } else {
            self.image = nil
        }
        // temporary
        self.saved = false
    }
}
