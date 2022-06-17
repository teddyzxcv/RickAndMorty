//
//  ImageUtil.swift
//  RickAndMorty
//
//  Created by ZhengWu Pan on 17.06.2022.
//

import Foundation

final class ImageUtil{
    static func getImageURLbyID(_ id: Int) -> URL? {
        return URL(string:"https://rickandmortyapi.com/api/character/avatar/\(id).jpeg")
    }

    static func getCharacterURLbyID(_ id: Int) -> URL? {
        return URL(string: "https://rickandmortyapi.com/api/character/\(id)"  )
    }
}


