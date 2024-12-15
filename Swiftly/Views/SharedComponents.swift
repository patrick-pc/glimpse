import Foundation
import SwiftUI

enum SharedComponents {
    struct Card<Content: View>: View {
        let content: () -> Content
        @Environment(\.theme) var theme

        var body: some View {
            content()
                .padding(16)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(theme.fillColor)
                .cornerRadius(16)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(theme.mutedColor, lineWidth: 1)
                )
                .foregroundStyle(theme.primaryColor)
        }
    }

    struct TitleWithDivider: View {
        let text: String
        let color: Color
        @Environment(\.theme) var theme

        var body: some View {
            HStack(alignment: .center, spacing: 20) {
                Text(text)
                    .font(.headline)
                    .foregroundColor(color)

                Rectangle()
                    .fill(theme.mutedColor)
                    .frame(height: 1)
            }
        }
    }

    struct PrimaryButton: View {
        let title: String
        let action: () -> Void
        @Environment(\.theme) var theme

        var body: some View {
            Button(action: action) {
                Text(title)
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
                    .background(theme.primaryColor)
                    .foregroundStyle(theme.backgroundColor)
                    .clipShape(Capsule())
            }
        }
    }

    struct SecondaryButton: View {
        let title: String
        let action: () -> Void
        @Environment(\.theme) var theme

        var body: some View {
            Button(action: action) {
                Text(title)
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
                    .background(
                        Image("bg")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    )
                    .clipShape(Capsule())
            }
        }
    }

    struct CategoryPills: View {
        @Environment(\.theme) var theme
        @Binding var selectedCategory: GarmentCategory
        let categories: [GarmentCategory]

        var body: some View {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(categories, id: \.self) { category in
                        Button(action: {
                            selectedCategory = category
                        }) {
                            Text(category.rawValue)
                                .font(.caption)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .foregroundStyle(selectedCategory == category ? theme.primaryColor : theme.secondaryColor)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(theme.mutedColor, lineWidth: 2)
                                )
                        }
                        .background(selectedCategory == category ? theme.fillColor : theme.backgroundColor)
                        .cornerRadius(16)
                    }
                }
            }
        }
    }

    // Static functions with explicit returns
    static func card<Content: View>(@ViewBuilder content: @escaping () -> Content) -> some View {
        return Card(content: content)
    }

    static func titleWithDivider(_ text: String, color: Color = .primary) -> some View {
        return TitleWithDivider(text: text, color: color)
    }

    static func primaryButton(title: String, action: @escaping () -> Void) -> some View {
        return PrimaryButton(title: title, action: action)
    }

    static func secondaryButton(title: String, action: @escaping () -> Void) -> some View {
        return SecondaryButton(title: title, action: action)
    }

    static func categoryPills(selectedCategory: Binding<GarmentCategory>, categories: [GarmentCategory]) -> some View {
        return CategoryPills(selectedCategory: selectedCategory, categories: categories)
    }
}

extension View {
    func keyboardAvoiding() -> some View {
        modifier(KeyboardAvoidingModifier())
    }
}

struct KeyboardAvoidingModifier: ViewModifier {
    @State private var keyboardHeight: CGFloat = 0

    func body(content: Content) -> some View {
        content
            .padding(.bottom, keyboardHeight)
            .onAppear {
                NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { notification in
                    let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect ?? .zero
                    keyboardHeight = keyboardFrame.height
                }

                NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { _ in
                    keyboardHeight = 0
                }
            }
    }
}
