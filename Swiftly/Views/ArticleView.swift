import SwiftUI

struct Article: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let imageIndex: Int
    let content: String
}

struct Recipe: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let imageIndex: Int
    let duration: String
}

struct ArticleView: View {
    @Environment(\.colorScheme) var colorScheme

    @State private var selectedArticle: Article?
    @State private var showArticleDetail = false
    @State private var currentTab = 0

    let articles = [
        Article(
            title: "Could Gut Bacteria Help Lift Your Mood?",
            description: "New research suggests a strong connection between gut health and mental wellbeing",
            imageIndex: 1,
            content: """
            Recent studies have shown a fascinating connection between the bacteria in our gut and our mental health. Scientists have discovered that the microbiome plays a crucial role in producing neurotransmitters that affect mood and behavior.

            The gut-brain axis, a bidirectional communication system between the gastrointestinal tract and the central nervous system, has emerged as a key factor in understanding mental health. Research indicates that a diverse and healthy gut microbiome may help reduce anxiety and depression symptoms.

            Several ways to improve gut health include:
            • Eating a diverse range of foods
            • Including fermented foods in your diet
            • Limiting processed foods
            • Getting adequate sleep
            • Managing stress levels

            While more research is needed, these findings open new possibilities for mental health treatment approaches.
            """
        ),
        Article(
            title: "The Nervous System's Role in Gut Health",
            description: "Understanding how your nervous system affects digestive wellness",
            imageIndex: 2,
            content: """
            The enteric nervous system, often called our 'second brain', plays a crucial role in digestive health. This complex network of nerves throughout our digestive tract communicates constantly with our central nervous system, influencing everything from digestion to immune response.

            Research has revealed several key connections:
            • Stress directly impacts digestive function
            • Vagus nerve stimulation can improve gut health
            • Nervous system inflammation affects digestion
            • Gut motility depends on neural signals
            • Mind-body practices can support digestive wellness

            Understanding this connection has led to new therapeutic approaches for digestive disorders, combining traditional treatments with stress management techniques.
            """
        ),
        Article(
            title: "The Microbiome Universe",
            description: "A microscopic look at your gut's ecosystem",
            imageIndex: 3,
            content: """
            Within our digestive system lies a vast universe of microorganisms, forming complex communities that influence our overall health. Recent microscopic studies have revealed the intricate relationships between different bacterial species and their host environment.

            Important aspects of the gut microbiome:
            • Bacterial diversity is key to health
            • Microorganisms communicate with each other
            • Colony formation affects nutrient absorption
            • Immune system development depends on gut bacteria
            • Environmental factors influence microbiome balance

            Understanding these microscopic communities is leading to new treatments for various digestive disorders and metabolic conditions.
            """
        ),
        Article(
            title: "Brain-Gut Connection: A New Frontier",
            description: "Exploring how your brain and gut work together",
            imageIndex: 4,
            content: """
            Scientists are uncovering the remarkable ways our brain and gut communicate. This bidirectional relationship influences not just digestion, but also cognitive function, emotional well-being, and even decision-making processes.

            Key findings in brain-gut research:
            • Gut bacteria influence brain chemistry
            • Emotional stress can trigger digestive issues
            • Brain inflammation may start in the gut
            • Neurotransmitters are produced in the gut
            • Dietary changes can affect brain function

            This research is revolutionizing our approach to both mental health and digestive disorders, suggesting integrated treatment methods may be most effective.
            """
        ),
        Article(
            title: "Personalized Nutrition Through Gut Analysis",
            description: "How understanding your unique gut profile can guide dietary choices",
            imageIndex: 5,
            content: """
            Advanced analysis of gut bacteria is revolutionizing our approach to nutrition. By mapping individual microbiome patterns, scientists can now provide more personalized dietary recommendations for optimal health.

            Key developments in personalized nutrition:
            • Microbiome testing and analysis
            • Individual bacterial profile mapping
            • Custom probiotic formulations
            • Diet plans based on gut composition
            • Tracking gut health changes over time

            While this field is still evolving, it promises to transform how we approach diet and nutrition, moving away from one-size-fits-all recommendations to truly personalized approaches.
            """
        ),
    ]

