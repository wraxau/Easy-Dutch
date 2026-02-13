import SwiftUI

struct DogsPickerViewController: View {
    
    // MARK: Constants
    
    // Замыкание для возврата в первый экран
    var onClose: () -> Void
   // var onClose: () -> Void
    @State private var currentIndex = 0
    
    private let dogsImages = ["dog1", "dog2", "dog3", "dog4", "dog5", "dog6","dog7","dog8","dog9","dog10"]
    
    // MARK: Properties
    
    // вычисляемое свойство: в зависимости от того, какой currentIndex - будет меняться надпись на экране
    
    private var currentTitle: String {
        switch currentIndex{
        case 0:
            return "The Golden retriever"
        case 1:
            return "The Bernese Mountain Dog"
        case 2:
            return "The Dwarf dachshund"
        case 3:
            return "The Dalmatian"
        case 4:
            return "The Dwarf dachshund"
        case 5:
            return "The West Highland White Terrier"
        case 6:
            return "The Zwergschnauzer"
        case 7:
            return "The King Charles Spaniel"
        case 8:
            return "The Doberman"
        case 9:
            return "The Dwarf dachshund"
        default:
            return "Cool dog!"
            
        }
    }
    
    var body: some View {
        ZStack { // для слоев
            // первый слой - фон
            LinearGradient(
                gradient: Gradient(colors: [Color.black, Color.indigo]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea() // во весь экран включая статус бар
            
            // Второй стой - Вертикальный стек(контейнер для элеемнтов)
            VStack(spacing: 20) {
                // Заголовок
                Text(currentTitle)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundStyle(.white) // цвет текста
                    .multilineTextAlignment(.center) // выравнивание по центру
                
                Image(dogsImages[currentIndex])
                    .resizable()
                    .aspectRatio(contentMode: .fill) // картинка заполнит весь квадрат
                    .frame(width: 300, height: 300)
                    .clipped()
                    .cornerRadius(20)
                    .shadow(radius: 10)
                
                // горизонтальный контйнер, чтобы разместить кнопки
                HStack(spacing: 60) {
                    Button {
                        currentIndex = (currentIndex - 1 + dogsImages.count) % dogsImages.count
                    } label: {
                        HStack(spacing: 8) {
                            Image(systemName: "arrow.left")
                            Text("Back")
                        }
                        .padding(.horizontal, 30)
                        .padding(.vertical, 14)
                        .background(Color.indigo) // сначала фон, потом скругление
                        .foregroundColor(.white) // цвет текста на кнопке
                        .cornerRadius(20)
                        
                        // .padding() - добавляет отступы вокруг контента, .frame() - фиксирует точный размер
                    }
                    .opacity(currentIndex == currentIndex - 1 ? 0.5 : 1.0)
                    
                    Button {
                        currentIndex = (currentIndex + 1) % dogsImages.count
                    } label: {
                        HStack(spacing: 8) {
                            Text("Next")
                            Image(systemName: "arrow.right")
                        }
                        .padding(.horizontal, 30)
                        .padding(.vertical, 14)
                        .background(Color.indigo)
                        .foregroundColor(.white)
                        .cornerRadius(20)
                    }
                }
                
            }
        }
    }
}

#Preview {
    DogsPickerViewController(onClose: {
    })
    .preferredColorScheme(.dark)
}
    
