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
    
    override func prepareForReuse() {
        indicator.startAnimating()
        thumb.image = nil
        title.text = nil
        priceLabel.text = nil
    }
    
    func configureCell(item: Search) {
        title.text = item.title
        priceLabel.text = "Price: \(item.price) \(item.currency ?? "")"
    }
    
    func configureCell(image: UIImage) {
        thumb.image = image
        indicator.stopAnimating()
    }
    
    func configureCell(product: Product) {
        title.text = product.title
        priceLabel.text = "Price: \(product.price) \(product.currency ?? "")"
        if let image = product.image as? UIImage {
            thumb.image = image
        } else {
            // no image
            thumb.image = UIImage(named: "imagePick")
        }
        indicator.stopAnimating()
    }

}
