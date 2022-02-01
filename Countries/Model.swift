//
//  Model.swift
//  Countries
//
//  Created by Eda Altuntas on 1.02.2022.
//

import Foundation


// MARK: - CountriesResponse
struct CountriesResponse: Decodable {
    let data: [Datum]
    let links: [Link]
    let metadata: Metadata
}

// MARK: - Datum
struct Datum: Decodable {
    var code: String?
    let currencyCodes: [String]?
    var name, wikiDataID: String?

    enum CodingKeys: String, CodingKey {
        case code, currencyCodes, name
        case wikiDataID = "wikiDataId"
    }
}

// MARK: - Link
struct Link: Codable {
    let rel, href: String
}

// MARK: - Metadata
struct Metadata: Codable {
    let currentOffset, totalCount: Int
}

// MARK: - Detail
struct Detail: Codable {
    let data: DataClass
}

// MARK: - DataClass
struct DataClass: Codable {
    let capital, code, callingCode: String?
    let currencyCodes: [String]?
    let flagImageURI: String?
    let name: String?
    let numRegions: Int?
    let wikiDataID: String?

    enum CodingKeys: String, CodingKey {
        case capital, code, callingCode, currencyCodes
        case flagImageURI = "flagImageUri"
        case name, numRegions
        case wikiDataID = "wikiDataId"
    }
}
