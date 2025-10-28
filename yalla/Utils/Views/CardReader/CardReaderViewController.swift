//
//  CardReaderViewController.swift
//  Ildam
//
//  Created by Sardorbek Saydamatov on 22/11/24.
//

import UIKit
import SQBCardScanner

final class CardReaderViewController: UIViewController, ScanDelegate, ScanStringsDataSource {
    
    var onSuccess: ((_ number: String, _ date: String) -> Void)?
    var onDismiss: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cardScannerVC = ScanViewController.createViewController(withDelegate: self)!
        
        addChild(cardScannerVC)
        cardScannerVC.view.frame = view.bounds
        view.addSubview(cardScannerVC.view)
    //    cardScannerVC.didMove(toParent: self)
    }
    
    func showCardScanner() {
        guard let vc = ScanViewController.createViewController(withDelegate: self) else { return }
        
        vc.stringDataSource = self
        
        present(vc, animated: true)
    }
    
    func userDidCancel(_ scanViewController: SQBCardScanner.ScanViewController) {
        onDismiss?()
        dismiss(animated: true, completion: nil)
    }
    
    func userDidScanCard(_ scanViewController: SQBCardScanner.ScanViewController, creditCard: SQBCardScanner.CreditCard) {
        let number = creditCard.number
        let date = "\(creditCard.expiryMonth ?? "")/\(creditCard.expiryYear ?? "")"
        onSuccess?(number, date)
        dismiss(animated: true, completion: nil)
    }
    
    func userDidSkip(_ scanViewController: SQBCardScanner.ScanViewController) {
        onDismiss?()
        dismiss(animated: true, completion: nil)
    }
    
    func scanCard() -> String {
        return "Scan Card"
    }
    
    func positionCard() -> String {
        return "Position Card"
    }
    
    func backButton() -> String {
        return "Back"
    }
    
    func skipButton() -> String {
        return "Skip"
    }
}
