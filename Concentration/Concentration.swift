//
//  Concentration.swift
//  Concentration
//
//  Created by Jeremy Robinson on 9/14/18.
//  Copyright © 2018 Jeremy Robinson. All rights reserved.
//

import Foundation

struct Concentration {
    private(set) var cards = [Card]()
    
    private(set) var flipCount = 0
    
    private(set) var score = 0.0
    private(set) var timer = Date()
    
    private var indexOfOneAndOnlyFaceUpCard: Int? {
        get {
            return cards.indices.filter { cards[$0].isFaceUp}.oneAndOnly
        }
        set {
            for index in cards.indices {
                cards[index].isFaceUp = (index == newValue)
            }
        }
    }
    
    mutating func chooseCard(at index: Int) {
        assert(cards.indices.contains(index),"Concentration.chooseCard(at: \(index)): chosen index not in the cards")
        if !cards[index].isMatched {
            flipCount += 1
            if cards[index].seen == true {
                score += 1
            } else {
                cards[index].seen = true
            }
            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index {
                // check if cards match
                if cards[matchIndex] == cards[index] {
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                    let cardChosenTimer = Date.init()
                    let time = cardChosenTimer.timeIntervalSince(timer)
                    if time > 0 {
                        score -= (2.0 * (1.0+1.0/time)).truncate(to: 2)
                    } else  {
                        score -= (2.0).truncate(to: 2)
                    }
                    timer = Date.init()
                }
                cards[index].isFaceUp = true
            } else {
                indexOfOneAndOnlyFaceUpCard = index
            }
        }
    }
    
    init(NumberOfPairsOfCards: Int) {
        assert(NumberOfPairsOfCards > 0,"Concentration.init(\(NumberOfPairsOfCards)): must have at least one pair of cards")
        for _ in 1...NumberOfPairsOfCards {
            let card = Card()
            cards += [card,card]
        }
        //TODO: Shuffle Cards
        cards.shuffle()
    }
    
    mutating func newGame() {
        flipCount = 0
        score = 0
        for index in cards.indices {
            cards[index].isFaceUp = false
            cards[index].isMatched = false
            cards[index].seen = false
        }
        cards.shuffle()
        timer = Date.init()
    }
}

extension Array {
    mutating func shuffle() {
        for index in 0..<self.count {
            self.swapAt(index, self.count.arc4random)
        }
    }
}

extension Collection {
    var oneAndOnly: Element? {
        return count == 1 ? first : nil
    }
}
