//
//  HomeStateObserver.swift
//  yalla
//
//  Created by Muhammadjon Tohirov on 12/11/25.
//

import Foundation
import Combine

actor HomePropertiesHolder: ObservableObject, Sendable {
    static let shared: HomePropertiesHolder = .init()
    
    @Published
    @MainActor
    var bottomSheetHeight: CGFloat = .zero
    
    @Published
    @MainActor
    var isBottomSheetMinimized: Bool = false
    
    @Published
    @MainActor
    private var rawIsBottomSheetMinimized: Bool = false
    
    var cancellables: Set<AnyCancellable> = []
    
    func setup() {
        setupIsBottomSheetMinimizedObserver()
    }
    
    private func setupIsBottomSheetMinimizedObserver() {
        $rawIsBottomSheetMinimized
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .sink { [weak self] value in
                guard let self else { return }
                Task { @MainActor in
                    self.setBottomSheetMinimized(value)
                }
            }
            .store(in: &cancellables)
    }
    
    @MainActor
    private func setBottomSheetMinimized(_ isMinimized: Bool) {
        self.isBottomSheetMinimized = isMinimized
    }
    
    @MainActor
    func set(isBottomSheetMinimized: Bool) {
        if isBottomSheetMinimized {
            self.setBottomSheetMinimized(true)
        }
        self.rawIsBottomSheetMinimized = isBottomSheetMinimized
    }
    
    @MainActor
    func setBottomSheetHeight(_ height: CGFloat) {
        self.bottomSheetHeight = height
    }
}

