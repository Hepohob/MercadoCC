//
//  Constants.swift
//  Mercado
//
//  Created by Aleksei Neronov on 23.01.17.
//  Copyright © 2017 Aleksei Neronov. All rights reserved.
//

import Foundation

let SEARCH_URL = "https://api.mercadolibre.com/sites/MLU/search?q="
let ITEM_URL = "https://api.mercadolibre.com/items/"
let URL_SUFFIX = "#json"
let URL_DESCRIPT_SUFFIX = "/descriptions#json"

typealias DownloadComplete = () -> ()
typealias DownloadProductComplete = (_ product:Product) -> ()
typealias DownloadDescriptionComplete = (_ descript:String) -> ()
