//
//  DetailViewController.swift
//  Mercado
//
//  Created by Aleksei Neronov on 23.01.17.
//  Copyright © 2017 Aleksei Neronov. All rights reserved.
//

import UIKit
import Alamofire

class DetailViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!

    var image: UIImage?
    var number: String?
    var titleItem: String?
    var price: String?

    var product: Product? { didSet { updateUI() } }
    
    var titleText: String? {
        didSet {
            self.navigationItem.title = titleText
        }
    }
    
    var productId: String? {
        didSet {
            REST.loadItem(for: productId!) { (prod) in
                
                self.product = prod
                if let url = self.product?.imgUrl {
                    Alamofire.request(url).responseImage { response in
                        if let image = response.result.value {
                            self.product?.image = image
                            self.imageView?.image = image
                            self.indicator.stopAnimating()
                            ad.saveContext()
                        }
                    }
                }
                ad.saveContext()
            }
        }
    }
    
    override func viewDidLoad() {
        imageView?.image = image
        numberLabel?.text = number
        titleLabel?.text = titleItem
        priceLabel?.text = price
        descriptionLabel?.text = ""
    }
    
    private func updateUI() {
        if let number = product?.id {
            numberLabel?.text = number
        }
        if let title = product?.title {
            titleLabel?.text = title
        }
        if let price = product?.price,
            let curr = product?.currency {
            priceLabel?.text = "Price: \(price) \(curr)"
        }
        if let description = product?.descript {
            descriptionLabel?.text = description
        }
        if let image = product?.image as? UIImage {
            imageView?.image = image
        }
    }

}
