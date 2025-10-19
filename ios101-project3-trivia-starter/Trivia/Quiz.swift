//
//  Quiz.swift
//  Trivia
//
//  Created by Armaan Tulsyani on 10/17/25.
//

import Foundation

struct Question {
    let category: String
    let prompt: String
    let answers: [String]         // exactly 4 items
    let correctIndex: Int         // 0...3
}

