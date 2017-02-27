//
//  AlertCVCell.swift
//  house
//
//  Created by Michael Arbuckle on 1/1/17.
//  Copyright © 2017 Michael Arbuckle. All rights reserved.
//

import Foundation
import UIKit

class AlertCVCell: UICollectionViewCell {
    
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var topic: UILabel!
    
    
    // MARK: - Properties
    override var isSelected: Bool {
        didSet {
            icon.layer.borderWidth = isSelected ? 10 : 0
        }
    }
    
    // MARK: - View Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        //imageView.layer.borderColor = themeColor.cgColor
        isSelected = false
    }
}
