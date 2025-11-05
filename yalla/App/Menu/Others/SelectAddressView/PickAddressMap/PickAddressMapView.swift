//
//  GMapsView.swift
//  Ildam
//
//  Created by applebro on 27/11/23.
//

import Foundation
import SwiftUI
import CoreLocation
import MapPack
import YallaUtils
import Core

struct PickAddressMapView: View {
    @StateObject var viewModel = PickAddressViewModel()
    @State private var bottomSheetRect: CGRect = .init()

    var body: some View {
        ZStack {
            //            backButton
            //                .onClick {
            //                    viewModel.onClickClose()
            //                }
            //                .position(.init(x: 50, y: 40))
            //                .zIndex(3)
            
            UniversalMapView(viewModel: viewModel.mapModel)
                .opacity(!self.viewModel.isLoading ? 1 : 0)
            
            bottomSheet
        }
        .onAppear {
            self.viewModel.onAppear()
            self.viewModel.focusToDesignatedLocation()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.viewModel.focusToDesignatedLocation()
            }
        }
    }
    
    private var backButton: some View {
        Circle()
            .frame(width: 60, height: 60)
            .foregroundStyle(Color.iBackground)
            .overlay(content: {
                Image(systemName: "arrow.left")
                    .font(.system(size: 22))
                    .foregroundStyle(Color.iLabel)
            })
            .shadow(color: .black.opacity(0.1), radius: 20, x: 0, y: 0)
    }
    
    private var focusButton: some View {
        Circle()
            .frame(width: 48.scaled, height: 48.scaled)
            .foregroundStyle(Color.init(uiColor: .systemBackground))
            .overlay {
                Image("icon_gps")
                    .renderingMode(.template)
                    .foregroundStyle(Color.iLabel)
            }
            .shadow(color: .black.opacity(0.1), radius: 20, x: 0, y: 0)
            .padding()
    }
    
    private var bottomSheet: some View {
        VStack {
            Spacer()

            focusButton
                .onClick {
                    self.viewModel.focusToCurrentLocation()
                }
                .horizontal(alignment: .trailing)
            
            VStack(spacing: 0) {
                fieldView
                    .padding()
                    .background {
                        RoundedRectangle(cornerRadius: 16)
                            .foregroundStyle(Color.iBackground)
                    }

                SubmitButtonFactory.primary(title: "select".localize, action: {
                    viewModel.onClickSelect()
                })
                .set(isEnabled: !self.viewModel.isLoading)
                .padding([.horizontal, .bottom])
                .background {
                    RoundedRectangle(cornerRadius: 16)
                        .foregroundStyle(Color.iBackground)
                        .ignoresSafeArea()
                }
            }
            .background {
                RoundedRectangle(cornerRadius: 38.scaled)
                    .foregroundStyle(Color.iBackground)
                    .readRect(rect: $bottomSheetRect)
            }
        }
    }
    
    private var fieldView: some View {
        HStack {
            Circle()
                .frame(height: 8)
                .foregroundStyle(.iPrimary)
            
            Text(viewModel.address)
                .frame(maxWidth: .infinity, alignment: .leading)
                .frame(height: 60.scaled)
                .font(.bodyBaseBold)
        }
        .padding([.horizontal], 16)
        .background {
            RoundedRectangle(cornerRadius: 16)
                .foregroundStyle(Color.iBackgroundSecondary)
        }
    }
}

#Preview {
    UserSettings.shared.accessToken = "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiI1IiwianRpIjoiYWVmMTNhOGFiOGU1NTM2ZDg2ZDhiNTNhZmUzMGZjMjhhOTZiYTdhMGE0MWQ3OTNmMjE2Zjk0OGY2ZTM0MDJhNjYxMTA4NjVjMDI0NjFkOWQiLCJpYXQiOjE3NjEyODIwMjQuNjMwODc1LCJuYmYiOjE3NjEyODIwMjQuNjMwODc3LCJleHAiOjE3OTI4MTgwMjQuNjI3NDcxLCJzdWIiOiIyNDIwMzUiLCJzY29wZXMiOlsiY2xpZW50Il19.6xHFtps-thchETiNDsGDbqB2kbHOBv7pi9TssCOMdyTpA-y9Wq-P2r3GHwQYJH3z2K2zm9Cx5Cl7kQPosx8GPOvtYw6hUTZYgtTzahSckDOFO-HUYJ9uIlWk1HESmExrjpeeF6uVjKcrwbg6K4ddRUcDLSIvs3fOFxveHDyyX41DDqFh8GaPu0cXlRhpnkfYWm_XoCH4FtPtJQHJoq3Wwrxk4dzK2EAoA9olqRNs4V2xPdMEqmnHoO36Hb6Z0K0yBuFH5yHTdzNeBEc5NSU9VYqmep6n_vL1lxvtezYOzqjRcr7OzOutR4dMHpJW4gJqcDcu471_cYsw2MeVqnU3wVuf82iJPqR66mGz7JrKymAkOH5FooRv1-UOlYEXUAOksWQVQ4Q--aIZoum3rdkZL8mGeWpyALPYNleelz6oF6w1IhXq1xlYahnBdmuQ1sRRxp8vVc6GKEnuicEmQ6RKS1dwf1wU0o3qO39oNZ7cebN19Rfon_9gEtud43P2oFGgUEt5x2c3N5Bzc-pzOObMNnBMphANg3pPBq0ur4yqzMzF4t6vd_S86PqrI386B6beOEhYwGYUxEfWZa-8tM-u5WhuwiuYAvD-yIxuyuH6oPCHfc_1I8qptn0I4Gkv2hfsC_z0i5mBmatCXyw-8SPLfmJeTkIE4EJO2-cEjgv3HEw"
    
    UserSettings.shared.userInfo = .init(
        id: 0,
        phone: "+998935852415"
    )
    
    return NavigationStack {
        PickAddressMapView()
    }
}

