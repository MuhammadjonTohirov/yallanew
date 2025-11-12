//
//  HomeMapViewModel+Delegate.swift
//  yalla
//
//  Created by Muhammadjon Tohirov on 12/11/25.
//

import Foundation

protocol HomeMapViewModelDelegate: AnyObject {
    func homeMap(_ viewModel: HomeMapViewModel, dragging: Bool)
}
