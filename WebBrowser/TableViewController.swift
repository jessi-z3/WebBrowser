//
//  TableViewController.swift
//  WebBrowser
//
//  Created by Jessi Zimmerman on 2/9/24.
//

import Foundation
import UIKit

class TableViewController: UITableViewController{
    //    Define the websites
    public var websites = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        websites += ["apple.com", "hackingwithswift.com"]
        title = "Web browser"
        navigationController?.navigationBar.prefersLargeTitles = true
        print("Application ready")
    }

//    Define the number of cells
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return websites.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Website", for: indexPath)
        cell.textLabel?.text = websites[indexPath.row]
        print(cell)
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Page") as? ViewController {
            vc.website = websites[indexPath.row]
            vc.websites = websites
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
