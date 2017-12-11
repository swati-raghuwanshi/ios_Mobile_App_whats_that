//
//  WikipediaAPIManager.swift
//  WatsDat
//
//  Created by Swati Raghuwanshi on 12/9/17.
//  Copyright © 2017 Swati Raghuwanshi. All rights reserved.
//

import Foundation
import SafariServices


protocol ApproximateDataDelegate {
    func dataFound( wiki: Wiki)
    func dataNotFound(reason: WikipediaAPIManager.FailureReason)
}

class WikipediaAPIManager {
    
    enum FailureReason: String {
        case networkFailure = "No network found"
        case badResponse = "Corrupt data"
        case noDataFound = "No data to display"
    }
    
    var delegate: ApproximateDataDelegate?
    
    func fetchWikiData(searchString: String) {
        
        let escapedSearchString = searchString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        
        let urlComponents = URLComponents(string: "https://en.wikipedia.org/w/api.php?format=json&action=query&prop=extracts&exintro=&explaintext=&titles=\(escapedSearchString ?? "default")")!//add search string in place of iphone
        
        
        
        let url = urlComponents.url!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            //check for valid response with 200 (success)
            guard let response = response as? HTTPURLResponse, response.statusCode == 200
                else {
                    //print("1")
                    self.delegate?.dataNotFound(reason: .networkFailure)
                    
                    return
            }
            
            guard let data = data, let wikiPageJsonObject = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] ?? [String:Any]()
                else {
                    //print("2")
                    self.delegate?.dataNotFound(reason: .badResponse)
                    
                    return
            }
            
            guard let responseJsonObject = wikiPageJsonObject["query"] as? [String:Any]
                //, let venuesJsonArrayObject = responseJsonObject["venues"] as? [[String:Any]]
                else {
                    //print("3")
                    self.delegate?.dataNotFound(reason: .badResponse)
                    
                    return
            }
            guard let pagesJsondata = responseJsonObject["pages"] as? [String:Any]
                
                else {
                    //print("4")
                    self.delegate?.dataNotFound(reason: .badResponse)
                    
                    return
            }
            guard let pageJsondata = pagesJsondata[pagesJsondata.keys.first!] as? [String:Any]
                
                else {
                    //print("4")
                    self.delegate?.dataNotFound(reason: .noDataFound)
                    
                    return
            }
            
            //var wikis = [Wiki]
            //for venueJsonObject in venuesJsonArrayObject {
            let extract = pageJsondata["extract"] as? String ?? ""
            let title = pageJsondata["title"]as? String ?? ""
            let pageid = pageJsondata["pageid"] as? Int ?? -1
            
            let wiki = Wiki(title: title,extract: extract, pageid: pageid)
            //wikis.append(wiki)
            
            //}
            //}
            
            self.delegate?.dataFound(wiki: wiki)
        }
        
        task.resume()
    }
    
    
    
    
}

