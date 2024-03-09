//
//  AttaintTableViewCell.swift
//  swap
//
//  Created by SUNG on 3/5/24.
//

import UIKit

class AttaintTableViewCell: UITableViewCell {
    @IBOutlet weak var titelLabel: UILabel!
    @IBOutlet weak var completedView: UIView!
    var imageViews: [UIImageView] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupImageViews()
    }
    
    func setupImageViews() {
        for i in 1...31 {
            if let imageView = self.contentView.viewWithTag(i) as? UIImageView {
                imageViews.append(imageView)
            }
        }
    }
}
