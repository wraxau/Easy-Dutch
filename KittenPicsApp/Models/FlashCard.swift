import Foundation

struct FlashCard {
    let english: String
    let dutch: String
    let imageSymbol: String?
    
    let pronunciation: String?
    let audioURL: String?
    let definition: String?
    let example: String?
    
    // MARK: - Init
    init(
        english: String,
        dutch: String,
        imageSymbol: String? = nil,
        pronunciation: String? = nil,
        audioURL: String? = nil,
        definition: String? = nil,
        example: String? = nil
    ) {
        self.english = english
        self.dutch = dutch
        self.imageSymbol = imageSymbol
        self.pronunciation = pronunciation
        self.audioURL = audioURL
        self.definition = definition
        self.example = example
    }
}

// MARK: - Sample Data

extension FlashCard {
    
    static let hobbies: [FlashCard] = [
        // Интеллект и творчество
        .init(english: "Reading", dutch: "Lezen", imageSymbol: "book.fill"),
        .init(english: "Writing", dutch: "Schrijven", imageSymbol: "pencil.and.scribble"),
        .init(english: "Drawing", dutch: "Tekenen", imageSymbol: "pencil"),
        .init(english: "Painting", dutch: "Schilderen", imageSymbol: "paintpalette"),
        .init(english: "Photography", dutch: "Fotografie", imageSymbol: "camera.fill"),
        
        // Музыка и развлечения
        .init(english: "Music", dutch: "Muziek", imageSymbol: "music.note.list"),
        .init(english: "Dancing", dutch: "Dansen", imageSymbol: "figure.dance"),
        .init(english: "Gaming", dutch: "Gamen", imageSymbol: "gamecontroller.fill"),
        .init(english: "Watching Movies", dutch: "Films kijken", imageSymbol: "film.fill"),
        
        // Спорт и активность
        .init(english: "Cycling", dutch: "Fietsen", imageSymbol: "bicycle"),
        .init(english: "Running", dutch: "Hardlopen", imageSymbol: "figure.run"),
        .init(english: "Swimming", dutch: "Zwemmen", imageSymbol: "figure.pool.swim"),
        .init(english: "Hiking", dutch: "Wandelen", imageSymbol: "figure.hiking"),
        .init(english: "Yoga", dutch: "Yoga", imageSymbol: "figure.mind.and.body"),
        
        // Дом и природа
        .init(english: "Cooking", dutch: "Koken", imageSymbol: "frying.pan"),
        .init(english: "Baking", dutch: "Bakken", imageSymbol: "cup.and.saucer.fill"),
        .init(english: "Gardening", dutch: "Tuinieren", imageSymbol: "tree"),
        .init(english: "Fishing", dutch: "Vissen", imageSymbol: "fish.fill"),
        .init(english: "Travel", dutch: "Reizen", imageSymbol: "airplane"),
        .init(english: "Bird Watching", dutch: "Vogels spotten", imageSymbol: "bird.fill")
    ]

    static let professions: [FlashCard] = [
        // Медицина
        .init(english: "Doctor", dutch: "Arts", imageSymbol: "cross.case.fill"),
        .init(english: "Nurse", dutch: "Verpleegkundige", imageSymbol: "stethoscope"),
        .init(english: "Dentist", dutch: "Tandarts", imageSymbol: "mouth.fill"),
        .init(english: "Pharmacist", dutch: "Apotheker", imageSymbol: "pill.fill"),
        .init(english: "Veterinarian", dutch: "Dierenarts", imageSymbol: "pawprint.fill"),

        // Образование и наука
        .init(english: "Teacher", dutch: "Leraar", imageSymbol: "person.fill.questionmark"),
        .init(english: "Professor", dutch: "Professor", imageSymbol: "graduationcap.fill"),
        .init(english: "Scientist", dutch: "Wetenschapper", imageSymbol: "flask.fill"),
        .init(english: "Researcher", dutch: "Onderzoeker", imageSymbol: "magnifyingglass"),

        // Технологии и дизайн
        .init(english: "Developer", dutch: "Ontwikkelaar", imageSymbol: "laptopcomputer"),
        .init(english: "Designer", dutch: "Ontwerper", imageSymbol: "paintbrush.pointed.fill"),
        .init(english: "Engineer", dutch: "Ingenieur", imageSymbol: "wrench.and.screwdriver.fill"),
        .init(english: "Architect", dutch: "Architect", imageSymbol: "building.columns.fill"),
        .init(english: "Photographer", dutch: "Fotograaf", imageSymbol: "camera.fill"),

        // Творчество и услуги
        .init(english: "Artist", dutch: "Kunstenaar", imageSymbol: "paintbrush.fill"),
        .init(english: "Musician", dutch: "Muzikant", imageSymbol: "music.mic"),
        .init(english: "Writer", dutch: "Schrijver", imageSymbol: "doc.text.fill"),
        .init(english: "Chef", dutch: "Kok", imageSymbol: "fork.knife"),
        .init(english: "Baker", dutch: "Bakker", imageSymbol: "birthday.cake.fill"),

        // Транспорт и право
        .init(english: "Pilot", dutch: "Piloot", imageSymbol: "airplane"),
        .init(english: "Driver", dutch: "Chauffeur", imageSymbol: "car.fill"),
        .init(english: "Lawyer", dutch: "Advocaat", imageSymbol: "books.vertical.fill"),
        .init(english: "Police Officer", dutch: "Politieagent", imageSymbol: "shield.fill"),
        .init(english: "Firefighter", dutch: "Brandweerman", imageSymbol: "flame.fill"),

        // Бизнес
        .init(english: "Manager", dutch: "Manager", imageSymbol: "briefcase.fill"),
        .init(english: "Accountant", dutch: "Boekhouder", imageSymbol: "chart.bar.fill"),
        .init(english: "Translator", dutch: "Vertaler", imageSymbol: "bubble.left.and.bubble.right.fill"),
        .init(english: "Journalist", dutch: "Journalist", imageSymbol: "newspaper.fill")
    ]
}

// MARK: - Конвертация из API

extension FlashCard {
    static func fromDictionaryEntry(_ entry: DictionaryResponse, englishWord: String) -> FlashCard {
        return FlashCard(
            english: englishWord,
            dutch: entry.word,
            imageSymbol: nil, 
            pronunciation: entry.pronunciation,
            audioURL: entry.audioURL?.absoluteString,
            definition: entry.firstDefinition,
            example: entry.exampleSentence
        )
    }
}
