//
//  ViewController.swift
//  IOS_Course
//
//  Created by Dmytro Kharchenko on 13.02.2024.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var authorName: UILabel!
    @IBOutlet weak var domain: UILabel!
    @IBOutlet weak var postTitle: UILabel!
    @IBOutlet var img: UIImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        PostNetworkService.shared.fetchRedditAPIWithDataTask() { res in
            DispatchQueue.main.async {
                if let res = res {
                    self.authorName.text = res.data.children[0].data.author
                    self.domain.text = res.data.children[0].data.domain
                    self.postTitle.text = res.data.children[0].data.title
                }
                let resImg = res!.data.children[0].data.preview.images[0].source
                let imgUrl = URL(string: resImg.url.replacingOccurrences(of: "&amp", with: "&"))!
                DispatchQueue.global().async { [weak self] in
                    if let data = try? Data(contentsOf: imgUrl) {
                        DispatchQueue.main.async {
                            self?.img?.image = UIImage(data: data)
                        }
                    
                    }
                }
            }
            
        }
        
    }


}

