//
//  SearchTableCell.swift
//  Mercado
//
//  Created by Aleksei Neronov on 23.01.17.
//  Copyright © 2017 Aleksei Neronov. All rights reserved.
//

import UIKit

class SearchTableCell: UITableViewCell {

    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var thumb: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    func configureCell(item: Search) {
        title.text = item.title
        priceLabel.text = "\(item.price)"
//        thumb.image = item.thumbImg as? UIImage
//        indicator.stopAnimating()
    }

}
