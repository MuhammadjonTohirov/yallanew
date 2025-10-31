//
//  AddCardView.swift
//  Ildam
//
//  Created by Sardorbek Saydamatov on 22/11/24.
//

import SwiftUI
import YallaUtils
import YallaKit

struct AddCardView: View {
    @StateObject private var viewModel: AddCardViewModel = .init()
    @Environment(\.dismiss) private var dismiss
    @FocusState private var isCardFieldFocused: Bool
    
    var body: some View {
        VStack {
            innerBody
                .padding(.horizontal)
            
            if viewModel.isLoading {
                ProgressView()
            }
            
            Spacer()
            
            SubmitButtonFactory.primary(title: "add.card".localize) {
                viewModel.addCardService(
                    cardNumber: viewModel.cardNumber,
                    expiry: viewModel.expirationDate
                )
            }
            .set(isLoading: viewModel.isLoading)
            .set(isEnabled: viewModel.cardNumber.count == 19 && viewModel.expirationDate.count == 5)
            .padding()
        }
        .sheet(isPresented: $viewModel.shouldShowOTPView) {
            NavigationStack {
                SecurityCodeInputView(viewModel: viewModel.otpModel)
            }
            .onDisappear {
                if viewModel.shouldDismiss {
                    dismiss()
                }
            }
            .bottomMaskForSheet()
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("new.card".localize)
        .onAppear {
            isCardFieldFocused = true
        }
    }
    
    private var innerBody: some View {
        VStack(spacing: 16.scaled) {
            YRoundedTextField {
                YTextField(text: $viewModel.cardNumber, placeholder: "card.number".localize, right: {
                    Button {
                        viewModel.onClickScanCard()
                    } label: {
                        Image("icon_scan")
                            .resizable()
                            .renderingMode(.template)
                            .foregroundStyle(.primary)
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 24, height: 24)
                    }
                    .alert(isPresented: $viewModel.showAlert) {
                        Alert(
                            title: Text("permission.required".localize),
                            message: Text(viewModel.alertMessage),
                            primaryButton: .default(Text("go.to.settings".localize), action: viewModel.alertAction),
                            secondaryButton: .cancel(Text("cancel".localize))
                        )
                    }
                    .fullScreenCover(isPresented: $viewModel.showScanner) {
                        scanCardView
                    }
                })
                .keyboardType(.numberPad)
                .set(format: "XXXX XXXX XXXX XXXX")
                .focused($isCardFieldFocused)
                .padding(.horizontal)
                .frame(height: 50)
            }
            .set(borderColor: .iBorderDisabled)
            .padding(.top)
            
            YRoundedTextField {
                YTextField(text: $viewModel.expirationDate,
                           placeholder: "MM/YY",
                           validator: .init(filter: { text in
                    let isInDateFormat = text.count == 5 && text.contains("/")
                    let isValidMonth = text.prefix(2).asString.isInt && text.prefix(2).asString.asInt <= 12
                    
                    if isInDateFormat, isValidMonth, let date = Date.from(string: text, format: "MM/yy") {
                        return date > Date()
                    }
                    
                    return isValidMonth
                }))
                .set(format: "XX/XX")
                .keyboardType(.numberPad)
                .frame(height: 50)
                .padding(.leading)
            }
            .set(borderColor: .iBorderDisabled)
            .padding(.bottom)
        }
        .frame(maxWidth: .infinity)
    }
    
    @ViewBuilder var scanCardView: some View {
        CardReaderWrapper { cardNumber, expirationDate in
            self.viewModel.cardNumber = cardNumber
            self.viewModel.expirationDate = expirationDate
        }
        .ignoresSafeArea(.all)
    }
}

#Preview {
    NavigationStack {
        AddCardView()
    }
}
