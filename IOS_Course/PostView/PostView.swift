//
//  PostView.swift
//  IOS_Course
//
//  Created by Dmytro Kharchenko on 20.02.2024.
//

import UIKit

class PostView: UIView {
    let kCONTENT_XIB_NAME = "PostView"
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var postTitle: UILabel!
    @IBOutlet weak var savedBtn: UIButton!
    @IBOutlet weak var domain: UILabel!
    @IBOutlet weak var ratingBtn: UIButton!
    @IBOutlet weak var commentBtn: UIButton!
    @IBOutlet var img: UIImageView?
    @IBOutlet weak var timePassed: UILabel!
    @IBOutlet weak var authorName: UILabel!
    override init(frame: CGRect) {
           super.init(frame: frame)
           commonInit()
       }
       
       required init?(coder aDecoder: NSCoder) {
           super.init(coder: aDecoder)
           commonInit()
       }
       
       func commonInit() {
           Bundle.main.loadNibNamed(kCONTENT_XIB_NAME, owner: self, options: nil)
           contentView.fixInView(self)
       }
}
extension UIView
{
    func fixInView(_ container: UIView!) -> Void{
        self.translatesAutoresizingMaskIntoConstraints = false;
        self.frame = container.frame;
        container.addSubview(self);
        NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: container, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: container, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: container, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: container, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
    }
}
