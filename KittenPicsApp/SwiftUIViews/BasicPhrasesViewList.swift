import SwiftUI

struct BasicPhrasesViewList: View {
    
    var onClose: () -> Void // Замыкание для возврата на главный экран
    
    @State private var selectedPairID: UUID? = nil
    
    struct PhrasePair: Identifiable {
        let id = UUID()
        let en: String
        let nl: String
    }
    
    let travelPhrasesEnNl: [PhrasePair] = [
        PhrasePair(en: "👋 Hello", nl: "Hallo"),
        PhrasePair(en: "👋 Good morning", nl: "Goedemorgen"),
        PhrasePair(en: "👋 Good evening", nl: "Goedenavond"),
        PhrasePair(en: "🙏 Please", nl: "Alstublieft"),
        PhrasePair(en: "🙏 Thank you", nl: "Dank u wel"),
        PhrasePair(en: "🙏 You're welcome", nl: "Graag gedaan"),
        PhrasePair(en: "❓ Where is the toilet?", nl: "Waar is het toilet?"),
        PhrasePair(en: "❓ Where is the hotel?", nl: "Waar is het hotel?"),
        PhrasePair(en: "❓ How can I get to the train station?", nl: "Hoe kom ik bij het treinstation?"),
        PhrasePair(en: "❓ How can I get to...?", nl: "Hoe kom ik bij...?"),
        PhrasePair(en: "❓ How much does it cost?", nl: "Hoeveel kost het?"),
        PhrasePair(en: "❓ Do you speak English?", nl: "Spreekt u Engels?"),
        PhrasePair(en: "🍽️ Could I have the menu, please?", nl: "Mag ik het menu, alstublieft?"),
        PhrasePair(en: "☕ Coffee, please", nl: "Koffie, alstublieft"),
        PhrasePair(en: "💳 Can I pay by card?", nl: "Kan ik pinnen?"),
        PhrasePair(en: "💶 Can I pay by cash?", nl: "Kan ik contant betalen?"),
        PhrasePair(en: "🧾 The bill, please", nl: "De rekening, alstublieft"),
        PhrasePair(en: "🚕 Can you call a taxi?", nl: "Kunt u een taxi bellen?"),
        PhrasePair(en: "🚆 Where is the train station?", nl: "Waar is het treinstation?"),
        PhrasePair(en: "🚌 Where is the bus stop?", nl: "Waar is de bushalte?"),
        PhrasePair(en: "🏨 Where is the hotel?", nl: "Waar is het hotel?"),
        PhrasePair(en: "🆘 Can you help me?", nl: "Kunt u mij helpen?"),
        PhrasePair(en: "🏥 I need a doctor", nl: "Ik heb een arts nodig"),
        PhrasePair(en: "💊 Where is the pharmacy?", nl: "Waar is de apotheek?"),
        PhrasePair(en: "🚫 No", nl: "Nee"),
        PhrasePair(en: "✅ Yes", nl: "Ja"),
        PhrasePair(en: "🤷 I don't understand", nl: "Ik begrijp het niet")
    ]
    
    var selectedPair: PhrasePair? {
        guard let id = selectedPairID else { return nil }
        return travelPhrasesEnNl.first { $0.id == id }
    }
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.ligthLemon, Color.darkCyan]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 18) {
                VStack(spacing: 8) {
                    Text("Your choice")
                        .font(.headline)
                        .foregroundColor(.darkCyan.opacity(0.5))
                    
                    Text(selectedPair?.nl ?? "Choose a phrase")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.darkCyan)
                        .multilineTextAlignment(.center)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.ligthLemon.opacity(0.3))
                        )
                }
                .padding(.horizontal, 20)
                
                List(travelPhrasesEnNl) { pair in
                    Button(action: {
                        selectedPairID = pair.id
                    }) {
                        HStack {
                            Text(pair.en)
                                .font(.title3)
                                .foregroundColor(pair.id == selectedPairID ? .ligthLemon : .darkCyan)
                            Spacer()
                            if pair.id == selectedPairID {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.ligthLemon)
                                    .font(.system(size: 24))
                            }
                        }
                        .padding(.vertical, 10)
                    }
                    .listRowBackground(
                        pair.id == selectedPairID
                        ? Color.darkCyan.opacity(0.6)
                        : Color.clear
                    )
                }
                .listStyle(.insetGrouped)
            }
            .navigationTitle("Useful phrases in Dutch")
        }
    }
}

#Preview {
    BasicPhrasesViewList(onClose: {})
}
