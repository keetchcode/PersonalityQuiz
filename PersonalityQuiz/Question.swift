//
//  Question.swift
//  PersonalityQuiz
//
//  Created by Wesley Keetch on 10/8/24.
//

import Foundation


struct Question {
    var text: String
    var type: ResponseType
    var answers: [Answer]
}

enum ResponseType {
    case single, multiple, ranged
}

struct Answer {
    var text: String
    var type: AnimalType
}

enum AnimalType: Character {
    case LOTR = "💍", marvel = "💥", dune = "🏜️", starWars = "⭐️"

    var definition: String {
        switch self {
        case .LOTR:
            return "You are one of the homies. You possess a deep sense of adventure and loyalty, valuing friendship and the beauty of nature as you embark on epic quests."
        case .marvel:
            return "You are a dynamic force, embracing your individuality and creativity while standing up for what you believe in... is what I would say is marvel wasn't absolute 💩 besides select movies and shows. You are boring. "
        case .dune:
            return "You may enjoy genocide? Prophets, seers and revelators? You are a thinker and a visionary, drawn to complex narratives and the mysteries of the universe, always seeking deeper truths."
        case .starWars:
            return "Your opinions might be hit and miss but if you like Andor, Rogue One, Rebels, and Clone Wars then you know the goof stuff. You embody courage and wisdom, navigating challenges with a strategic mind and a strong moral compass, always ready to fight for justice."
        }
    }
}