    let recipes = [
        Recipe(title: "Confit Garlic Tomatoes", description: "Description 1", imageIndex: 1, duration: "20 min"),
        Recipe(title: "Cucumber Kimchi", description: "Description 3", imageIndex: 2, duration: "15 min"),
        Recipe(title: "Red Cabbage Kimchi", description: "Description 2", imageIndex: 3, duration: "10 min"),
    ]

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Featured")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .padding(.horizontal)

                    TabView(selection: $currentTab) {
                        ForEach(Array(articles.enumerated()), id: \.element.id) { index, article in
                            Image("article\(article.imageIndex)")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: UIScreen.main.bounds.width - 32, height: 200)
                                .overlay(
                                    VStack(alignment: .leading, spacing: 8) {
                                        Spacer()
                                        Text(article.title)
                                            .font(.headline)
                                            .foregroundColor(.white)
                                            .shadow(radius: 2)
                                            .lineLimit(1)

                                        Text(article.description)
                                            .font(.caption)
                                            .foregroundColor(.white)
                                            .shadow(radius: 2)
                                            .lineLimit(2)
                                    }
                                    .padding()
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(
                                        LinearGradient(
                                            gradient: Gradient(colors: [.clear, .black.opacity(0.7)]),
                                            startPoint: .top,
                                            endPoint: .bottom
                                        )
                                    ),
                                    alignment: .bottom
                                )
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                                .tag(index)
                                .onTapGesture {
                                    selectedArticle = article
                                    showArticleDetail = true
                                }
                        }
                    }
                    .frame(height: 200)
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                }

                VStack(alignment: .leading, spacing: 12) {
                    Text("Recipes")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .padding(.horizontal)

                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack(spacing: 16) {
                            ForEach(recipes) { recipe in
                                Image("recipe\(recipe.imageIndex)")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(
                                        width: 140,
                                        height: 180
                                    ).overlay(
                                        VStack(alignment: .leading, spacing: 8) {
                                            Text(recipe.title)
                                                .font(.headline)
                                                .foregroundColor(.white)
                                                .shadow(radius: 2)
                                                .lineLimit(3)

                                            Spacer()

                                            HStack(spacing: 4) {
                                                Image(systemName: "clock.fill")
                                                Text(recipe.duration)
                                            }
                                            .font(.subheadline)
                                            .fontWeight(.medium)
                                            .foregroundColor(.white.opacity(0.5))
                                            .padding(.horizontal, 8)
                                            .padding(.vertical, 4)
                                            .background(.thinMaterial)
                                            .environment(\.colorScheme, .dark)
                                            .clipShape(Capsule())
                                        }
                                        .padding()
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .background(
                                            LinearGradient(
                                                gradient: Gradient(colors: [.black.opacity(0.7), .clear]),
                                                startPoint: .top,
                                                endPoint: .bottom
                                            )
                                        )
                                    )
                                    .clipShape(RoundedRectangle(cornerRadius: 16))
                            }
                        }
                        .padding(.horizontal)
                    }
                }

                VStack(alignment: .leading, spacing: 12) {
                    Text("Popular")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .padding(.horizontal)

                    LazyVGrid(
                        columns: [GridItem(.flexible(), spacing: 16), GridItem(.flexible(), spacing: 16)],
                        spacing: 24
                    ) {
                        ForEach(articles.dropFirst(1)) { article in
                            VStack(alignment: .leading, spacing: 8) {
                                Image("article\(article.imageIndex)")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: (UIScreen.main.bounds.width - 48) / 2, height: 120)
                                    .clipShape(RoundedRectangle(cornerRadius: 16))

                                Text(article.title)
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                    .foregroundColor(.primary)
                                    .padding(.horizontal, 4)
                                    .lineLimit(2)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .frame(maxHeight: .infinity, alignment: .top)
        }
        .fullScreenCover(isPresented: $showArticleDetail) {
            ArticleDetailView()
        }
    }
}

struct ArticleDetailView: View {
    @Environment(\.dismiss) private var dismiss
    // let article: Article

    var body: some View {
        Text("Article Detail")
        Button("Done") {
            dismiss()
        }
    }
}

#Preview {
    ArticleView()
}
