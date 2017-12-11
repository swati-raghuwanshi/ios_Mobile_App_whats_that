//
//  PhotoIdentificationViewController.swift
//  WatsDat
//
//  Created by Swati Raghuwanshi on 12/8/17.
//  Copyright © 2017 Swati Raghuwanshi. All rights reserved.
//

import UIKit
import SwiftyJSON
import AVFoundation
import Photos
import MBProgressHUD


class PhotoIdentificationViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    
    var labels = [Label]()
    let locationFinder = LocationFinder()
    
    var searchString = ""
    var filename: URL?
    var latitude: Double = 0.0
    var longitude:Double = 0.0
    
    let imagePicker = UIImagePickerController()
    let session = URLSession.shared
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageView: UIImageView!
    //@IBOutlet weak var spinner: UIActivityIndicatorView!
   
    @IBAction func chooseImageToAnalyze(_ sender: UITapGestureRecognizer) {
        //print("i am in gesture")
        
        
                    imagePicker.allowsEditing = false
        
        
                    let actionSheet = UIAlertController(title:"Choose Image", message:"Please select one option", preferredStyle: .actionSheet)
        
                    let cameraButton = UIAlertAction(title: "Click a photo", style: UIAlertActionStyle.default) { camSelected in
                        
                        self.requestCameraPermission()
                        
                    }
        
                    let libraryButton = UIAlertAction(title: "Select a Photo", style: UIAlertActionStyle.default) { libSelected in
                        self.requestGalleryPermission()
                        
                    }
        
                    let cancelButton = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default) {(cancelSelected) -> Void in
        
                    }
                    actionSheet.addAction(libraryButton)
                    actionSheet.addAction(cameraButton)
                    actionSheet.addAction(cancelButton)
        
                    self.present(actionSheet, animated: true, completion: nil)
        
    }
    
    func requestCameraPermission()  {
        let camStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        switch camStatus {
            case .notDetermined, .denied, .restricted:
                AVCaptureDevice.requestAccess(for: AVMediaType.video) {
                    status in
                    if status {
                        self.imagePicker.sourceType = UIImagePickerControllerSourceType.camera
                        
                        self.present(self.imagePicker, animated: true, completion: nil)
                    } else {
                        let ac = UIAlertController(title:"Camera Permission Required", message:"Please give camera permissions to proceed", preferredStyle: .alert)
                        let cancelButton = UIAlertAction(title: "Cancel", style: .default)
                        
                        let settingsButton = UIAlertAction(title: "Settings", style: .default){
                            action in
                            guard let settings = URL(string: UIApplicationOpenSettingsURLString) else {
                                return
                            }
                            if UIApplication.shared.canOpenURL(settings)
                            {
                                UIApplication.shared.open(settings)
                            }
                            else{
                                return
                            }
                        }
                       
                        ac.addAction(settingsButton)
                        ac.addAction(cancelButton)
                        
                        self.present(ac, animated: true, completion: nil)
                        
                     
                    }
                }
            
            case .authorized:
                imagePicker.sourceType = UIImagePickerControllerSourceType.camera
                
                present(imagePicker, animated: true, completion: nil)
            
        }
    }
    
    func requestGalleryPermission()  {
        
        let galleryStatus = PHPhotoLibrary.authorizationStatus()
        switch galleryStatus {
        case .notDetermined, .denied, .restricted:
            PHPhotoLibrary.requestAuthorization {
                status in
                if status == .authorized {
                    self.imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
                    
                    self.present(self.imagePicker, animated: true, completion: nil)
                } else {
                    let ac = UIAlertController(title:"Gallery Permission Required", message:"Please give photo libary permissions to proceed", preferredStyle: .alert)
                    let cancelButton = UIAlertAction(title: "Cancel", style: .default)
                    
                    let settingsButton = UIAlertAction(title: "Settings", style: .default){
                        action in
                        guard let settings = URL(string: UIApplicationOpenSettingsURLString) else {
                            return
                        }
                        if UIApplication.shared.canOpenURL(settings)
                        {
                            UIApplication.shared.open(settings)
                        }
                        else{
                            return
                        }
                    }
                    
                    ac.addAction(settingsButton)
                    ac.addAction(cancelButton)
                    
                    self.present(ac, animated: true, completion: nil)
                    
                    
                }
            }
            
        case .authorized:
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            
            present(imagePicker, animated: true, completion: nil)
            
        }
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        imagePicker.delegate = self
        //labelResults.isHidden = true
        //spinner.hidesWhenStopped = true
        MBProgressHUD.hide(for: self.view, animated: true)
        locationFinder.delegate = self
        
        findLocation()
    }
    
    func findLocation() {
        locationFinder.findLocation()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.contentMode = .scaleAspectFit
            imageView.image = pickedImage // You could optionally display the image here by setting imageView.image = pickedImage
           // spinner.startAnimating()
            MBProgressHUD.showAdded(to: self.view, animated: true)
            //labelResults.isHidden = true
            
            let labelFinder = GoogleVisionAPIManager()
            
            labelFinder.delegate = self
            
            // Base64 encode the image and create the request
            let binaryImageData = labelFinder.base64EncodeImage(pickedImage)
            labelFinder.createRequest(with: binaryImageData)
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    //Table View Controller functions
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return labels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "displayData", for: indexPath as IndexPath)
        
        //let dataOfLabelDisplayInCell = labels[indexPath.row]
        //cell.textLabel?.text = labelResultsText
        
        let label = labels[indexPath.row]
        cell.textLabel?.text = label.description
        //let decimalValue = label.score * 100
       // let decimalValue = [NSString stringWithFormat: @"%.0f",label.score *100]
        let decimalValue = NSString .localizedStringWithFormat("%.f", label.score * 100)
        cell.detailTextLabel?.text = String(describing: decimalValue)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath)
        searchString = cell?.textLabel?.text ?? ""
        
        performSegue(withIdentifier: "passDataToBeSearched", sender: self)
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        if segue.identifier == "passDataToBeSearched"{
            let myVC = segue.destination as! PhotoDetailsViewController
            myVC.titleHead = searchString
            myVC.latitude = latitude
            myVC.longitude = longitude
            //myVC.imagePassed = imageView.image!
            if let data = UIImagePNGRepresentation(imageView.image!) {
                filename = getDocumentsDirectory().appendingPathComponent(UUID().uuidString)
                guard let filename = filename else {
                    return
                }
                try? data.write(to: filename)
                myVC.filename = filename
            }
            
            
            
        }
    }
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}

