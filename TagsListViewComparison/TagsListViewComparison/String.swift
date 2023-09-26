//
//  File.swift
//  Abbel-Cars
//
//  Created by a on 28/08/2020.
//  Copyright © 2020 Mian Faizan Nasir. All rights reserved.
//

import Foundation
import  UIKit

extension String {
    
//    var iso8601withFractionalSeconds: Date? { return Formatter.iso8601withFractionalSeconds.date(from: self) }
    var isValidEmail: Bool {
        let regularExpressionForEmail = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let testEmail = NSPredicate(format:"SELF MATCHES %@", regularExpressionForEmail)
        return testEmail.evaluate(with: self)
    }
    var isReallyEmpty: Bool {
        return self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return nil }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return nil
        }
    }
    
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
    
    func returnColor() -> UIColor? {
        switch(self){
        case "Red":
            return UIColor.red
        case "Black":
            return UIColor.black
        case "Blue":
            return UIColor.blue
        case "Yellow":
            return UIColor.yellow
        case "Pink":
            return UIColor.systemPink
        case "Gray":
            return UIColor.gray
        case "White":
            return UIColor.white
        case "Cyan":
            return UIColor.cyan
        case "Green":
            return UIColor.green
        default:
            return nil
        }
    }
    func stringToDate(_ dateFormatter : String) -> Date?
    {
        let formatter = DateFormatter()
        
        formatter.dateFormat = dateFormatter//"MMM dd, yyyy"
        let date = formatter.date(from: self)
        
        return date
    }
    
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        
        return ceil(boundingBox.width)
    }
}
