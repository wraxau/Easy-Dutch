import SwiftUI

struct AnimalsPickerView: View {
    
    // MARK: Constants
    
    // Замыкание для возврата в первый экран
    var onClose: () -> Void
    @State private var currentIndex = 0
    @State private var showingDutch = false
    
    private let animalsImages = ["animals", "bear", "bunny","cat", "cheetah", "cow", "deer", "dog", "donkey", "duck","fox","giraffe","goat","guineaPig", "hamster", "hourse", "lama", "leo", "lynx", "otter", "owl", "parrot", "pelican", "pinguin", "rabbit", "redPanda", "sheep", "snowLeo", "tiger", "zebra"]
    
    // MARK: Properties
    
    private var englishTitle: String {
        switch currentIndex{
        case 1:
            return "Bear"
        case 2:
            return "Bunny"
        case 3:
            return "Cat"
        case 4:
            return "Cheetah"
        case 5:
            return "Cow"
        case 6:
            return "Deer"
        case 7:
            return "Dog"
        case 8:
            return "Donkey"
        case 9:
            return "Duck"
        case 10:
            return "Fox"
        case 11:
            return "Giraffe"
        case 12:
            return "Goat"
        case 13:
            return "Guinea Pig"
        case 14:
            return "Hamster"
        case 15:
            return "Hourse"
        case 16:
            return "Lama"
        case 17:
            return "Leo"
        case 18:
            return "Lynx"
        case 19:
            return "Otter"
        case 20:
            return "Owl"
        case 21:
            return "Parrot"
        case 22:
            return "Pelican"
        case 23:
            return "Pinguin"
        case 24:
            return "Rabbit"
        case 25:
            return "Red panda"
        case 26:
            return "Sheep"
        case 27:
            return "Snow leopard"
        case 28:
            return "Tiger"
        case 29:
            return "Zebra"
        default:
            return "Let's learn animals in Dutch"
            
        }
    }
    
    private var dutchTitle: String {
        switch currentIndex {
        case 1:
            return "Beer"
        case 2:
            return "Konijntje"
        case 3:
            return "Kat"
        case 4:
            return "Cheetah" // или "Jachtluipaard"
        case 5:
            return "Koe"
        case 6:
            return "Hert"
        case 7:
            return "Hond"
        case 8:
            return "Ezel"
        case 9:
            return "Eend"
        case 10:
            return "Vos"
        case 11:
            return "Giraf"
        case 12:
            return "Geit"
        case 13:
            return "Cavia"
        case 14:
            return "Hamster"
        case 15:
            return "Paard"
        case 16:
            return "Lama"
        case 17:
            return "Leeuw"
        case 18:
            return "Lynx"
        case 19:
            return "Otter"
        case 20:
            return "Uil"
        case 21:
            return "Papegaai"
        case 22:
            return "Pelikaan"
        case 23:
            return "Pinguïn"
        case 24:
            return "Konijn"
        case 25:
            return "Rode panda"
        case 26:
            return "Schaap"
        case 27:
            return "Sneeuwluipaard"
        case 28:
            return "Tijger"
        case 29:
            return "Zebra"
        default:
            return "Let's learn animals in Dutch"
        }
    }
    
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.ligthLemon, Color.darkCyan]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 20) {
                if showingDutch == false {
                    Text(englishTitle)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundStyle(Color.darkBlue)
                        .multilineTextAlignment(.center)
                } else {
                    Text(dutchTitle)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundStyle(Color.brightOrange)
                        .multilineTextAlignment(.center)
                }
                Image(animalsImages[currentIndex])
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 300, height: 400)
                    .clipped()
                    .cornerRadius(20)
                    .shadow(radius: 10)
                
                HStack(spacing: 60) {
                    Button {
                        showingDutch = false
                        currentIndex = (currentIndex - 1 + animalsImages.count) % animalsImages.count
                    } label: {
                        HStack(spacing: 8) {
                            Image(systemName: "arrow.left")
                            Text("Back")
                        }
                        .padding(.horizontal, 30)
                        .padding(.vertical, 14)
                        .background(Color.ligthLemon)
                        .foregroundColor(.darkBlue)
                        .cornerRadius(20)
                    }
                    .opacity(currentIndex == currentIndex - 1 ? 0.5 : 1.0)
                    
                    Button {
                        showingDutch = false
                        currentIndex = (currentIndex + 1) % animalsImages.count
                    } label: {
                        HStack(spacing: 8) {
                            Text("Next")
                            Image(systemName: "arrow.right")
                        }
                        .padding(.horizontal, 30)
                        .padding(.vertical, 14)
                        .background(Color.ligthLemon)
                        .foregroundColor(.darkBlue)
                        .cornerRadius(20)
                    }
                }
                
                Button {
                    showingDutch = true
                } label: {
                    HStack(spacing: 8) {
                        Text("Answer")
                    }
                    .padding(.horizontal, 30)
                    .padding(.vertical, 14)
                    .background(Color.ligthLemon)
                    .foregroundColor(.darkBlue)
                    .cornerRadius(20)
                }
            }
        }
    }
}

#Preview {
    AnimalsPickerView(onClose: {
    })
    .preferredColorScheme(.dark)
}