extension PhotoIdentificationViewController: ApproximateLabelDelegate {
    
    
    
    func labelsFound(labels:[Label]) {
        self.labels = labels
        
        DispatchQueue.main.async {
            
            self.tableView.reloadData()
            //self.spinner.stopAnimating()
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
    
    func labelsNotFound(reason: GoogleVisionAPIManager.FailureReason) {
        //print ("no labels")
        
        
        DispatchQueue.main.async {
            
            
            //self.spinner.stopAnimating()
            MBProgressHUD.hide(for: self.view, animated: true)
            let ac = UIAlertController(title:"Error Message", message: reason.rawValue, preferredStyle: .alert)
            let cancelButton = UIAlertAction(title: "Cancel", style: .default)
            
            ac.addAction(cancelButton)
            
            self.present(ac, animated: true, completion: nil)
        }
      
    }
}


//adhere to the LocationFinderDelegate protocol
extension PhotoIdentificationViewController: LocationFinderDelegate {
    func locationFound(latitude: Double, longitude: Double) {
        
        self.latitude = latitude
        self.longitude = longitude
    }
    
    func locationNotFound(reason: LocationFinder.FailureReason) {
        DispatchQueue.main.async {
            
            //self.spinner.stopAnimating()
            MBProgressHUD.hide(for: self.view, animated: true)
            let ac = UIAlertController(title:"Error Message", message: reason.rawValue, preferredStyle: .alert)
            let cancelButton = UIAlertAction(title: "Cancel", style: .default)
            
            ac.addAction(cancelButton)
            
            self.present(ac, animated: true, completion: nil)
            
        }
    }
}







