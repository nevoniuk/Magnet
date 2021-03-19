//
//  RoundedView.swift
//  Magnet
//
//  Created by Natalie Evoniuk on 3/19/21.
//

import UIKit

class RoundedView: UIView {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 20
        self.clipsToBounds = true
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
