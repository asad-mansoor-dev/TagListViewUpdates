//
//  OccasionsCategroiesTableCell.swift
//  EasyGift
//
//  Created by Asad Mehmood on 24/12/2021.
//  Copyright © 2021 codesrbit. All rights reserved.
//

import UIKit

class OccasionsCategroiesTableCell: UITableViewCell {

    //MARK: - IBOutlet
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var itemImageView: UIImageView!
    
    //MARK: - Variables
    
    //MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.itemImageView.contentMode = .center
        itemImageView.image = UIImage(named: "product-placeholder-")
        nameLabel.text = ""
    }
    
    func config(indexPath: IndexPath, data: [Categories]) {
        if data.count != 0 && indexPath.row <= data.count {
            let dataForRow = data[indexPath.row]
            self.nameLabel.text = dataForRow.name
            if let imageURL = dataForRow.imageUrl {
                if let url = URL(string: imageURL) {
                    self.setImageFrom(url: url)
                }
            }
        }
    }
    func config(indexPath: IndexPath, data: [OccasionsModel]) {
        if data.count != 0 && indexPath.row <= data.count {
            let dataForRow = data[indexPath.row]
            self.nameLabel.text = dataForRow.name
            if let imageURL = dataForRow.imageUrl {
                if let url = URL(string: imageURL) {
                    self.setImageFrom(url: url)
                }
            }
        }
    }
    func setImageFrom(url: URL) {
       
    }
    func hideSkeletonAnimation() {
       
    }
    func showSkeletonAnimation() {
        
    }
}
