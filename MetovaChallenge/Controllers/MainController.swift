//
//  ViewController.swift
//  MetovaChallenge
//
//  Created by Estelle Paus on 12/12/19.
//  Copyright © 2019 Paus Productions. All rights reserved.
//

import UIKit
import os.log

class MainController: UIViewController {
    
    @IBOutlet weak var searchTextField: UITextField!
    
    @IBOutlet weak var tableView: UITableView!
    
    
    var networkManager: NetworkManager?
    var imageList = [ImageModel]()
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        networkManager = NetworkManager.shared
         tableView.register(ImageListTableViewCell.self, forCellReuseIdentifier: Constants.cellId)
        NotificationCenter.default.addObserver(self, selector: #selector(updateTable), name:.ImageModelListUpdatedNotification, object: nil)
    }
    
   
    
    @objc func updateTable(notification: Notification) {
        print("updateTable")
        imageList = notification.object as! [ImageModel]
       
        DispatchQueue.main.async {
            //self.tableView.layoutIfNeeded()
            self.tableView.reloadData()
            
        }
        
    }
}

extension MainController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

extension MainController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imageList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let model = imageList[indexPath.row]
        print("model.description = ",model.description ?? "where is description?!")
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellId,
                                                 for: indexPath) as! ImageListTableViewCell 
               cell.selectionStyle = .none
        cell.model = model ?? ImageModel(id: "1111", description: "dummy description", alt_description: "dummy alt_description", regularURL: "", thumbnailURL: "", likes: 2, thumbnailImage: nil, regularImage: nil)
//        cell.descriptionLabel?.text = model.description ?? model.alt_description ?? "no description"
//        cell.photographerLabel?.text = model.alt_description
        return cell
    }
}

extension MainController: NetworkManagerDelegate {
    func didUpdateImages(imageModels: [ImageModel]) {
        print(imageModels)
    }
    
    func didFailUpdate(error: Error) {
        os_log("update failed with error: %@", error.localizedDescription)
    }
}

extension MainController: UITextFieldDelegate {
    
    @IBAction func searchButtonPressed(_ sender: Any) {
        searchTextField.endEditing(true)
        guard let nManager = networkManager else { return }
        if let searchText = searchTextField.text {
            let text = searchText.replacingOccurrences(of: " ", with: "-")
            nManager.fetchSearchText(searchText: text)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return textField.text != "" ? true : false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        searchTextField.text = ""
    }
}

