//
//  MainController.swift
//  MetovaChallenge
//
//  Created by Estelle Paus on 12/12/19.
//  Copyright © 2019 Paus Productions. All rights reserved.
//

import UIKit
import os.log

class MainController: UIViewController {

//MARK: Properties
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var activityIndicator = ActivityIndicatorView()
    
    var networkManager: NetworkManager?
    var imageList = [ImageModel]()
    
// MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.showActivityIndicator(uiView: self.view)
        networkManager = NetworkManager.shared
        tableView.delegate = self
        tableView.dataSource = self
        searchTextField.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(updateTable), name:.ImageModelListUpdatedNotification, object: nil)
    }
    
    @objc func updateTable(notification: Notification) {
        imageList = notification.object as! [ImageModel]
       
        DispatchQueue.main.async {
            if self.imageList.count == 0 {
                let alert = self.createAlertController(title: "No Images Found", message: "No images match your search. \nPlease try again.")
                self.present(alert, animated: true, completion: nil)
                guard let nManager = self.networkManager else { return }
                self.imageList = nManager.prevImageList
            }
            self.tableView.reloadData()
            self.activityIndicator.hideActivityIndicator()
        }
    }
}
//MARK: UITableViewDelegate
extension MainController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

//MARK: UITableviewDataSource
extension MainController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imageList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let model = imageList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellId,
                                                 for: indexPath) as! ImageListTableViewCell 
               cell.selectionStyle = .default
        cell.model = model
        cell.thumbnailPhotoView.getImage(name: model.thumbnailURL ?? "")

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let imageModel = imageList[indexPath.row]
        let url = imageModel.stripURL(url: imageModel.regularURL ?? "")
        
        let imageDisplay = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ImageDisplay") as! ImageDisplayController
        imageDisplay.imageURL = url
        self.present(imageDisplay, animated: false, completion: {
            if url.count > 0 {
                imageDisplay.activityIndicator.showActivityIndicator(uiView: imageDisplay.view)
                imageDisplay.imageView.getImage(name: url)
                   }
        })
        tableView.deselectRow(at: indexPath, animated: true)
    }

}

//MARK: UITextFieldDelegate
extension MainController: UITextFieldDelegate {
    
    @IBAction func searchButtonPressed(_ sender: Any) {
        searchTextField.endEditing(true)
        searchText()
        searchTextField.text = ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return textField.text != "" ? true : false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        searchText()
        searchTextField.text = ""
    }
    
    func searchText() {
        guard let nManager = networkManager else { return }
        if let searchText = searchTextField.text {
            nManager.fetchSearchText(searchText: searchText)
        }
    }
}

