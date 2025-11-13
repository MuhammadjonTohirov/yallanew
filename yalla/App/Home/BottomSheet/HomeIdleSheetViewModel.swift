//
//  HomeIdleSheetViewModel.swift
//  yalla
//
//  Created by Muhammadjon Tohirov on 11/11/25.
//

import Foundation
import Combine
import Core
import CoreGraphics

final class HomeIdleSheetViewModel: ObservableObject {
    @MainActor
    @Published
    private(set) var services: [HomeServicesCard.Service] = []
    
    @MainActor
    @Published
    private(set) var activeService: HomeServicesCard.Service?
    
    private var cancellables = Set<AnyCancellable>()
        
    private var didAppear: Bool = false
    
    func onAppear() {
        if didAppear { return }
        didAppear = false
        
        services = [
            .init(title: "intercity".localize, backgroundImageName: "img_bg_intercity", logoImageName: "img_pins_left"),
            .init(title: "mail".localize, backgroundImageName: "img_bg_post", logoImageName: "img_mail_left"),
            .init(title: "delivery".localize, backgroundImageName: "img_bg_delivery", logoImageName: "img_box_left"),
            .init(title: "taxi".localize, backgroundImageName: "img_bg_taxi", logoImageName: "img_car_left"),
        ]
        
        set(activeService: services.last)
    }
}

extension HomeIdleSheetViewModel {
    // MARK: Set actions
    
    @MainActor
    func set(activeService: HomeServicesCard.Service?) {
        self.activeService = activeService
    }
}

extension HomeIdleSheetViewModel {

}
