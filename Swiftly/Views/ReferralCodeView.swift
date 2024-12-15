import SuperwallKit
import SwiftUI

struct ReferralCodeView: View {
    @Environment(\.theme) var theme
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var mainVM: MainViewModel

    @State private var referralCode: String = ""
    @FocusState private var isInputActive: Bool

    var onSuccess: () -> Void // Add callback for success

    var body: some View {
        ZStack {
            theme.backgroundColor.ignoresSafeArea(.all)

            VStack(spacing: 24) {
                Text("Have a Referral Code?")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .padding(.top, 24)

                Spacer()

                Button {
                    isInputActive = true
                } label: {
                    HStack(spacing: 16) {
                        ForEach(0 ..< 6) { index in
                            let char = index < referralCode.count ? String(Array(referralCode)[index]) : "__"
                            Text(char)
                                .font(.title)
                                .fontWeight(.bold)
                                .frame(minWidth: 32)
                                .multilineTextAlignment(.center)
                                .fixedSize()
                                .foregroundStyle(index < referralCode.count ? theme.primaryColor : theme.secondaryColor)
                        }
                    }
                    .padding(.horizontal, 24)
                }

                Spacer()

                SharedComponents.primaryButton(title: "Submit") {
                    // mainVM.applyReferralCode(referralCode)
                    dismiss()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                        Superwall.shared.register(event: "feature_locked")
                    }
                    onSuccess() // Call success callback after dismissing
                }
                .disabled(referralCode.count < 6)

                Button("Close") {
                    dismiss()
                }
                .font(.headline)
                .foregroundStyle(theme.secondaryColor)
                .padding(.bottom, 24)
            }
            .padding()
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                isInputActive = true
            }
        }
        .overlay {
            TextField("", text: $referralCode)
                .focused($isInputActive)
                .opacity(0)
                .textInputAutocapitalization(.characters)
                .keyboardType(.asciiCapable)
                .onChange(of: referralCode) { _, newValue in
                    if newValue.count > 6 {
                        referralCode = String(newValue.prefix(6))
                    }
                    referralCode = referralCode.uppercased()
                }
        }
    }
}
