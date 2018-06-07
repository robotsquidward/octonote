
//
//  TextEntryViewController.swift
//  octonotes
//
//  Created by AJ Kueterman on 6/4/18.
//  Copyright © 2018 Base11 Studios. All rights reserved.
//

import Foundation
import UIKit

class TextEntryViewController: UIViewController, NSTextStorageDelegate {
    
    @IBOutlet weak var mdTextView: UITextView!
    
    @IBOutlet weak var keyboardHeight: NSLayoutConstraint!
    
    @IBAction func saveAction(_ sender: Any) {
    }
    
    @IBAction func cancelAction(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mdTextView.textStorage.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(keyboardWillBeShown(note:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
        notificationCenter.addObserver(self, selector: #selector(keyboardWillBeHidden(note:)), name: Notification.Name.UIKeyboardWillHide, object: nil)
    }
    
    
    /* Keyboard Notification Handler */
    @objc func keyboardWillBeShown(note: Notification) {
        let userInfo = note.userInfo
        let keyboardFrame = userInfo?[UIKeyboardFrameEndUserInfoKey] as! CGRect
        if (UIDevice.modelName == "iPhone X") {
            keyboardHeight.constant = keyboardFrame.height - 30
        } else {
            keyboardHeight.constant = keyboardFrame.height
        }
    }
    
    @objc func keyboardWillBeHidden(note: Notification) {
        keyboardHeight.constant = 0
    }
    
    /* Text Storage Delegate Methods */
    func textStorage(_ textStorage: NSTextStorage, didProcessEditing editedMask: NSTextStorageEditActions, range editedRange: NSRange, changeInLength delta: Int) {
        
        let boldRanges = getRangeForString(regexString: "\\*{2}(.*?)\\*{2}", text: textStorage.string)
        let italicRanges = getRangeForString(regexString: "\\*{1}(.*?)\\*{1}", text: textStorage.string)
        let inlineRanges = getRangeForString(regexString: "\\`{1}(.*?)\\`{1}", text: textStorage.string)
        let codeBlockRanges = getRangeForString(regexString: "\\`{3}([\\s\\S]*?)\\`{3}", text: textStorage.string)
        let bulletRanges = getBulletRanges(text: textStorage.string)
        let h1Ranges = getRangeForString(regexString: "#([ ].*?)\\n", text: textStorage.string)
        let h2Ranges = getRangeForString(regexString: "##([ ].*?)\\n", text: textStorage.string)
        let h3Ranges = getRangeForString(regexString: "###([ ].*?)\\n", text: textStorage.string)
        let h4Ranges = getRangeForString(regexString: "####([ ].*?)\\n", text: textStorage.string)
        let h5Ranges = getRangeForString(regexString: "#####([ ].*?)\\n", text: textStorage.string)

        
        let font = UIFont.systemFont(ofSize: 15)
        let boldFont = UIFont(descriptor: font.fontDescriptor.withSymbolicTraits(.traitBold)!, size: font.pointSize)
        let bigBoldFont = UIFont(descriptor: font.fontDescriptor.withSymbolicTraits(.traitBold)!, size: font.pointSize + 2)
        let italicFont = UIFont(descriptor: font.fontDescriptor.withSymbolicTraits(.traitItalic)!, size: font.pointSize)
        let inlineFont = UIFont(name: "Menlo", size: 14)!
        
        let h1Font = UIFont.systemFont(ofSize: 30)
        let h2Font = UIFont.systemFont(ofSize: 22)
        let h3Font = UIFont.systemFont(ofSize: 18)
        let h4Font = UIFont.systemFont(ofSize: 16)
        let h5Font = UIFont.systemFont(ofSize: 12)

        
        let bulletParagraph = NSMutableParagraphStyle()
        bulletParagraph.firstLineHeadIndent = CGFloat(10)
       
        // Default Text Styles
        let textStrRange = NSMakeRange(0, textStorage.string.count)
        textStorage.addAttribute(.font, value: font, range: textStrRange)
        textStorage.addAttribute(.foregroundColor, value: UIColor.darkText, range: textStrRange)
        textStorage.addAttribute(.paragraphStyle, value: NSParagraphStyle.default, range: textStrRange)
        
        for boldRange in boldRanges {
            textStorage.addAttribute(.font, value: boldFont, range: boldRange)
        }
        for italicRange in italicRanges {
            textStorage.addAttribute(.font, value: italicFont, range: italicRange)
        }
        for inlineCodeRange in inlineRanges {
            textStorage.addAttribute(.font, value: inlineFont, range: inlineCodeRange)
        }
        for bulletRange in bulletRanges {
            print("bulletRange: \(bulletRange)")
            textStorage.addAttribute(.foregroundColor, value: UIColor.blue, range: bulletRange)
            textStorage.addAttribute(.font, value: bigBoldFont, range: bulletRange)
            textStorage.addAttribute(.paragraphStyle, value: bulletParagraph, range: bulletRange)
        }
        for codeBlockRange in codeBlockRanges {
            textStorage.addAttribute(.font, value: inlineFont, range: codeBlockRange)
        }
        for h1 in h1Ranges {
            textStorage.addAttribute(.font, value: h1Font, range: h1)
        }
        for h2 in h2Ranges {
            textStorage.addAttribute(.font, value: h2Font, range: h2)
        }
        for h3 in h3Ranges {
            textStorage.addAttribute(.font, value: h3Font, range: h3)
        }
        for h4 in h4Ranges {
            textStorage.addAttribute(.font, value: h4Font, range: h4)
        }
        for h5 in h5Ranges {
            textStorage.addAttribute(.font, value: h5Font, range: h5)
        }
    }
    
    func getRangeForString(regexString: String, text: String) -> [NSRange] {
        
        let regex = try! NSRegularExpression(pattern:regexString, options: [])
        var results = [NSRange]()
        
        regex.enumerateMatches(in: text, options: [], range: NSMakeRange(0, text.utf16.count)) { result, flags, stop in
            if let r = result?.range(at: 1), let range = Range(r, in: text) {
                results.append(text.nsRange(from: range))
            }
        }
        
        return results
    }
    
    
    // Bullets are handled slightly differently to only alter the bullet point
    func getBulletRanges(text: String) -> [NSRange] {
        
        let regex = try! NSRegularExpression(pattern:"-([ ].*?)\\n", options: [])
        var results = [NSRange]()
        
        regex.enumerateMatches(in: text, options: [], range: NSMakeRange(0, text.utf16.count)) { result, flags, stop in
            if let r = result?.range(at: 1) {
                let modifiedRange = NSMakeRange(r.location-1, 1)
                if let range = Range(modifiedRange, in: text) {
                    results.append(text.nsRange(from: range))
                }
            }
        }
        
        return results
    }
    
}
