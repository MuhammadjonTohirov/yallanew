//
//  BaseViewModelProtocol.swift
//  Ildam
//
//  Created by applebro on 27/11/23.
//

import Foundation
import Core
import SwiftUI
import Combine

protocol BaseViewModelProtocol: ObservableObject {
    var didAppear: Bool {get set}
    
    func onFirstAppear()
    
    func onAppear()
    
    func onDisappear()
    
    func alert(title: String?, message: String)
    
    func hideAlert()
}

struct CustomAlertInputData {
    var title: String
    var message: String
    var actions: [AlertButton]
}

class BaseViewModel: BaseViewModelProtocol {
    var didAppear: Bool = false
    var alertData: CustomAlertInputData?
    
    @Published var showAlert = false
    
    func onFirstAppear() {
        
    }
    
    func onAppear() {
        if !didAppear {
            onFirstAppear()
        }
        
        didAppear = true
    }
    
    func onDisappear() {
        
    }
    
    func alert(title: String?, message: String) {
        self.alertData = .init(title: title ?? "", message: message, actions: [
            PrimaryAlertButton(title: "OK", action: {
                self.showAlert = false
            })
        ])
        
        showAlert = true
    }
    
    func alert(title: String?, message: String, actions: [AlertButton]) {
        self.alertData = .init(title: title ?? "", message: message, actions: actions)
        
        showAlert = true
    }
    
    func hideAlert() {
        showAlert = false
    }
}
