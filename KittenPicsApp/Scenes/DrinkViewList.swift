import SwiftUI
struct  DrinkViewList: View {
    
    var onClose: () -> Void //Замыкание для возврата на главный экран
    
    @State private var selectedDrink: String = "Choose a drink"
    @State private var showConfirmation = false
    
    private let drinks = [
        "🥤 Coca-Cola", "🥤 Fanta", "🥤 Sprite", "🧃 Juice",
        "🧊 Iced Latte", "☕ Americano", "🍋 Espresso Tonic",
        "☕ Cappuccino", "🧋 Bubble Tea", "🍵 Matcha","🍵 Green Tea"
    ]

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.black, Color.indigo]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 18) {
                VStack(spacing: 8) {
                    Text("Your choice")
                        .font(.headline)
                        .foregroundColor(.white.opacity(0.8))
                    
                    Text(selectedDrink)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.purple.opacity(0.3))
                        )
                }
                .padding(.horizontal, 20)
                
                List(drinks, id: \.self) { drink in
                    Button(action: {
                        // При нажатии обновляем состояние
                        selectedDrink = drink
                        showConfirmation = true
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                            showConfirmation = false
                        }
                    }) {
                        HStack {
                            Text(drink)
                                .font(.title3)
                                .foregroundColor(drink == selectedDrink ? .purple : .primary)
                            
                            Spacer()
                            
                            if drink == selectedDrink {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                                    .font(.system(size: 24))
                            }
                        }
                        .padding(.vertical, 10)
                    }
                    .listRowBackground(
                        drink == selectedDrink
                        ? Color.blue.opacity(0.1)
                        : Color.clear
                    )
                }
                .listStyle(.insetGrouped)
                .frame(height: 480)
            }
            .navigationTitle("SwiftUI Table")
        }
    }
}


#Preview {
    DrinkViewList(onClose: {})
}

