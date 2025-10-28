//
//  CardReaderWrapper.swift
//  Ildam
//
//  Created by Sardorbek Saydamatov on 22/11/24.
//

import SwiftUI

struct CardReaderWrapper: UIViewControllerRepresentable {    
    var onSuccess: ((_ number: String, _ date: String) -> Void)?
    
    func makeUIViewController(context: Context) -> CardReaderViewController {
        let vc = CardReaderViewController()
        
        vc.onSuccess = { number, date in
            onSuccess?(number, date)
        }
        
        vc.onDismiss = {

        }
        
        return vc
    }
    
    func updateUIViewController(_ uiViewController: CardReaderViewController, context: Context) {
        
    }
    
    typealias UIViewControllerType = CardReaderViewController
}

struct CardReaderWerapper_Previews: PreviewProvider {
    static var previews: some View {
        CardReaderWrapper()
            .ignoresSafeArea()
    }
}
