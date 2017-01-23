//
//  REST.swift
//  Mercado
//
//  Created by Aleksei Neronov on 23.01.17.
//  Copyright © 2017 Aleksei Neronov. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage

// Class containing REST API
class REST: NSObject {
    
    struct ITEM {
        static let Title = "title"
        static let Price = "price"
        static let Currency = "currency_id"
        static let Thumbnail = "thumbnail"
    }

    
    class func loadList(for string:String, completed:@escaping DownloadComplete ) {
        let path = string.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)
        Alamofire.request(BASE_URL+path!+URL_SUFFIX).responseJSON { response in
            if let dict = response.result.value as? Dictionary<String,AnyObject> {
                if let items = dict["results"] as? [Dictionary<String,AnyObject>] {
                    for item in items {
                        let search = Search(context: context)
                        if let title = item[ITEM.Title] as? String {
                            search.title = title
                        }
                        if let thumbnail = item[ITEM.Thumbnail] as? String {
                            search.thumb = thumbnail
                        }
                        if let price = item[ITEM.Price] as? Double {
                            search.price = price
                        }
                        if let currency = item[ITEM.Currency] as? String {
                            search.currency = currency
                        }
                    }
                    ad.saveContext()
                }
            }
            completed()
        }
    }
        
}
