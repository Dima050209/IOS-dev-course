//
//  PostDetailsViewController.swift
//  IOS_Course
//
//  Created by Dmytro Kharchenko on 25.02.2024.
//

import UIKit

class PostDetailsViewController: UIViewController {

    @IBOutlet weak var authorName: UILabel!
    
    @IBOutlet weak var timePeriod: UILabel!
    
    @IBOutlet weak var domain: UILabel!
    
    @IBOutlet weak var savedBtn: UIButton!
    
    @IBOutlet weak var postTitle: UILabel!
    
    @IBOutlet var img: UIImageView!
    
    @IBOutlet weak var ratingBtn: UIButton!
    
    @IBOutlet weak var commentsBtn: UIButton!
    
    @IBOutlet weak var shareBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    func config(with post:Child) {
        let myPost = MyPost(redditPost: post)
        DispatchQueue.main.async {
            guard self.authorName != nil else { return }
            self.authorName.text = myPost.author
                   
            guard self.timePeriod != nil else { return }
            self.timePeriod.text = myPost.timePassed
                   
            guard self.postTitle != nil else { return }
            self.postTitle.text = myPost.title
                   
            guard self.domain != nil else { return }
            self.domain.text = myPost.domain
    
            guard self.savedBtn != nil else { return }
            if myPost.saved {
                self.savedBtn.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
            } else {
                self.savedBtn.setImage(UIImage(systemName: "bookmark"), for: .normal)
            }
                   
            if let image = myPost.image {
                DispatchQueue.global().async { [weak self] in
                    if let data = try? Data(contentsOf: image) {
                        DispatchQueue.main.async {
                            self?.img?.image = UIImage(data: data)
                        }
                    }
                }
            }
            guard self.commentsBtn != nil else { return }
            self.commentsBtn.setTitle(String(myPost.rating), for: .normal)
                   
            guard self.ratingBtn != nil else { return }
            self.ratingBtn.setTitle(String(myPost.comments), for: .normal)
        }
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
