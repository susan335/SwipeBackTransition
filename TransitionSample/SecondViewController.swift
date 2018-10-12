//
//  SecondViewController.swift
//  TransitionSample
//
//  Created by Yohta Watanave on 2018/10/12.
//  Copyright © 2018 watanave. All rights reserved.
//

import UIKit

class SecondViewController: UITableViewController {

    let data = (0..<20)
    private lazy var transition: CustomPushTransition = {
        return CustomPushTransition(attachViewController: self)
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        _ = self.transition
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nav = self.navigationController
        let image = nav?.navigationBar.backIndicatorImage
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: image, style: .plain, target: nil, action: nil)
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "\(self.data[indexPath.row])"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = SecondViewController(nibName: "SecondViewController", bundle: nil)
        self.present(viewController, animated: true, completion: nil)
    }
}

