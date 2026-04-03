import Foundation
import AVFoundation

final class SpeechService {
    
    // MARK: - Proprties
    
    static let shared = SpeechService()
    private let syntezer = AVSpeechSynthesizer()
    
    // MARK: - Methods
    
    // Метод для озвучивания текста на выбранном языке.
    // text - текст для озвучки, language - язык, rate - скорость озвучки
    func speak(text: String, language: String, rate: Float = 0.5) {
        
        stop() // останавливаем предыдущую озвучку(если есть)
        
        // создание фразы для озвучки
        let utterance = AVSpeechUtterance(string: text)
        
        // настройка голоса
        utterance.voice = AVSpeechSynthesisVoice(language: language)
        
        // скорость
        utterance.rate = rate
        
        // настройка тона
        utterance.pitchMultiplier = 1.0
        
        //настройка громкости
        utterance.volume = 1.0
        
        syntezer.speak(utterance)
    }
    
    // остановить озвучку
    func stop() {
        if syntezer.isSpeaking {
            syntezer.stopSpeaking(at: .immediate)
        }
    }
    
    // поставить озвучку на паузу
    func paused() {
        if syntezer.isSpeaking {
            syntezer.pauseSpeaking(at: .immediate)
        }
    }
    
    // продолжить после паузы
    func resume() {
        if syntezer.isPaused {
            syntezer.continueSpeaking()
        }
    }
    
    // проверить, идет ли сейчас озвучка
    func isSpeaking() -> Bool {
        return syntezer.isSpeaking
    }
    
    // получить список доступных голосов для языка
    func getAvailableVoices(for language: String) -> [AVSpeechSynthesisVoice] {
        return AVSpeechSynthesisVoice.speechVoices() .filter { $0.language.hasPrefix(language) }
        }
    
    
}
