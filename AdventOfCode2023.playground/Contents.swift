import Foundation
import RegexBuilder

var dayOneInputOne: String = ""
var dayOneInputTwo: String = ""
var dayTwoInputOne: String = ""

if let filepath = Bundle.main.path(forResource: "DayOne/dayOneInputOne", ofType: "txt") {
    do {
        dayOneInputOne = try String(contentsOfFile: filepath)
    }
}

if let filepath = Bundle.main.path(forResource: "DayOne/dayOneInputTwo", ofType: "txt") {
    do {
        dayOneInputTwo = try String(contentsOfFile: filepath)
    }
}

if let filepath = Bundle.main.path(forResource: "DayTwo/inputOne", ofType: "txt") {
    do {
        dayTwoInputOne = try String(contentsOfFile: filepath)
    } catch {
        print(error)
    }
}

func dayOneOutputOne() -> Int {
    var lines = dayOneInputOne.split(whereSeparator: \.isNewline)
    var allNumbers = [Int]()

    lines.forEach { line in
        var reversedLine = line.reversed()

        var firstNumber = line.first { Int(String($0)) != nil }
        var lastNumber = line.last { Int(String($0)) != nil }

        guard let firstNumber, let lastNumber else { return }

        let finalNumber = String(firstNumber) + String(lastNumber)

        if let finalNumber = Int(finalNumber), finalNumber > 0 {
            allNumbers.append(finalNumber)
        }
    }

    let sum = allNumbers.reduce(0) { $0 + $1 }
    return sum
}

func dayOneOutputTwo() -> Int {
    let mapping: [String: Int] = [
        "one": 1, "two": 2, "three": 3, "four": 4, "five": 5,
        "six": 6, "seven": 7, "eight": 8, "nine": 9
    ]

    var allNumbers = [Int]()
    var lines = dayOneInputTwo.split(whereSeparator: \.isNewline)

    lines.forEach { line in
        var firstNumber = 0
        var lastNumber = 0

        let wordsToFind = mapping.keys.joined(separator: "|") + "|[0-9]"
        let pattern = try! NSRegularExpression(pattern: wordsToFind, options: [])
        let matches = pattern.matches(in: String(line), options: [], range: NSRange(location: 0, length: line.utf16.count))

        let matchedStrings = matches.map { match in
            (line as NSString).substring(with: match.range)
        }

        // Checking String reversed so I can get "one" out of "twone" (example)
        let reversedInput = String(line).reversed()
        let reversedWordsToFind = mapping.keys.map { $0.reversed() }.joined(separator: "|") + "|[0-9]"
        let reversedRegex = try! NSRegularExpression(pattern: reversedWordsToFind, options: [])
        let reversedMatches = reversedRegex.matches(in: String(reversedInput), options: [], range: NSRange(location: 0, length: String(reversedInput).utf16.count))

        let reverseMatchedStrings = reversedMatches.map { match in
            (String(reversedInput) as NSString).substring(with: match.range)
        }

        let firstMatched = matchedStrings.first
        let lastMatched = reverseMatchedStrings.first

        guard let firstMatched, let lastMatched else { return }

        if let mappedFirstMatch = mapping[firstMatched] {
            firstNumber = mappedFirstMatch
        } else if let mappedFirstMatch = Int(firstMatched) {
            firstNumber = mappedFirstMatch
        }

        if let mappedLastMatch = mapping[String(lastMatched.reversed())] {
            lastNumber = mappedLastMatch
        } else if let mappedLastMatch = Int(lastMatched) {
            lastNumber = mappedLastMatch
        }

        let finalNumber = String(firstNumber) + String(lastNumber)

        if let finalNumber = Int(finalNumber), finalNumber > 0 {
            allNumbers.append(finalNumber)
        }
    }

    return allNumbers.reduce(0) { $0 + $1 }
}

func dayTwoOutputOne() {
    var lines = dayTwoInputOne.split(whereSeparator: \.isNewline)
    var games: [Int: Bool] = [:]

    lines.forEach { line in
        let splitedGame = line.split(separator: ":")
        let gameId = splitedGame.first?.split(whereSeparator: \.isWhitespace).last
        let gameSets = splitedGame.last?.split(separator: ";")
        var gamePossibility = true
        
        gameSets?.forEach { gameSet in
            var colorSets = gameSet.split(separator: ",")

            var test = [
                "blue": 0,
                "red": 0,
                "green": 0,
            ]

            colorSets.forEach { colorSet in
                let splitedColorSet = colorSet.split(whereSeparator: \.isWhitespace)

                guard let colorName = splitedColorSet.last,
                      let colorCount = splitedColorSet.first,
                      let numericColorCount = Int(colorCount) else { return }
                
                switch colorName {
                case "green":
                    gamePossibility = gamePossibility && numericColorCount <= 13
                case "blue":
                    gamePossibility = gamePossibility && numericColorCount <= 14
                case "red":
                    gamePossibility = gamePossibility && numericColorCount <= 12
                default:
                    break
                }
            }
        }
        
        guard let gameId, let numericGameId = Int(gameId) else { return }
        games[numericGameId] = gamePossibility
    }
    
    var idSum = games.reduce(0) { $1.value ? $0 + $1.key : $0 }
    
    print(idSum)
}

// print("Day One: Part One", dayOneOutputOne())
// print("Day One: Part Two", dayOneOutputTwo())
dayTwoOutputOne()
