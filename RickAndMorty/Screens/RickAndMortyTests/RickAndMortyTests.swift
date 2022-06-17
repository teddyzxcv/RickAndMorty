//
//  RickAndMortyTests.swift
//  RickAndMortyTests
//
//  Created by ZhengWu Pan on 14.06.2022.
//

import XCTest
@testable import RickAndMorty

class RickAndMortyTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        let ids = [0,1,2,3]
        let character = CharacterModel(id: 1, name: "Rick Sanchez", status: "Alive", species: "Human", gender: "Male", image: ImageLoader.getImageURLbyID(1)!)
        CharacterStorage.save(ids, .favourite)
        CharacterStorage.removeCharacterFor(.favourite, character)
        let newIds = CharacterStorage.getCharactersID(.favourite)
        XCTAssertEqual(ids.filter{ $0 != character.id }, newIds)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
