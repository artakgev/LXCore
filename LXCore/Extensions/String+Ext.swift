//
//  String+Ext.swift
//  LXCore
//
//  Created by Artak Gevorgyan on 7/8/20.
//  Copyright © 2022 Artak Gevorgyan. All rights reserved.
//

import UIKit
// swiftlint:disable all
extension String {

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
    
	func applyPatternOnNumbers(pattern: String, replacementCharacter: Character) -> String {
		var pureNumber = self.replacingOccurrences( of: "[^0-9]", with: "", options: .regularExpression)
		for index in 0 ..< pattern.count {
			guard index < pureNumber.count else { return pureNumber }
			//let stringIndex = String.Index(encodedOffset: index)
			let stringIndex = String.Index(utf16Offset: index, in: pattern)
			let patternCharacter = pattern[stringIndex]
			guard patternCharacter != replacementCharacter else { continue }
			pureNumber.insert(patternCharacter, at: stringIndex)
		}
		return pureNumber
	}

	func removeExtraNewLines() -> String {
		return self
			.replacingOccurrences(of: "\t", with: "")
			.replacingOccurrences(of: " \r ", with: " \n") //enter
			.replacingOccurrences(of: "\r ", with: "\n ")
			.replacingOccurrences(of: "\r\n", with: "\n")
			.replacingOccurrences(of: "\n\r", with: "\n")
			.replacingOccurrences(of: "\n ", with: "\n")
			.replacingOccurrences(of: "  ", with: " ")
			.replacingOccurrences(of: "  ", with: " ")
			.trimmingCharacters(in: .whitespacesAndNewlines)
	}
    
    func removeNonNumbers() -> String {
        return filter("0123456789.".contains)
    }
    
    func removeNonDigits() -> String {
        return filter("0123456789".contains)
    }
    
    func replaceWithAsterisks(starting from: Int) -> String {
        let str = (self as NSString)
        if from < 0 || from > self.count {
            return self
        }
        let replaceLength = self.count - from
        let range = NSMakeRange(from, replaceLength)
        return str.replacingCharacters(in: range, with: String(repeating: "*", count: replaceLength))
    }
    
    func toDouble() -> Double? {
        let clearedText = removeNonNumbers()
//        guard clearedText.isNotEmpty else { return 0 }
        return Double(clearedText)
    }
    
    func toInt() -> Int? {
        let clearedText = removeNonDigits()
//        guard clearedText.isNotEmpty else { return 0 }
        return Int(clearedText)
    }

    var lastPathComponent: String {
        return (self as NSString).lastPathComponent
    }
}

public extension String {
    subscript (i: Int) -> Character {
        return self[index(startIndex, offsetBy: i)]
    }
    
    subscript (i: Int) -> String {
        return String(self[i] as Character)
    }
    
    subscript (r: Range<Int>) -> String {
        let start = index(startIndex, offsetBy: r.lowerBound)
        let end = index(startIndex, offsetBy: r.upperBound)
        return String(self[start ..< end])
    }
    
    var containsAlphabets: Bool {
        //Checks if all the characters inside the string are alphabets
        let set = CharacterSet.letters
        return self.utf16.contains {
            guard let unicode = UnicodeScalar($0) else { return false }
            return set.contains(unicode)
        }
    }
}


extension UITextField {
	func setPatternedText(_ text: String?) {
		let selection = selectedTextRange
		self.text = text
		if let selection = selection {
			var cursorPosition = selection.start
			let location = self.offset(from: self.beginningOfDocument, to: cursorPosition) - 1
			if
				let text = self.text,
				location >= 0,
				location < text.count,
				text[location] == " " {
				cursorPosition = self.position(from: selection.start, offset: 1) ?? cursorPosition
			}
			selectedTextRange = self.textRange(from: cursorPosition, to: cursorPosition)
		}
	}
}

