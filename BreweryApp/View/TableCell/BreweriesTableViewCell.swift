//
//  BreweriesTableViewCell.swift
//  BreweryApp
//
//  Created by Stanislav on 03.04.2021.
//

import UIKit

class BreweriesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titelLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var breweriesImage: UIImageView!
    
    static let reuseIdentifier = "BreweriesCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
