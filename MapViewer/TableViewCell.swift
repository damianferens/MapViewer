//
//  TableViewCell.swift
//  MapViewer
//
//  Created by Damian Ferens on 17.03.2017.
//  Copyright © 2017 Damian Ferens. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    @IBOutlet weak var placeNameLabel: UILabel!
    
    @IBOutlet weak var geographicalCoordinatesLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
