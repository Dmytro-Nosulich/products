//
//  SequenceUtilsTests.swift
//  ProductsTests
//
//  Created by Dmytro Nosulich on 01.06.25.
//

import Testing

struct SequenceUtilsTests {

  @Test func indexesOfWhenElementDoesNotExist() {
    // given
    let sequence = [1, 2, 3]

    // when
    let result = sequence.indexes(of: 4)

    // then
    #expect(result.isEmpty == true)
  }

  @Test func indexesOfWhenElementExists() {
    // given
    let sequence = [1, 2, 3, 2, 4, 7, 2]

    // when
    let result = sequence.indexes(of: 2)

    // then
    #expect(result == [1, 3, 6])
  }
}
