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
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var descriptionText: UITextView!

    var thumb: UIImage?
    var number: String?
    var titleItem: String?
    var price: String?

    var product: Product?
    
    var titleText: String? {
        didSet {
            self.navigationItem.title = titleText
        }
    }
    
    var productId: String? {
        didSet {
            REST.loadItem(for: productId!) {[weak weakself = self] (prod) in
                
                self.product = prod
                self.product?.thumb = weakself?.thumb
                self.product?.created = NSDate()
                if let descript = weakself?.product?.descript, descript.characters.count > 0 {
                    self.descriptionText?.text = descript
                    self.descriptionText?.flashScrollIndicators()
                    self.descriptionText?.isHidden = false
                }
                if let url = weakself?.product?.imgUrl {
                    Alamofire.request(url).responseImage { response in
                        if let image = response.result.value {
                            self.product?.image = image
                            self.imageView?.image = image
                            self.indicator.stopAnimating()
                            ad.saveContext()
                        }
                    }
                } else {
                    // no image
                    self.indicator.stopAnimating()
                }
                ad.saveContext()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        imageView?.image = thumb
        numberLabel?.text = number
        titleLabel?.text = titleItem
        priceLabel?.text = price
        descriptionText?.text = ""
        descriptionText?.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if product != nil {
            updateUI()
        }
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
        if let descript = product?.descript, descript.characters.count > 0 {
            descriptionText?.text = descript
            descriptionText?.flashScrollIndicators()
            descriptionText?.isHidden = false
        }
        if let image = product?.image as? UIImage {
            imageView?.image = image
            indicator.stopAnimating()
        } else {
            // no image
            imageView?.image = UIImage(named: "imagePick")
            indicator.stopAnimating()
        }
    }

}
