//
//  ShowTableViewCell.swift
//  Media Center
//
//  Created by Timothy Barnard on 05/12/2015.
//  Copyright © 2015 Timothy Barnard. All rights reserved.
//

import UIKit

class ShowTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var showName: UILabel!
    
    @IBOutlet weak var showSeason: UILabel!

    @IBOutlet weak var showEpisode: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
