//
//  finalDrinkReuseCell.swift
//  drinkApp
//
//  Created by 林祐辰 on 2020/10/4.
//

import UIKit

class finalDrinkReuseCell: UITableViewCell {

    @IBOutlet weak var drinkImage: UIImageView!
    @IBOutlet weak var finalOrderPerson: UILabel!
    @IBOutlet weak var finalDrink: UILabel!
    
    @IBOutlet weak var drinkFinalSize: UILabel!
    @IBOutlet weak var drinkFinalSugar: UILabel!
    @IBOutlet weak var drinkFinalIce: UILabel!
    @IBOutlet weak var drinkFinalPrice: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
