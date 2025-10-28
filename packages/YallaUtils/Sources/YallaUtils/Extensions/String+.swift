//
//  String+Extensions.swift
//  YuzSDK
//
//  Created by applebro on 28/04/23.
//

import Foundation
import UIKit

extension Encodable {
    /// Turns json into a Dictionary
    func asDictionary() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)
        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            throw NSError()
        }
        return dictionary
    }
    
    /// Turn json into a string
    var asString: String {
        guard let jsonData = try? JSONEncoder().encode(self) else {
            return ""
        }
        
        return String(data: jsonData, encoding: .utf8) ?? ""
    }
    
    var asData: Data? {
        try? JSONEncoder().encode(self)
    }
}

extension Substring {
    var asString: String {
        String(self)
    }
    
    var asData: Data? {
        self.asString.data(using: .utf8)
    }
}

extension String {
    
    var asInt: Int {
        Int(self) ?? 0
    }
    
    var isInt: Bool {
        Int(self) != nil
    }
    
    // as json object
    func asObject<T: Decodable>() -> T? {
        guard let data = self.asData else {
            return nil
        }
        
        return try? JSONDecoder().decode(T.self, from: data)
    }
    
    // convert json string to json object
    var asJson: Any? {
        guard let data = self.asData else {
            return nil
        }
        
        return try? JSONSerialization.jsonObject(with: data, options: .allowFragments)
    }
    
    // convert json string to dict
    var asDict: [String: Any]? {
        guard let data = self.asData else {
            return nil
        }
        
        return try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
    }
    
    func placeholder(_ text: String) -> String {
        return self.nilIfEmpty == nil ? text : self
    }

    func highlight(text: String, color: UIColor) -> NSAttributedString {
        guard let range = self.range(of: text) else {
            return NSAttributedString(string: self)
        }
        
        let _range = NSRange(range, in: self)
        
        let attr = NSMutableAttributedString(string: self)
        attr.addAttribute(.foregroundColor, value: color, range: _range)
        return attr
    }
    
    func onlyNumberFormat(with mask: String) -> String {
        let text = self
        let numbers = text.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        return numbers.format(with: mask)
    }
    
    func format(with mask: String) -> String {
        let text = self
        
        var result = ""
        var index = text.startIndex // numbers iterator

        // iterate over the mask characters until the iterator of numbers ends
        for ch in mask where index < text.endIndex {
            if ch == "X" {
                // mask requires a number in this place, so take the next one
                result.append(text[index])

                // move numbers iterator to the next index
                index = text.index(after: index)

            } else {
                result.append(ch) // just append a mask character
            }
        }
        return result
    }
    
    var maskAsCardNumber: String {
        var text = self.replacingOccurrences(of: " ", with: "")
        if text.count < 16 {
            return ""
        }

        let replace = "••••••••"
        let range: Range<Index> = self.index(self.startIndex, offsetBy: 4)..<self.index(self.startIndex, offsetBy: 4 + replace.count)

        text = text.replacingCharacters(in: range, with: replace)
        
        return text.format(with: "XXXX XXXX XXXX XXXX")
    }
    
    var maskAsMiniCardNumber: String {
        var text = self.replacingOccurrences(of: " ", with: "")
        if text.count < 9 {
            return ""
        }
        text.removeFirst(text.count - 8)
        let replace = "••••"
        let range: Range<Index> = self.index(self.startIndex, offsetBy: 0)..<self.index(self.startIndex, offsetBy: replace.count)

        text = text.replacingCharacters(in: range, with: replace)
        
        return text.format(with: "XXXX XXXX")
    }
    
    var nilIfEmpty: String? {
        return self.isEmpty ? nil : self
    }
    
    var isNilOrEmpty: Bool {
        return self.nilIfEmpty == nil
    }
    
    var asDouble: Double {
        Double.init(self) ?? 0
    }
}

public extension NSAttributedString {
    var toSwiftUI: AttributedString {
        AttributedString(self)
    }
}
extension String {
    func decodeJSON<T: Decodable>(as type: T.Type) throws -> T {
        let data = Data(self.utf8)
        return try JSONDecoder().decode(T.self, from: data)
    }
    
}

extension String {
    static var empty: Self { "" }
    var carNumberFormat: String {
        let trimmed = self.replacingOccurrences(of: " ", with: "").uppercased()
        
        // Match AAA001
        if let match = trimmed.range(of: #"^[A-Z]{3}[0-9]{3}$"#, options: .regularExpression) {
            let part1 = String(trimmed[match].prefix(3))
            let part2 = String(trimmed[match].suffix(3))
            return "\(part1) \(part2)"
        }
        
        // Match 001AAA
        if let match = trimmed.range(of: #"^[0-9]{3}[A-Z]{3}$"#, options: .regularExpression) {
            let part1 = String(trimmed[match].prefix(3))
            let part2 = String(trimmed[match].suffix(3))
            return "\(part1) \(part2)"
        }
        
        // Match A001AA
        if let match = trimmed.range(of: #"^[A-Z][0-9]{3}[A-Z]{2}$"#, options: .regularExpression) {
            let part1 = String(trimmed[match].prefix(1))
            let part2 = String(trimmed[match].dropFirst(1).prefix(3))
            let part3 = String(trimmed[match].suffix(2))
            return "\(part1) \(part2) \(part3)"
        }
        
        // Match AA001A
        if let match = trimmed.range(of: #"^[A-Z]{2}[0-9]{3}[A-Z]$"#, options: .regularExpression) {
            let part1 = String(trimmed[match].prefix(2))
            let part2 = String(trimmed[match].dropFirst(2).prefix(3))
            let part3 = String(trimmed[match].suffix(1))
            return "\(part1) \(part2) \(part3)"
        }
        
        // If no format matches, return as-is
        return self
    }
}

public extension String {
    var identifier: String {
        self
    }
}
