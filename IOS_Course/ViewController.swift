//
//  ViewController.swift
//  IOS_Course
//
//  Created by Dmytro Kharchenko on 13.02.2024.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        PostNetworkService.shared.fetchRedditAPIWithDataTask() { res in
            print(res!)
        }
        
    }


}

