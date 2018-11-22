//
//  ImageViewCell.swift
//  CaseyImageView
//
//  Created by Casey on 22/11/2018.
//  Copyright © 2018 Casey. All rights reserved.
//

import UIKit

class ImageViewCell: UITableViewCell {

    
    @IBOutlet var  imgView:UIImageView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
