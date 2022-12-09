//
//  HypeListViewController.swift
//  HypeGP
//
//  Created by Nicolas Garaycochea on 12/7/22.
//

import UIKit

class HypeListViewController: UIViewController {
    // MARK - Outlets
    
    @IBOutlet weak var tableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    
    // MARK - Actions
    @IBAction func addHypeButtonTapped(_ sender: Any) {
    }
    
    func loadData() {
        HypeController.shared.fetchHypes { (success) in
            if success {
                self.updateViews()
            }
        }
    }
    
    func updateViews() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

extension HypeListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return HypeController.shared.hypes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "hypeCell", for: indexPath)
        
        let hype = HypeController.shared.hypes[indexPath.row]
        
        cell.textLabel?.text = hype.body
        // add the timestamp
        cell.detailTextLabel?.text = hype.timestamp.formateDate()
        
        return cell
    }
    
}
