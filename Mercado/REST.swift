//
//  REST.swift
//  Mercado
//
//  Created by Aleksei Neronov on 23.01.17.
//  Copyright © 2017 Aleksei Neronov. All rights reserved.
//

import Foundation
import Alamofire

// Class containing REST API
class REST: NSObject {
    
    struct ITEM {
        static let Title = "title"
        static let Price = "price"
        static let Thumbnail = "thumbnail"
    }

    
    class func loadList(for string:String, completed:@escaping DownloadComplete ) {
        Alamofire.request(BASE_URL+string+URL_SUFFIX).responseJSON { response in
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
                    }
                    ad.saveContext()
                }
            }
            completed()
        }
    }
    
}