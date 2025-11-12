//
//  HomeStateObserver.swift
//  yalla
//
//  Created by Muhammadjon Tohirov on 12/11/25.
//

import Foundation
import Combine
import SwiftUI

@MainActor
final class HomePropertiesHolder: ObservableObject {
    static let shared = HomePropertiesHolder()

    // MARK: - Public published states (only these re-render)
    @Published var bottomSheetHeight: CGFloat = .zero
    @Published var isBottomSheetMinimized: Bool = false

    // MARK: - Private
    private let rawIsBottomSheetMinimizedSubject = PassthroughSubject<Bool, Never>()
    private var cancellables: Set<AnyCancellable> = []

    // MARK: - Setup
    func setup() {
        setupIsBottomSheetMinimizedObserver()
    }

    private func setupIsBottomSheetMinimizedObserver() {
        rawIsBottomSheetMinimizedSubject
            .removeDuplicates()
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .sink { [weak self] value in
                self?.setBottomSheetMinimized(value)
            }
            .store(in: &cancellables)
    }

    // MARK: - Internal helpers
    private func setBottomSheetMinimized(_ isMinimized: Bool) {
        guard isBottomSheetMinimized != isMinimized else { return }

        withAnimation(.spring(duration: 0.3)) {
            self.isBottomSheetMinimized = isMinimized
        }
    }

    // MARK: - Public interface (keep original naming)
    func set(isBottomSheetMinimized: Bool) {
        if isBottomSheetMinimized {
            // immediate collapse (like before)
            self.setBottomSheetMinimized(true)
        }
        // send through subject instead of @Published
        self.rawIsBottomSheetMinimizedSubject.send(isBottomSheetMinimized)
    }

    func setBottomSheetHeight(_ height: CGFloat) {
        self.bottomSheetHeight = height
    }
}
