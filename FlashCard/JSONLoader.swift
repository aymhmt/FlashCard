//
//  JSONLoader.swift
//  FlashCard
//
//  Created by mami on 23.11.2024.
//

import Foundation

func loadFlashCards(from fileName: String) -> [FlashCard] {
    guard let url = Bundle.main.url(forResource: fileName, withExtension: "json") else {
        print("JSON file not found")
        return []
    }
    do {
        let data = try Data(contentsOf: url)
        let cards = try JSONDecoder().decode([FlashCard].self, from: data)
        return cards
    } catch {
        print("Error decoding JSON: \(error)")
        return []
    }
}
