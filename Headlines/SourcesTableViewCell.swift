//
//  SourcesTableViewCell.swift
//  Headlines
//
//  Created by Andy Rees on 01/09/2017.
//  Copyright © 2017 rantcode.com. All rights reserved.
//

import UIKit

class SourcesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var NewNameLabel: UILabel!
    
    @IBOutlet weak var NewsUIImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
