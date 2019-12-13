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
    var networkManager = NetworkManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        networkManager.delegate = self
    }
}

extension MainController: NetworkManagerDelegate {
    func didUpdateImages(imageModels images: [ImageModel]) {
        print("images = ", images)
    }
    
    func didFailUpdate(error: Error) {
        os_log("update failed with error: %@", error.localizedDescription)
    }
}

extension MainController: UITextFieldDelegate {
    
    @IBAction func searchButtonPressed(_ sender: Any) {
        searchTextField.endEditing(true)
        if let searchText = searchTextField.text {
            let text = searchText.replacingOccurrences(of: " ", with: "-")
            networkManager.fetchSearchText(searchText: text)
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

