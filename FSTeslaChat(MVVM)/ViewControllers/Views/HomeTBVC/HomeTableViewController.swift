
//  HomeTableViewController.swift
//  FSTeslaChat(MVVM)
//
//  Created by Isiah Parra on 6/19/22.


import UIKit
import SwiftUI
class HomeTableViewController: UITableViewController {
    
    var viewModel: HomeTBVCModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = HomeTBVCModel(delegate: self)
    }
    
    // MARK: - Table view data source
    @IBAction func addBtnTapped(_ sender: Any) {
        self.presentSendMessageScreen()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return viewModel.messages.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) 
        let message = viewModel.messages[indexPath.row]
        cell.textLabel?.text = "\(message.text) - \(message.sender)"
        cell.detailTextLabel?.text = "\(message.timeStamp)"
        // Configure the cell...
        
        return cell
    }
    
    
    // Override to support editing the table view.
    //    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    //        if editingStyle == .delete {
    //            // Delete the row from the data source
    //            tableView.deleteRows(at: [indexPath], with: .fade)
    //        } else if editingStyle == .insert {
    //            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    //        }
    //    }
    
    
    
   
    
       
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     
        }
    
    
}

extension HomeTableViewController: HomeTBVCModelDelegate {
    func messageRecieved() {
        self.tableView.reloadData()
    }
}

extension HomeTableViewController {
    func presentSendMessageScreen() {
        let ac = UIAlertController(title: "Send Message",
                                   message: "Enter your message and username",
                                   preferredStyle: .alert)
        
        ac.addTextField { userNameTextField in
            userNameTextField.text = "User1"
            userNameTextField.placeholder = "Enter Username..."
        }
        
        ac.addTextField { messageTextField in
            messageTextField.placeholder = "Enter Message Here..."
        }
        
        let cancelBtn = UIAlertAction(title: "Cancel", style: .destructive)
        let sendBtn = UIAlertAction(title: "Full Send", style: .default) { [weak self]_ in
            guard let username = ac.textFields?[0].text,
                  !username.isEmpty,
                  let message = ac.textFields?[1].text,
                  !message.isEmpty
            else { return }
            
            self?.viewModel.postMessage(text: message)
        }
        
        ac.addAction(cancelBtn)
        ac.addAction(sendBtn)
        
        self.present(ac, animated: true)
    }
}
