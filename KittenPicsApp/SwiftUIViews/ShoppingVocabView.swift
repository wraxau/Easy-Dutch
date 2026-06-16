import SwiftUI

struct ShoppingVocabView: View {

    var onClose: () -> Void

    @State private var selectedPairID: UUID? = nil

    struct VocabPair: Identifiable {
        let id = UUID()
        let en: String
        let nl: String
    }

    let vocab: [VocabPair] = [
        VocabPair(en: "💰 How much does it cost?",      nl: "Hoeveel kost het?"),
        VocabPair(en: "💸 That is too expensive",       nl: "Dat is te duur"),
        VocabPair(en: "🏷 Is there a discount?",        nl: "Is er korting?"),
        VocabPair(en: "👀 I am just looking",           nl: "Ik kijk alleen"),
        VocabPair(en: "👕 Do you have size...?",        nl: "Heeft u maat...?"),
        VocabPair(en: "🪞 Can I try this on?",          nl: "Kan ik dit passen?"),
        VocabPair(en: "🚪 Where is the fitting room?",  nl: "Waar is de paskamer?"),
        VocabPair(en: "🛍 I would like to buy this",    nl: "Ik wil dit kopen"),
        VocabPair(en: "✅ I'll take it",                nl: "Ik neem het"),
        VocabPair(en: "💳 Can I pay by card?",          nl: "Kan ik pinnen?"),
        VocabPair(en: "💵 Can I pay by cash?",          nl: "Kan ik contant betalen?"),
        VocabPair(en: "🧾 Can I have a receipt?",       nl: "Mag ik een bon?"),
        VocabPair(en: "🔄 Can I exchange this?",        nl: "Kan ik dit omruilen?"),
        VocabPair(en: "❌ This is broken",              nl: "Dit is kapot"),
        VocabPair(en: "🙋 I need help",                nl: "Ik heb hulp nodig"),
        VocabPair(en: "🕐 What are your opening hours?",nl: "Wat zijn uw openingstijden?"),
        VocabPair(en: "🔍 I'm looking for...",          nl: "Ik zoek..."),
        VocabPair(en: "🏪 Where is the shop?",          nl: "Waar is de winkel?"),
        VocabPair(en: "🎁 It's a gift",                nl: "Het is een cadeau"),
        VocabPair(en: "📦 Do you have this in stock?",  nl: "Heeft u dit op voorraad?")
    ]

    var selectedPair: VocabPair? {
        guard let id = selectedPairID else { return nil }
        return vocab.first { $0.id == id }
    }

    var body: some View {
        VStack(spacing: 18) {
            VStack(spacing: 8) {
                Text("Your choice")
                    .font(.headline)
                    .foregroundColor(Color(.secondaryLabel))

                Text(selectedPair?.nl ?? "Choose a phrase")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.darkBlue)
                    .multilineTextAlignment(.center)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color(.secondarySystemBackground))
                    )
            }
            .padding(.horizontal, 20)

            List(vocab) { pair in
                Button(action: {
                    selectedPairID = pair.id
                }) {
                    HStack {
                        Text(pair.en)
                            .font(.title3)
                            .foregroundColor(.darkCyan)
                        Spacer()
                        if pair.id == selectedPairID {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.darkBlue)
                                .font(.system(size: 22))
                        }
                    }
                    .padding(.vertical, 10)
                }
                .listRowBackground(
                    pair.id == selectedPairID
                    ? Color.darkBlue.opacity(0.08)
                    : Color.clear
                )
            }
            .listStyle(.insetGrouped)
        }
        .navigationTitle("Shopping")
    }
}

#Preview {
    ShoppingVocabView(onClose: {})
}
