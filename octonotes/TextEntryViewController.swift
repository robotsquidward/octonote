
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
    
    @IBAction func saveAction(_ sender: Any) {
    }
    
    @IBAction func cancelAction(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mdTextView.textStorage.delegate = self
    }
    
    func textStorage(_ textStorage: NSTextStorage, didProcessEditing editedMask: NSTextStorageEditActions, range editedRange: NSRange, changeInLength delta: Int) {
        
        let boldRanges = getBoldRanges(text: textStorage.string)
        let italicRanges = getItalicRanges(text: textStorage.string)
        
        let font = UIFont.systemFont(ofSize: 14)
        let boldFont = UIFont(descriptor: font.fontDescriptor.withSymbolicTraits(.traitBold)!, size: font.pointSize)
        let italicFont = UIFont(descriptor: font.fontDescriptor.withSymbolicTraits(.traitItalic)!, size: font.pointSize)
        
        for boldRange in boldRanges {
            textStorage.addAttribute(.font, value: boldFont, range: boldRange)
        }
        for italicRange in italicRanges {
            textStorage.addAttribute(.font, value: italicFont, range: italicRange)
        }
    }
    
    func getBoldRanges(text: String) -> [NSRange] {
        
        let regex = try! NSRegularExpression(pattern:"\\*{2}(.*?)\\*{2}", options: [])
        var results = [NSRange]()
        
        regex.enumerateMatches(in: text, options: [], range: NSMakeRange(0, text.utf16.count)) { result, flags, stop in
            if let r = result?.range(at: 1), let range = Range(r, in: text) {
                results.append(text.nsRange(from: range))
            }
        }
        
        return results
    }
    
    func getItalicRanges(text: String) -> [NSRange] {
        
        let regex = try! NSRegularExpression(pattern:"\\*{1}(.*?)\\*{1}", options: [])
        var results = [NSRange]()
        
        regex.enumerateMatches(in: text, options: [], range: NSMakeRange(0, text.utf16.count)) { result, flags, stop in
            if let r = result?.range(at: 1), let range = Range(r, in: text) {
                results.append(text.nsRange(from: range))
            }
        }
        
        return results
    }
}
