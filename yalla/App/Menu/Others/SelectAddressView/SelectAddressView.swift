//
//  SelectAddressView.swift
//  Ildam
//
//  Created by applebro on 20/12/23.
//

import Foundation
import SwiftUI
import YallaUtils
import CoreLocation
import Core

enum SelectAddressField {
    case from
    case to
}

struct SelectAddressView: View {
    @StateObject var viewModel: SelectAddressViewModel = .init()

    @FocusState var focusState: SelectAddressField?
    
    @Environment(\.dismiss) var dismiss
        
    var body: some View {
        innerBody
    }

    private var innerBody: some View {
        addressListView
            .transition(.move(edge: .leading).combined(with: .opacity))
            .onChange(of: viewModel.shouldDismiss, perform: { newValue in
                if newValue {
                    self.dismiss.callAsFunction()
                }
            })
            .onChange(of: self.focusState, perform: { value in
                if value == nil {
                    return
                }
                value == .from ? self.viewModel.onSelectFromField() : self.viewModel.onSelectToField()
            })
            .fullScreenCover(isPresented: $viewModel.showMap, content: {
                PickAddressMapView(viewModel: self.viewModel.mapModel)
            })
            .onAppear {
                viewModel.onAppear()
                self.focusState = self.viewModel.selectedField
            }
            .onDisappear {
                onDisappear()
            }
    }
    
    private func onDisappear() {
        viewModel.onDisappear()
    }
    
    private var addressListView: some View {
        VStack(alignment: .leading, spacing: 20) {
            fieldsView
                .padding(AppParams.Padding.medium)

            ZStack {
                LazyVStack(spacing: 0) {
                    ForEach(viewModel.addressList) { address in
                        addressItem(
                            image: Image("icon_circle"),
                            title: address.address,
                            detail: address.name ?? "",
                            distance: address.distanceString
                        )
                        .onTapped {
                            self.viewModel.onSelect(address: address)
                            self.dismiss.callAsFunction()
                        }
                        .frame(height: 60)
                    }
                }
                .scrollable()
                .padding(.top, 10)
                .opacity(viewModel.isLoading ? 0 : 1)
                .background {
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundStyle(Color.background)
                        .ignoresSafeArea(.container)
                }

                AddressSearchingLoadingView(isLoading: viewModel.isLoading)
                    .animation(.easeInOut(duration: 0.2), value: viewModel.isLoading)
                    .padding(.top, 20)
                    .scrollable()
                    .id(viewModel.isLoading ? "loading" : "")
                    .opacity(viewModel.isLoading ? 1 : 0)

                if !viewModel.isLoading && viewModel.addressList.isEmpty {
                    VStack {
                        Text("no.address.found".localize)
                            .font(.inter(.light, size: 14))
                            .foregroundStyle(Color.secondary)
                            .frame(height: 60)
                        Spacer()
                    }
                }
            }
        }
        .fullScreenCover(isPresented: $viewModel.showMap, content: {
            PickAddressMapView(viewModel: viewModel.mapModel)
        })
        .background {
            Rectangle()
                .ignoresSafeArea(.container)
                .foregroundStyle(Color.iBackground)
        }
    }

    private var fieldsView: some View {
        VStack(spacing: 10) {
            if viewModel.isFromVisible {
                fromFieldView.background(
                    RoundedRectangle(cornerRadius: 16)
                        .foregroundStyle(.iBackgroundSecondary)
                )
            }
            
            if viewModel.isToVisible {
                toFieldView.background(
                    RoundedRectangle(cornerRadius: 16)
                        .foregroundStyle(.iBackgroundSecondary)
                )
            }
        }
    }
    
    private var fromFieldView: some View {
        HStack(spacing: 8.scaled) {

            fieldLeftView(viewModel.isToVisible)
            
            YTextField(
                text: $viewModel.fromAddressText,
                placeholder: "from_location".localize,
                onCommit: {
                    print("onCommit")
                }
            )
            .focused($focusState, equals: .from)
            
            clearFieldButton(
                {
                    viewModel.clearFromAddress()
                },
                visible: !viewModel.fromAddressText.isEmpty
            )
            
            mapIconButton {
                self.viewModel.showFromAddressMapView()
            }
        }
        .padding([.leading], viewModel.isToVisible ? 16.scaled : 9.scaled)
        .padding([.trailing], 9.scaled)
        .frame(height: 60.scaled)
    }
    
