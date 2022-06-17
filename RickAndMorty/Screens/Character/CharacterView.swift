//
//  CharacterView.swift
//  RickAndMorty
//
//  Created by ZhengWu Pan on 24.05.2022.
//

import SwiftUI

struct FavouriteButton: ButtonStyle {
        
    func makeBody(configuration: Configuration) -> some View {
        configuration.label.tint(Color(UIColor.main))
    }
}

struct CharacterView: View {
    
    // @Environment(\.colorSceme) var colorScheme: ColorScheme
    
    @State var data: CharacterModel
    
    @State private var isFavouriteButtonSelected: Bool = true
    
    var body: some View {
        return ScrollView {
            VStack{
                AsyncImage(url: data.image)
                    .clipShape(Rectangle())
                    .cornerRadius(10)
                HStack{
                    Text(data.name)
                        .fontWeight(.bold)
                        .font(Font.title)
                    //                        .padding(.leading)
                    Spacer()
                    
                    Button(action: {
                        isFavouriteButtonSelected.toggle()
                        if isFavouriteButtonSelected {
                            let favouriteCharacters = UserDefaults.standard.array(forKey: "Favourite characters") as? [Int]
                            var newFavouriteCharacters = favouriteCharacters
                            newFavouriteCharacters?.append(data.id)
                            UserDefaults.standard.set(newFavouriteCharacters, forKey: "Favourite characters")
                        } else {
                            let favouriteCharacters = UserDefaults.standard.array(forKey: "Favourite characters") as? [Int]
                            let newFavouriteCharacters = favouriteCharacters?.filter {$0 != data.id}
                            UserDefaults.standard.set(newFavouriteCharacters, forKey: "Favourite characters")
                        }
                    }, label: {
                        isFavouriteButtonSelected ? Image("Favourite_button_s").renderingMode(.template) : Image("Favourite_button_u")
                    })
                    .buttonStyle(FavouriteButton())
                        
                    //                    .padding(.trailing)
                }.padding()
                VStack(alignment: .leading) {
                    Text("Status")
                        .foregroundColor(Color(UIColor.secondary))
                        .fontWeight(.semibold)
                    Text(data.status)
                        .foregroundColor(Color(UIColor.main))
                        .fontWeight(.semibold)
                    Divider()
                }
                VStack(alignment: .leading) {
                    Text("Species")
                        .foregroundColor(Color(UIColor.secondary))
                        .fontWeight(.semibold)
                    Text(data.species)
                        .foregroundColor(Color(UIColor.main))
                        .fontWeight(.semibold)
                    Divider()
                }
                VStack(alignment: .leading) {
                    Text("Gender")
                        .foregroundColor(Color(UIColor.secondary))
                        .fontWeight(.semibold)
                    Text(data.gender)
                        .foregroundColor(Color(UIColor.main))
                        .fontWeight(.semibold)
                    Divider()
                }
            }
            .padding(.horizontal, 16)
        }
    }
}

struct CharacterView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CharacterView(data: CharacterModel(id: 1, name: "Rick Sanchez", status: "Alive", species: "Human", gender: "Male", image: ImageUtil.getImageURLbyID(1)!))
            CharacterView(data: CharacterModel(id: 1, name: "Rick Sanchez", status: "Alive", species: "Human", gender: "Male", image: ImageUtil.getImageURLbyID(1)!))
                .preferredColorScheme(.dark)
        }
        
    }
}
