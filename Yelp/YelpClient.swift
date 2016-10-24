//
//  YelpClient.swift
//  Yelp
//
//  Created by Deeksha Prabhakar on 10/18/16.
//  Copyright © 2016 Deeksha Prabhakar. All rights reserved.
//

import UIKit
import AFNetworking
import BDBOAuth1Manager

// You can register for Yelp API keys here: http://www.yelp.com/developers/manage_api_keys
let yelpConsumerKey = "nivzD77iDXY_svea3DwITA"
let yelpConsumerSecret = "RxnmmbItvdh1els1k-QT87s-sS0"
let yelpToken = "olzAmjDX_LzCNY1_MuRSi6NOjhch1uPW"
let yelpTokenSecret = "apwNIbkz82QPE5VQ5mbSJ5nHcR8"

enum YelpSortMode: Int {
    case bestMatched = 0, distance, highestRated
}

class YelpClient: BDBOAuth1RequestOperationManager {
    var accessToken: String!
    var accessSecret: String!
    
    //MARK: Shared Instance
    
    static let sharedInstance = YelpClient(consumerKey: yelpConsumerKey, consumerSecret: yelpConsumerSecret, accessToken: yelpToken, accessSecret: yelpTokenSecret)
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(consumerKey key: String!, consumerSecret secret: String!, accessToken: String!, accessSecret: String!) {
        self.accessToken = accessToken
        self.accessSecret = accessSecret
        let baseUrl = URL(string: "https://api.yelp.com/v2/")
        super.init(baseURL: baseUrl, consumerKey: key, consumerSecret: secret);
        
        let token = BDBOAuth1Credential(token: accessToken, secret: accessSecret, expiration: nil)
        self.requestSerializer.saveAccessToken(token)
    }
    
    func searchWithTerm(_ term: String, completion: @escaping ([Business]?, Error?) -> Void) -> AFHTTPRequestOperation {
        return searchWithTerm(term, pgOffset:0, distance: 0, sort: nil, categories: nil, deals: nil, completion: completion)
    }
    
    func searchWithTerm(_ term: String, pgOffset: Int?, distance: Double? , sort: YelpSortMode?, categories: [String]?, deals: Bool?, completion: @escaping ([Business]?, Error?) -> Void) -> AFHTTPRequestOperation {
        // For additional parameters, see http://www.yelp.com/developers/documentation/v2/search_api
        
        var searchTerm = term
        if(term.isEmpty){
            searchTerm = "Restaurants"
        }
        
        // Default the location to San Francisco
        var parameters: [String : AnyObject] = ["term": searchTerm as AnyObject, "ll": "37.785771,-122.406165" as AnyObject]
        
        if sort != nil {
            parameters["sort"] = sort!.rawValue as AnyObject?
        }
        
        if categories != nil && categories!.count > 0 {
            parameters["category_filter"] = (categories!).joined(separator: ",") as AnyObject?
        }
        
        if deals != nil {
            parameters["deals_filter"] = deals! as AnyObject?
        }
        
        if(distance != nil){
            parameters["radius_filter"] = distance! as AnyObject?
        }
        
        if(pgOffset != nil){
            parameters["offset"] = pgOffset! as AnyObject?
        }
        print(parameters)
        
        return self.get("search", parameters: parameters,
                        success: { (operation: AFHTTPRequestOperation, response: Any) -> Void in
                            if let response = response as? [String: Any]{
                                let dictionaries = response["businesses"] as? [NSDictionary]
                                if dictionaries != nil {
                                    completion(Business.businesses(array: dictionaries!), nil)
                                }
                            }
            },
                        failure: { (operation: AFHTTPRequestOperation?, error: Error) -> Void in
                            completion(nil, error)
        })!
    }

   
}
