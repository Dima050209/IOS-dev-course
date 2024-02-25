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
        var myPost = MyPost(redditPost: post)
       //        print(myPost)
               DispatchQueue.main.async {
                   guard let name = self.authorName else {
                       return
                   }
                   self.authorName.text = myPost.author
       //            self.timePassed.text = myPost.timePassed
       //            self.postTitle.text = myPost.title
       //            self.domain.text = myPost.domain
       //            // temporary
       //            self.savedBtn.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
       //            if let image = myPost.image {
       //                DispatchQueue.global().async { [weak self] in
       //                    if let data = try? Data(contentsOf: image) {
       //                        DispatchQueue.main.async {
       //                            self?.img?.image = UIImage(data: data)
       //                        }
       //                    }
       //                }
       //            }
       //            self.commentsBtn.setTitle(String(myPost.rating), for: .normal)
       //            self.ratingBtn.setTitle(String(myPost.comments), for: .normal)
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
