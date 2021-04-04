//
//  BeerDetailViewController.swift
//  BreweryApp
//
//  Created by Stanislav on 04.04.2021.
//

import UIKit

class BeerDetailViewController: UIViewController {
    
    
    @IBOutlet weak var imageViewBear: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var nameLabelSting: String? = "" {
        didSet {
            if (nameLabelSting == "") {
                nameLabelSting = "Имя отсутствует"
            }
        }
    }
    
    var descriptionLabelSting: String? = "" {
        didSet {
            if (descriptionLabelSting == "") {
                descriptionLabelSting = "Описание отсутствует"
            }
        }
    }
    
    var imageBeer: UIImage? = nil {
        didSet {
            if imageBeer == nil {
                imageBeer = UIImage(named: Constants.imageBeer)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = nameLabelSting
        descriptionLabel.text = descriptionLabelSting
        imageViewBear.image = imageBeer
    }
}
