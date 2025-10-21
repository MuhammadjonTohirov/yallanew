//
//  Language.swift
//  YallaUtils
//
//  Created by Muhammadjon Tohirov on 17/10/25.
//



import Foundation

public protocol LanguageProtocol: Codable, Sendable {
    var name: String {get}
    var code: String {get}
}

public struct LanguageUz: LanguageProtocol {
    public var name: String { "O'zbek tili" }
    
    public var code: String { "uz" }
    
    public init() {
        
    }
}

public struct LanguageRu: LanguageProtocol {
    public var name: String { "Русский" }
    
    public var code: String { "ru" }
    
    public init() {
        
    }
}

public struct LanguageEn: LanguageProtocol {
    public var name: String { "English" }
    
    public var code: String { "en" }
    
    public init() {
        
    }
}

public struct LanguageUzCryl: LanguageProtocol {
    public var name: String { "Ўзбек тили" }
    
    public var code: String { "uz-Cyrl" }
    
    public init() {
        
    }
}

public actor LanguageStore {
    public private(set) var current: any LanguageProtocol = LanguageUz()
    
    public func set(_ language: any LanguageProtocol) {
        self.current = language
    }
}

public let languageStore = LanguageStore()
