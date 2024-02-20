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
      
    }


}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("hola")
        var cell = tableView.dequeueReusableCell(withIdentifier: "post", for: indexPath) as! PostTableViewCell
        PostNetworkService.shared.fetchRedditAPIWithDataTask() { res in

            if let res = res {
                cell.configure(redditPost: res)
            }
            
            
        }
        
        return cell
    }
    
    
}
