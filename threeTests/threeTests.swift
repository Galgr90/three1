//
//  threeTests.swift
//  threeTests
//
//  Created by Grigoriy Galperin on 29.07.2025.
//

import Testing
@testable import three

struct threeTests {

    @Test func levelGeneratorProducesSolvableLevel() throws {
        let generator = LevelGenerator()
        let level = generator.generate(goal: 10)
        #expect(level != nil)
    }

}
