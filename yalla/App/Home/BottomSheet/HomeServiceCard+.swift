//
//  HomeServiceCard+.swift
//  yalla
//
//  Created by Muhammadjon Tohirov on 11/11/25.
//

import Foundation

extension HomeServicesCard.Service {
    var headerInput: HomeIdleSheetHeader.Input {
        HomeIdleHeaderCustomInput(image: self.logoImageName, title: self.title)
    }
}
