import SwiftUI

struct ColorsVocabView: View {

    var onClose: () -> Void

    @State private var selectedPairID: UUID? = nil

    struct VocabPair: Identifiable {
        let id = UUID()
        let en: String
        let nl: String
    }

    let vocab: [VocabPair] = [
        VocabPair(en: "🔴 Red",        nl: "Rood"),
        VocabPair(en: "🔵 Blue",       nl: "Blauw"),
        VocabPair(en: "🟢 Green",      nl: "Groen"),
        VocabPair(en: "🟡 Yellow",     nl: "Geel"),
        VocabPair(en: "🟠 Orange",     nl: "Oranje"),
        VocabPair(en: "🟣 Purple",     nl: "Paars"),
        VocabPair(en: "🩷 Pink",       nl: "Roze"),
        VocabPair(en: "⚫ Black",      nl: "Zwart"),
        VocabPair(en: "⚪ White",      nl: "Wit"),
        VocabPair(en: "🟤 Brown",      nl: "Bruin"),
        VocabPair(en: "🩶 Gray",       nl: "Grijs"),
        VocabPair(en: "🩵 Light blue", nl: "Lichtblauw"),
        VocabPair(en: "🔷 Dark blue",  nl: "Donkerblauw"),
        VocabPair(en: "🫐 Turquoise",  nl: "Turquoise"),
        VocabPair(en: "🟩 Light green",nl: "Lichtgroen"),
        VocabPair(en: "🌿 Dark green", nl: "Donkergroen"),
        VocabPair(en: "🌾 Beige",      nl: "Beige"),
        VocabPair(en: "❤️‍🔥 Dark red",  nl: "Donkerrood")
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

                Text(selectedPair?.nl ?? "Choose a color")
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
        .navigationTitle("Colors")
    }
}

#Preview {
    ColorsVocabView(onClose: {})
}
