import SwiftUI

struct NumbersVocabView: View {

    var onClose: () -> Void

    @State private var selectedPairID: UUID? = nil

    struct VocabPair: Identifiable {
        let id = UUID()
        let en: String
        let nl: String
    }

    let vocab: [VocabPair] = [
        VocabPair(en: "0️⃣  Zero",      nl: "Nul"),
        VocabPair(en: "1️⃣  One",       nl: "Één"),
        VocabPair(en: "2️⃣  Two",       nl: "Twee"),
        VocabPair(en: "3️⃣  Three",     nl: "Drie"),
        VocabPair(en: "4️⃣  Four",      nl: "Vier"),
        VocabPair(en: "5️⃣  Five",      nl: "Vijf"),
        VocabPair(en: "6️⃣  Six",       nl: "Zes"),
        VocabPair(en: "7️⃣  Seven",     nl: "Zeven"),
        VocabPair(en: "8️⃣  Eight",     nl: "Acht"),
        VocabPair(en: "9️⃣  Nine",      nl: "Negen"),
        VocabPair(en: "🔟  Ten",        nl: "Tien"),
        VocabPair(en: "🔢  Eleven",     nl: "Elf"),
        VocabPair(en: "🔢  Twelve",     nl: "Twaalf"),
        VocabPair(en: "🔢  Thirteen",   nl: "Dertien"),
        VocabPair(en: "🔢  Twenty",     nl: "Twintig"),
        VocabPair(en: "💯  Hundred",    nl: "Honderd"),
        VocabPair(en: "🔢  Thousand",   nl: "Duizend"),
        VocabPair(en: "🥇  First",      nl: "Eerste"),
        VocabPair(en: "🥈  Second",     nl: "Tweede"),
        VocabPair(en: "🥉  Third",      nl: "Derde")
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

                Text(selectedPair?.nl ?? "Choose a number")
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
        .navigationTitle("Numbers")
    }
}

#Preview {
    NumbersVocabView(onClose: {})
}
