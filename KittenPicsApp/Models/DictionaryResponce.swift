import Foundation

struct DictionaryResponse: Codable {
    let word: String
    let phonetics: [Phonetic]
    let meanings: [Meaning]
    let origin: String?
    
    // Computed properties
    var pronunciation: String? {
        phonetics.first { $0.text != nil }?.text
    }
    
    var audioURL: URL? {
        phonetics
            .compactMap { $0.audio }
            .first { !$0.isEmpty }
            .flatMap { URL(string: $0) }
    }
    
    var firstDefinition: String? {
        meanings.first?.definitions.first?.definition
    }
    
    var exampleSentence: String? {
        meanings
            .flatMap { $0.definitions }
            .first { $0.example != nil }?.example
    }
    
    var partOfSpeech: String? {
        meanings.first?.partOfSpeech
    }
}

extension DictionaryResponse {
    struct Phonetic: Codable {
        let text: String?
        let audio: String?
        let sourceUrl: String?
        let license: License?
    }
    
    struct Meaning: Codable {
        let partOfSpeech: String
        let definitions: [Definition]
        let synonyms: [String]
        let antonyms: [String]
    }
    
    struct Definition: Codable {
        let definition: String
        let example: String?
        let synonyms: [String]?
        let antonyms: [String]?
    }
    
    struct License: Codable {
        let name: String
        let url: String
    }
}
