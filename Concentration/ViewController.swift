//
//  ViewController.swift
//  Concentration
//
//  Created by Jeremy Robinson on 9/12/18.
//  Copyright © 2018 Jeremy Robinson. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    private lazy var game = Concentration(NumberOfPairsOfCards: numberOfPairsOfCards)
    
    var numberOfPairsOfCards: Int {
        return (cardButtons.count + 1) / 2
    }
    
    @IBOutlet private weak var flipCountLabel: UILabel!

    
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet private weak var newGameLabel: UIButton!
    @IBOutlet private var cardButtons: [UIButton]!
    @IBAction private func touchCard(_ sender: UIButton) {
        if let cardNumber = cardButtons.index(of: sender) {
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
        } else {
        print("Chosen card was not in CardButtons")
        }
    }
    
    
    @IBAction func newGameButton(_ sender: UIButton) {
        game.newGame()
        indexTheme = keys.count.arc4random
        updateViewFromModel()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        indexTheme = keys.count.arc4random
        updateViewFromModel()
    }
    
    private func updateViewFromModel() {
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.cards[index]
            if card.isFaceUp {
                button.setTitle(emoji(for: card), for: .normal)
                button.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            } else {
                button.setTitle("", for: .normal)
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 0) : cardBackColor
            }
        }
        scoreLabel.text = "Score: \(game.score.truncate(to: 2))"
        flipCountLabel.text = "Flips: \(game.flipCount)"
    }
    
    private typealias theme = (emojiChoices: [String], backgroundColor: UIColor, cardBackColor: UIColor)
    
    private var emojiThemes: [String: theme] = [
    "Halloween":(["🦇","😱","🙀","😈","🎃","👻","🍭","🍬","🍎","💀"],#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1),#colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 1)),
    "Animals":(["🦓","🦍","🦒","🐅","🐫","🦏","🐘","🐕","🐈","🐄"],#colorLiteral(red: 0, green: 0.5628422499, blue: 0.3188166618, alpha: 1),#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)),
    "Travel":(["🚒","🚓","🚑","🚗","🚕","🚌","🚚","🏍","✈️","🚤"],#colorLiteral(red: 0.5741485357, green: 0.5741624236, blue: 0.574154973, alpha: 1),#colorLiteral(red: 0.9994240403, green: 0.9855536819, blue: 0, alpha: 1)),
    "Ocean":(["🐋","🐙","🐬","🦀","🦈","🦑","🐠","🐡","🦐","🐟"],#colorLiteral(red: 0.4620226622, green: 0.8382837176, blue: 1, alpha: 1),#colorLiteral(red: 0.4500938654, green: 0.9813225865, blue: 0.4743030667, alpha: 1))
    ]
    
    private var keys: [String] {return Array(emojiThemes.keys)}
    private var emojiChoices = [String]()
    private var backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    private var cardBackColor = #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 1)
    
    private var emoji = [Int:String]()
    
    private var indexTheme = 0 {
        didSet {
            emoji = [Int:String]()
            (emojiChoices,backgroundColor, cardBackColor) = emojiThemes[keys[indexTheme]] ?? ([], .black,.orange)
            updateUI()
        }
    }
    
    private func emoji(for card: Card) -> String {
        if emoji[card.identifier] == nil, emojiChoices.count > 0 {
            emoji[card.identifier] = emojiChoices.remove(at: emojiChoices.count.arc4random)
        }
        return emoji[card.identifier] ?? "?"
    }
    
    private func updateUI() {
        view.backgroundColor = backgroundColor
        newGameLabel.setTitleColor(cardBackColor, for: .normal)
        scoreLabel.textColor = cardBackColor
        flipCountLabel.textColor = cardBackColor
    }
}

extension Int {
    var arc4random: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return -(Int(arc4random_uniform(UInt32(self))))
        }else {
            return 0
        }
    }
}


extension Double {
    func truncate(to places:Int) -> Double {
        return Double(floor(pow(10.0, Double(places)) * self)/pow(10.0, Double(places)))
    }
}
