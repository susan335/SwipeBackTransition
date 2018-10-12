//
//  FirstViewController.swift
//  TransitionSample
//
//  Created by Yohta Watanave on 2018/10/12.
//  Copyright © 2018 watanave. All rights reserved.
//

import UIKit

class FirstViewController: UITableViewController {

    let data = (0..<20)
    
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

