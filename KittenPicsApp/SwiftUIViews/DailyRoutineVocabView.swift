import SwiftUI

struct DailyRoutineVocabView: View {

    var onClose: () -> Void

    @State private var selectedPairID: UUID? = nil

    struct VocabPair: Identifiable {
        let id = UUID()
        let en: String
        let nl: String
    }

    let vocab: [VocabPair] = [
        VocabPair(en: "⏰ I wake up",          nl: "Ik word wakker"),
        VocabPair(en: "🛏 I get up",            nl: "Ik sta op"),
        VocabPair(en: "🚿 I take a shower",     nl: "Ik neem een douche"),
        VocabPair(en: "🪥 I brush my teeth",    nl: "Ik poets mijn tanden"),
        VocabPair(en: "👗 I get dressed",       nl: "Ik kleed me aan"),
        VocabPair(en: "🍳 I eat breakfast",     nl: "Ik eet ontbijt"),
        VocabPair(en: "🚶 I go to work",        nl: "Ik ga naar het werk"),
        VocabPair(en: "🎒 I go to school",      nl: "Ik ga naar school"),
        VocabPair(en: "🥗 I have lunch",        nl: "Ik eet lunch"),
        VocabPair(en: "🏠 I come home",         nl: "Ik kom thuis"),
        VocabPair(en: "🍽 I cook dinner",       nl: "Ik kook avondeten"),
        VocabPair(en: "📺 I watch TV",          nl: "Ik kijk tv"),
        VocabPair(en: "📖 I read a book",       nl: "Ik lees een boek"),
        VocabPair(en: "🏃 I do sport",          nl: "Ik doe aan sport"),
        VocabPair(en: "🌳 I go for a walk",     nl: "Ik ga wandelen"),
        VocabPair(en: "🛒 I go shopping",       nl: "Ik ga winkelen"),
        VocabPair(en: "😴 I go to bed",         nl: "Ik ga naar bed"),
        VocabPair(en: "💤 I fall asleep",       nl: "Ik val in slaap"),
        VocabPair(en: "🕗 What time is it?",    nl: "Hoe laat is het?"),
        VocabPair(en: "🕗 It is 8 o'clock",     nl: "Het is 8 uur")
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
        .navigationTitle("Daily Routine")
    }
}

#Preview {
    DailyRoutineVocabView(onClose: {})
}
