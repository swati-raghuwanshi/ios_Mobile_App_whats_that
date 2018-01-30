//
//  GoogleVisionAPIManager.swift
//  WatsDat
//
//  Created by Swati Raghuwanshi on 12/9/17.
//  Copyright © 2017 Swati Raghuwanshi. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol ApproximateLabelDelegate {
    func labelsFound( labels: [Label])
    func labelsNotFound(reason: GoogleVisionAPIManager.FailureReason)
}

class GoogleVisionAPIManager {
    
    enum FailureReason: String {
        case networkFailure = "No network found"
        case badResponse = "Corrupt data"
        case noLabelFound = "No labels to display"
    }
    
    var delegate: ApproximateLabelDelegate?
    let session = URLSession.shared
    
    var googleAPIKey = "your Key"
    var googleURL: URL {
        return URL(string: "https://vision.googleapis.com/v1/images:annotate?key=\(googleAPIKey)")!
        }
    
    func base64EncodeImage(_ image: UIImage) -> String {
        var imagedata = UIImagePNGRepresentation(image)
        
        // Resize the image if it exceeds the 2MB API limit
        if (imagedata?.count > 2097152) {
            let oldSize: CGSize = image.size
            let newSize: CGSize = CGSize(width: 800, height: oldSize.height / oldSize.width * 800)
            imagedata = resizeImage(newSize, image: image)
        }
        
        return imagedata!.base64EncodedString(options: .endLineWithCarriageReturn)
    }
    
    func createRequest(with imageBase64: String) {
        // Create our request URL
        var request = URLRequest(url: googleURL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(Bundle.main.bundleIdentifier ?? "", forHTTPHeaderField: "X-Ios-Bundle-Identifier")
        
        // Build our API request
        let jsonRequest = [
            "requests": [
                "image": [
                    "content": imageBase64
                ],
                "features": [
                    [
                        "type": "LABEL_DETECTION",
                        "maxResults": 10
                    ],
                    
                ]
            ]
        ]
       
        // Serialize the JSON
        guard let data = try? JSONSerialization.data(withJSONObject: jsonRequest) else {
            return
        }
        
        request.httpBody = data
        
        // Run the request on a background thread
        DispatchQueue.global().async { self.runRequestOnBackgroundThread(request) }
    }
    
    func runRequestOnBackgroundThread(_ request: URLRequest) {
        // run the request
        
        let task: URLSessionDataTask = session.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil else {
                self.delegate?.labelsNotFound(reason: .networkFailure)
                return
            }
            
            self.analyzeResults(data)
        }
        
        task.resume()
    }
    
    func resizeImage(_ imageSize: CGSize, image: UIImage) -> Data {
        UIGraphicsBeginImageContext(imageSize)
        image.draw(in: CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        let resizedImage = UIImagePNGRepresentation(newImage!)
        UIGraphicsEndImageContext()
        return resizedImage!
    }
    
    /// Image processing
    func analyzeResults(_ dataToParse: Data) {
        
        // Update UI on the main thread
        DispatchQueue.main.async(execute: {
            
            
            // Use SwiftyJSON to parse results
            let json = JSON(data: dataToParse)
           
            let errorObj: JSON = json["error"]
            
            // Check for errors
            if (errorObj.dictionaryValue != [:]) {
                
                self.delegate?.labelsNotFound(reason: .badResponse)
                
            } else {
                // Parse the response
                
                let responses: JSON = json["responses"][0]
                
                // Get label annotations
                let labelAnnotations: JSON = responses["labelAnnotations"]
             
                
                let numLabels: Int = labelAnnotations.count
                var labels = [Label]()
                if numLabels > 0 {
                    
                    for index in 0..<numLabels {
                        let description = labelAnnotations[index]["description"].stringValue
                        let score = labelAnnotations[index]["score"].floatValue
                        let label = Label(description: description, score: score)
                        labels.append(label)
                        
                    }
        
                    self.delegate?.labelsFound(labels: labels)
                } else {
                    self.delegate?.labelsNotFound(reason: .noLabelFound)
                }
                
                
            }
        })
        
    }
}


fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}


fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l > r
    default:
        return rhs < lhs
    }
}

