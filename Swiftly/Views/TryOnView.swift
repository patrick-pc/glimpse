import SwiftUI

class TryOnViewModel: ObservableObject, ImageUploadable {
    @Published var showingImagePicker = false
    @Published var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @Published var selectedPortraitImage: UIImage? = UIImage(named: "portrait1")
    @Published var selectedGarmentImage: UIImage? = UIImage(named: "garment1")
    @Published var currentStep = 1
    @Published var selectedCategory: GarmentCategory = .tops

    let samplePortraits = ["portrait1", "portrait2"]
    let sampleGarments = ["garment1", "garment2"]
}

struct TryOnView: View {
    @Environment(\.theme) var theme
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel = TryOnViewModel()
    @State private var isButtonDisabled = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Main content
                ScrollView(showsIndicators: false) {
                    switch viewModel.currentStep {
                    case 1:
                        PortraitSelectionView
                    case 2:
                        GarmentSelectionView
                    case 3:
                        CategorySelectionView
                    default:
                        EmptyView()
                    }
                }
                .scrollDismissesKeyboard(.immediately)
                .scrollIndicators(.hidden)

                // Fixed button at bottom
                VStack {
                    SharedComponents.secondaryButton(title: buttonTitle) {
                        handleNextStep()
                    }
                    .opacity(isButtonDisabled ? 0.5 : 1)
                    .disabled(isButtonDisabled || !canProceed)
                }
                .padding(.horizontal)
                .padding(.top, 12)
                .padding(.bottom, 24)
                .contentShape(Rectangle())
            }
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.purple.opacity(0.2),
                        Color.indigo.opacity(0.1),
                        Color.clear,
                    ]),
                    startPoint: .bottom,
                    endPoint: .top
                )
            )
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: handleBack) {
                        Image(systemName: "arrow.left")
                            .font(.system(size: 10))
                            .fontWeight(.semibold)
                            .frame(width: 34, height: 34)
                            .foregroundStyle(theme.secondaryColor)
                            .background(theme.fillColor)
                            .cornerRadius(8)
                    }
                }

                ToolbarItem(placement: .principal) {
                    Text(navigationTitle)
                        .font(.headline)
                }
            }
            .sheet(isPresented: $viewModel.showingImagePicker) {
                ImagePicker(
                    selectedImage: viewModel.currentStep == 1
                        ? Binding(
                            get: { viewModel.selectedPortraitImage },
                            set: { viewModel.selectedPortraitImage = $0 }
                        )
                        : Binding(
                            get: { viewModel.selectedGarmentImage },
                            set: { viewModel.selectedGarmentImage = $0 }
                        ),
                    sourceType: viewModel.sourceType
                )
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    // MARK: - Computed Properties

    private var navigationTitle: String {
        switch viewModel.currentStep {
        case 1: return "Choose a portrait"
        case 2: return "Choose a garment"
        case 3: return "Choose a category"
        default: return ""
        }
    }

    private var buttonTitle: String {
        switch viewModel.currentStep {
        case 1, 2: return "Next"
        case 3: return "Try On"
        default: return ""
        }
    }

    private var canProceed: Bool {
        switch viewModel.currentStep {
        case 1: return viewModel.selectedPortraitImage != nil
        case 2: return viewModel.selectedGarmentImage != nil
        case 3: return true
        default: return false
        }
    }

    // MARK: - Methods

    private func handleNextStep() {
        if viewModel.currentStep == 3 {
            print("@@@ try on")
            return
        }
        viewModel.currentStep += 1
    }

    private func handleBack() {
        if viewModel.currentStep > 1 {
            viewModel.currentStep -= 1
        } else {
            dismiss()
        }
    }

    // MARK: - View Components

    private var PortraitSelectionView: some View {
        VStack(spacing: 24) {
            ZStack {
                Rectangle()
                    .fill(Color.white.opacity(0.3))
                    .frame(width: 168, height: 256)
                    .overlay(
                        VStack(spacing: 0) {
                            if let image = viewModel.selectedPortraitImage {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 144, height: 200)
                                    .clipped()
                            } else {
                                Image("portrait1")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 144, height: 200)
                                    .clipped()
                            }
                        }
                        .padding(.horizontal, 12)
                        .padding(.top, 12)
                        .padding(.bottom, 44)
                    )
                    .shadow(radius: 4)
            }

            VStack(alignment: .leading, spacing: 8) {
                Text("STEP 1")
                    .foregroundStyle(theme.secondaryColor)
                    .fontWeight(.medium)
                Text("Choose a clear photo of yourself with good lighting and straight posture. View Examples")
            }
            .font(.caption)
            .frame(maxWidth: .infinity, alignment: .leading)

            HStack(spacing: 16) {
                Button(action: { viewModel.checkCameraPermission() }) {
                    VStack(spacing: 8) {
                        Image(systemName: "camera.fill")
                        Text("Take Photo")
                    }
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 32)
                    .background(theme.mutedColor.opacity(0.3))
                    .foregroundStyle(theme.secondaryColor)
                    .cornerRadius(16)
                }

                Button(action: { viewModel.checkPhotoLibraryPermission() }) {
                    VStack(spacing: 8) {
                        Image(systemName: "photo.fill")
                        Text("Choose Photo")
                    }
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 32)
                    .background(theme.mutedColor.opacity(0.3))
                    .foregroundStyle(theme.secondaryColor)
                    .cornerRadius(16)
                }
            }

            VStack(alignment: .leading, spacing: 12) {
                Text("Recent portraits")
                    .font(.caption)
                    .frame(maxWidth: .infinity, alignment: .leading)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 15) {
                        ForEach(viewModel.samplePortraits, id: \.self) { imageName in
                            let width = (UIScreen.main.bounds.width - 60) / 3
                            Image(imageName)
                                .resizable()
                                .scaledToFill()
                                .frame(width: width, height: width * 4 / 3)
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                                .onTapGesture {
                                    viewModel.selectedPortraitImage = UIImage(named: imageName)
                                }
                        }
                    }
                }
            }
        }
        .padding()
    }

    private var GarmentSelectionView: some View {
        VStack(spacing: 24) {
            ZStack {
                Rectangle()
                    .fill(Color.white.opacity(0.3))
                    .frame(width: 168, height: 256)
                    .overlay(
                        VStack(spacing: 0) {
                            if let garmentImage = viewModel.selectedGarmentImage {
                                Image(uiImage: garmentImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 144, height: 200)
                                    .clipped()
                            } else {
                                Image("garment1")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 144, height: 200)
                                    .clipped()
                            }
                        }
                        .padding(.horizontal, 12)
                        .padding(.top, 12)
                        .padding(.bottom, 44)
                    )
                    .shadow(radius: 4)
            }

            VStack(alignment: .leading, spacing: 8) {
                Text("STEP 2")
                    .foregroundStyle(theme.secondaryColor)
                    .fontWeight(.medium)
                Text("Choose a clear photo of the garment you'd like to try on. View Examples")
            }
            .font(.caption)
            .frame(maxWidth: .infinity, alignment: .leading)

            HStack(spacing: 16) {
                Button(action: { viewModel.checkCameraPermission() }) {
                    VStack(spacing: 8) {
                        Image(systemName: "camera.fill")
                        Text("Take Photo")
                    }
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 32)
                    .background(theme.mutedColor.opacity(0.3))
                    .foregroundStyle(theme.secondaryColor)
                    .cornerRadius(16)
                }

                Button(action: { viewModel.checkPhotoLibraryPermission() }) {
                    VStack(spacing: 8) {
                        Image(systemName: "photo.fill")
                        Text("Choose Photo")
                    }
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 32)
                    .background(theme.mutedColor.opacity(0.3))
                    .foregroundStyle(theme.secondaryColor)
                    .cornerRadius(16)
                }
            }

            VStack(alignment: .leading, spacing: 12) {
                Text("Recent garments")
                    .font(.caption)
                    .frame(maxWidth: .infinity, alignment: .leading)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 15) {
                        ForEach(viewModel.sampleGarments, id: \.self) { garment in
                            let width = (UIScreen.main.bounds.width - 60) / 3
                            Image(garment)
                                .resizable()
                                .scaledToFill()
                                .frame(width: width, height: width * 4 / 3)
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                                .onTapGesture {
                                    viewModel.selectedGarmentImage = UIImage(named: garment)
                                }
                        }
                    }
                }
            }
        }
        .padding()
    }

    private var CategorySelectionView: some View {
        VStack(spacing: 24) {
            ZStack {
                // Selected portrait
                if let image = viewModel.selectedPortraitImage {
                    Rectangle()
                        .fill(Color.white.opacity(0.5))
                        .frame(width: 168, height: 256)
                        .overlay(
                            VStack(spacing: 0) {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 144, height: 200)
                                    .clipped()
                            }
                            .padding(.horizontal, 12)
                            .padding(.top, 12)
                            .padding(.bottom, 44)
                        )
                        .shadow(radius: 4)
                        .rotationEffect(.degrees(-8))
                        .offset(x: -60, y: 0)
                }

                // Selected garment
                if let garmentImage = viewModel.selectedGarmentImage {
                    Rectangle()
                        .fill(Color.white.opacity(0.5))
                        .frame(width: 168, height: 256)
                        .overlay(
                            VStack(spacing: 0) {
                                Image(uiImage: garmentImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 144, height: 200)
                                    .clipped()
                            }
                            .padding(.horizontal, 12)
                            .padding(.top, 12)
                            .padding(.bottom, 44)
                        )
                        .shadow(radius: 4)
                        .rotationEffect(.degrees(8))
                        .offset(x: 60, y: 40)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.top, 40)
            .padding(.bottom, 60)
            .padding(.horizontal)

            VStack(alignment: .leading, spacing: 8) {
                Text("STEP 3")
                    .foregroundStyle(theme.secondaryColor)
                    .fontWeight(.medium)
                Text("Choose the category that best matches your garment.")
            }
            .font(.caption)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)

            SharedComponents.categoryPills(
                selectedCategory: $viewModel.selectedCategory,
                categories: GarmentCategory.allCases.filter { $0 != .all }
            )
            .padding(.horizontal)

            Spacer()
        }
    }
}
