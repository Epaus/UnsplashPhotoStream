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
        NotificationCenter.default.addObserver(self, selector: #selector(updateTable), name:.ImageModelListUpdatedNotification, object: nil)
    }
    
    @objc func updateTable(notification: Notification) {
        imageList = notification.object as! [ImageModel]
       
        DispatchQueue.main.async {
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
    }

}

//MARK: NetworkManagerDelegate
extension MainController: NetworkManagerDelegate {
    func didUpdateImages(imageModels: [ImageModel]) {
        print(imageModels)
    }
    
    func didFailUpdate(error: Error) {
        os_log("update failed with error: %@", error.localizedDescription)
    }
}

//MARK: UITextFieldDelegate
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

//MARK: ActivityIndicatorProtocol
//extension MainController: ActivityIndicatorProtocol {
//
//    func showActivityIndicator(uiView: UIView) {
//
//          let blurEffect = UIBlurEffect(style: .light)
//          blurView = UIVisualEffectView(effect: blurEffect)
//          blurView.frame = uiView.frame
//          blurView.center = uiView.center
//
//          activityIndicator.frame = CGRect(x: 0.0, y: 0.0, width: 80.0, height: 80.0)
//          activityIndicator.style = UIActivityIndicatorView.Style.large
//          activityIndicator.center = uiView.center
//          activityIndicator.color = .darkGray
//
//          view.addSubview(blurView)
//          view.addSubview(activityIndicator)
//          activityIndicator.startAnimating()
//      }
//
//      func hideActivityIndicator() {
//          activityIndicator.stopAnimating()
//          blurView.removeFromSuperview()
//      }
//}
