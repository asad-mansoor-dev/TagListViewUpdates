//
//  RadioButton.swift
//  EasyGift
//
//  Created by Asad Mehmood on 07/10/2021.
//  Copyright © 2021 codesrbit. All rights reserved.
//

import UIKit

class RadioButton: UIButton {
    
    var alternateButton:Array<RadioButton>?
    let checkedImage = UIImage(named: "radio-btn-select-")! as UIImage
    let uncheckedImage = UIImage(named: "radio-btn-")! as UIImage
    var fromLanguage = Bool()
    func unselectAlternateButtons() {
        if alternateButton != nil {
            for button:RadioButton in alternateButton! {
                button.isSelected = false
            }
        }
    }
    
    func toggleButton() {
        self.isSelected = !isSelected
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                self.tintColor = UIColor.yellow
                self.setImage(checkedImage, for: .selected)
                self.setTitleColor(UIColor.yellow, for: .selected)
            }
            else {
                self.tintColor = UIColor.gray
                self.setImage(uncheckedImage, for: .normal)
                self.setTitleColor(UIColor.gray, for: .normal)
            }
        }
    }
}
