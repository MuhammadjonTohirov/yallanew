//
//  HomeView.swift
//  yalla
//
//  Created by Muhammadjon Tohirov on 15/10/25.
//

import Foundation
import SwiftUI

struct HomeView: View {
    @StateObject
    private var viewModel: HomeViewModel = .init()
    
    var body: some View {
        Text(verbatim: "Hello, World!")
    }
}
