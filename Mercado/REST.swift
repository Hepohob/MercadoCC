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
        static let Id = "id"
    }
    
    struct PRODUCT {
        static let Title = "title"
        static let Price = "price"
        static let Currency = "currency_id"
        static let Descript = "descriptions"
        static let Pictures = "pictures"
        static let Id = "id"
        static let PicUrl = "secure_url"
    }
    
    struct DESCRIPTION {
        static let Text = "plain_text"
    }
    
    
    class func loadList(for string:String, completed:@escaping DownloadComplete ) {
        let path = string.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)
        Alamofire.request(SEARCH_URL + path! + URL_SUFFIX).responseJSON { response in
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
                        if let id = item[ITEM.Id] as? String {
                            search.site = ITEM_URL + id + URL_SUFFIX
                            search.id = id
                        }
                    }
                    ad.saveContext()
                }
            }
            completed()
        }
    }
    
    class func loadItem(for itemId:String, completed:@escaping DownloadProductComplete ) {
        Alamofire.request(ITEM_URL + itemId + URL_SUFFIX).responseJSON { response in
            let product = Product(context: context)
            if let dict = response.result.value as? Dictionary<String,AnyObject> {
                if let title = dict[PRODUCT.Title] as? String {
                    product.title = title
                }
                if let price = dict[PRODUCT.Price] as? Double {
                    product.price = price
                }
                if let currency = dict[PRODUCT.Currency] as? String {
                    product.currency = currency
                }
                if let pictures = dict[PRODUCT.Pictures] as? [Dictionary<String,AnyObject>] {
                    if let imgUrl = pictures[0][PRODUCT.PicUrl] as? String {
                        product.imgUrl = imgUrl
                    }
                }
                if let id = dict[PRODUCT.Id] as? String {
                    product.id = id
                    if let descripts = dict[PRODUCT.Descript] as? [Dictionary<String,AnyObject>] {
                        if descripts.count > 0 {
                            REST.loadDescription(id, completed: { (descript) in
                                product.descript = descript
                                completed(product)
                            })
                        } else {
                            product.descript = ""
                            completed(product)
                        }
                    }
                }
            }
        }
    }
    
    class private func loadDescription(_ itemId:String, completed:@escaping DownloadDescriptionComplete ) {
        Alamofire.request(ITEM_URL + itemId + URL_DESCRIPT_SUFFIX).responseJSON { response in
            if let dict = response.result.value as? [Dictionary<String,AnyObject>] {
                if let result = dict[0][DESCRIPTION.Text] as? String {
                    completed(result)
                }
            }
        }
    }

}
