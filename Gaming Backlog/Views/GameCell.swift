//
//  GameCellTableViewCell.swift
//  Gaming Backlog
//
//  Created by Ahmed Al Ramadhan on 07/12/2021.
//

import UIKit

class GameCell: UITableViewCell {
    @IBOutlet weak var gameTitleLabel: UILabel!
    @IBOutlet weak var gameImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
