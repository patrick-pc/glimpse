import SwiftUI

public enum GarmentCategory: String, CaseIterable {
    case all = "🧺 all"
    case tops = "👚 tops"
    case bottoms = "👖 bottoms"
    case dresses = "👗 full-body"
}

struct GalleryView: View {
    @Environment(\.theme) var theme
    @State private var selectedCategory: GarmentCategory = .all

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text("Portraits")
                    .font(.title3)
                    .fontWeight(.medium)

                ModelGrid()

                VStack(alignment: .leading, spacing: 16) {
                    Text("Garments")
                        .font(.title3)
                        .fontWeight(.medium)

                    CategoryPills()
                }

                GarmentGrid()
            }
            .padding()
        }
    }

    private func ModelGrid() -> some View {
        let screenWidth = UIScreen.main.bounds.width
        let itemWidth = (screenWidth - 60) / 3 // 60 accounts for padding and spacing

        return ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 15) {
                ForEach(0 ..< 6, id: \.self) { _ in
                    ModelView(width: itemWidth)
                }
            }
        }
    }

    private func ModelView(width: CGFloat) -> some View {
        Image(systemName: "person.fill")
            .frame(width: width, height: width * 4 / 3)
            .foregroundStyle(theme.accentColor)
            .background(theme.fillColor)
            .cornerRadius(16)
    }

    private func CategoryPills() -> some View {
        SharedComponents.categoryPills(
            selectedCategory: $selectedCategory,
            categories: GarmentCategory.allCases
        )
    }

    private func GarmentGrid() -> some View {
        LazyVGrid(columns: [
            GridItem(.flexible(), spacing: 15),
            GridItem(.flexible(), spacing: 15),
            GridItem(.flexible(), spacing: 15),
        ], spacing: 15) {
            ForEach(0 ..< 6, id: \.self) { _ in
                GarmentView()
            }
        }
    }

    private func GarmentView() -> some View {
        Image(systemName: "tshirt.fill")
            .frame(width: (UIScreen.main.bounds.width - 60) / 3, height: (UIScreen.main.bounds.width - 60) / 3)
            .foregroundStyle(theme.accentColor)
            .background(theme.fillColor)
            .cornerRadius(16)
    }
}