    @ViewBuilder
    private func fieldLeftView(_ isCircle: Bool = true) -> some View {
        if isCircle {
            Circle()
                .frame(height: 8)
                .foregroundStyle(.iPrimary)
        } else {
            RoundedRectangle(cornerRadius: 11.scaled)
                .frame(width: 42.scaled, height: 42.scaled)
                .foregroundStyle(.iPrimary)
                .overlay {
                    Image("icon_flag")
                }
            
        }
    }

    private var toFieldView: some View {
        HStack(spacing: 8.scaled) {
            fieldLeftView(!viewModel.isToVisible)
            
            YTextField(
                text: $viewModel.toAddressText,
                placeholder: "where_to_go".localize,
                onCommit: {
                    print("onCommit")
                }
            )
            .focused($focusState, equals: .to)
            
            clearFieldButton(
                {
                    viewModel.clearToAddress()
                },
                visible: !viewModel.toAddressText.isEmpty
            )

            mapIconButton {
                self.viewModel.showToAddressMapView()
            }
        }
        .padding([.leading], !viewModel.isToVisible ? 16.scaled : 9.scaled)
        .padding([.trailing], 9.scaled)
        .frame(height: 60.scaled)
    }

    private func clearFieldButton(_ action: @escaping () -> Void, visible: Bool) -> some View {
        Button {
            action()
        } label: {
            RoundedRectangle(cornerRadius: 12)
                .foregroundStyle(Color.iBackgroundTertiary)
                .frame(width: 42.scaled, height: 42.scaled)
                .overlay {
                    Image("icon_close_rounded_fill")
                        .resizable()
                        .renderingMode(.template)
                        .foregroundStyle(Color.label)
                        .frame(width: 24.scaled, height: 24.scaled, alignment: .center)
                        .aspectRatio(contentMode: .fit)
                }
        }
        .foregroundColor(.iBackgroundSecondary)
        .visibility(visible)
    }
    
    private func mapIconButton(_ action: @escaping () -> Void) -> some View {
        Button(action: {
            action()
        }, label: {
            RoundedRectangle(cornerRadius: 12)
                .foregroundStyle(Color.iBackgroundTertiary)
                .frame(width: 42.scaled, height: 42.scaled)
                .overlay {
                    VStack {
                        Image("icon_location")
                            .resizable()
                            .renderingMode(.template)
                            .foregroundStyle(Color.label)
                            .frame(width: 24.scaled, height: 24.scaled, alignment: .center)
                            .aspectRatio(contentMode: .fit)
                    }
                }
        })
    }

    private func addressItem<Img: View>(image: Img, title: String, detail: String, distance: String) -> some View {
        HStack(spacing: 0) {
            if image is EmptyView {
                Image("icon_circle")
                    .resizable()
                    .renderingMode(.template)
                    .foregroundStyle(Color.gray)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 16, alignment: .center)
                    .padding([.vertical, .leading], AppParams.Padding.default)
                    .padding([.trailing], 8)
            } else {
                image
                    .padding([.vertical, .leading], AppParams.Padding.default)
                    .padding([.trailing], 8)
            }
            
            VStack(alignment: .leading, spacing: 1) {
                Text(title)
                    .font(.inter(.bold, size: 14))
                    .frame(height: 21)
                    .foregroundStyle(Color.label)
                
                if !detail.isEmpty {
                    Text(detail)
                        .font(.inter(.regular, size: 12))
                        .foregroundStyle(Color.secondary)
                        .frame(height: 16)
                }
            }
            
            Spacer()
            
            Text(distance)
                .font(.inter(.regular, size: 12))
                .foregroundStyle(Color.secondary)
                .frame(height: 16)
                .padding(.trailing, AppParams.Padding.default)
        }
    }
}

extension SelectAddressView {
    static var test: Self {
        SelectAddressView(
            viewModel: .init(
                fromLocation: .init(address: "from address", coordinate: .init(latitude: 0, longitude: 0)),
                toLocation: .init(address: "second address", coordinate: .init(latitude: 0, longitude: 0)),
                focusedField: .from
            )
        )
    }
}

#Preview {
    SelectAddressView(
        viewModel: .init(
            fromLocation: .init(address: "from address", coordinate: .init(latitude: 0, longitude: 0)),
            toLocation: .init(address: "second address", coordinate: .init(latitude: 0, longitude: 0)),
            focusedField: .from
        )
    )
}
