import Foundation

struct Level {
    let board: [[Int]]
    let goal: Int
    let seed: UInt64
}

/// Simple level generator for Match-3 math goals.
/// Generates an 8x8 grid of values 1...5 and ensures there is
/// at least one horizontal or vertical match of three tiles whose
/// sum equals the target goal.
class LevelGenerator {
    static let size = 8
    private let maxValue = 5

    /// Generates a level with the provided goal.
    /// - Parameters:
    ///   - goal: Target sum for a triple match.
    ///   - attempts: Number of attempts before giving up.
    ///   - seed: Optional seed for deterministic generation.
    /// - Returns: `Level` if solvable, otherwise `nil`.
    func generate(goal: Int, attempts: Int = 1000, seed: UInt64? = nil) -> Level? {
        var rng = seed.map { SeededGenerator(seed: $0) } ?? SeededGenerator()
        for _ in 0..<attempts {
            let currentSeed = rng.next()
            let board = randomBoard(generator: &rng)
            if hasSolution(board: board, goal: goal) {
                return Level(board: board, goal: goal, seed: currentSeed)
            }
        }
        return nil
    }

    // MARK: - Internal helpers

    private func randomBoard<G: RandomNumberGenerator>(generator: inout G) -> [[Int]] {
        (0..<Self.size).map { _ in
            (0..<Self.size).map { _ in
                Int.random(in: 1...maxValue, using: &generator)
            }
        }
    }

    private func hasSolution(board: [[Int]], goal: Int) -> Bool {
        let n = Self.size
        guard board.count == n && board.allSatisfy({ $0.count == n }) else { return false }
        // Horizontal matches
        for i in 0..<n {
            for j in 0..<(n - 2) {
                let sum = board[i][j] + board[i][j+1] + board[i][j+2]
                if sum == goal { return true }
            }
        }
        // Vertical matches
        for i in 0..<(n - 2) {
            for j in 0..<n {
                let sum = board[i][j] + board[i+1][j] + board[i+2][j]
                if sum == goal { return true }
            }
        }
        return false
    }
}

/// Deterministic random number generator based on UInt64 seed.
struct SeededGenerator: RandomNumberGenerator {
    private var state: UInt64

    init(seed: UInt64 = UInt64.random(in: .min...UInt64.max)) {
        self.state = seed == 0 ? 0xdeadbeef : seed
    }

    mutating func next() -> UInt64 {
        state &+= 0x9e3779b97f4a7c15
        var z = state
        z = (z ^ (z >> 30)) &* 0xbf58476d1ce4e5b9
        z = (z ^ (z >> 27)) &* 0x94d049bb133111eb
        return z ^ (z >> 31)
    }
}
