import SwiftUI

struct SearchBar: View {
    @Binding var text: String

    @State private var isEditing = false

    var body: some View {
        HStack {
            TextField("Search...", text: $text)
                .padding(7)
                .padding(.horizontal, 25)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 8)

                        if isEditing {
                            Button(action: {
                                self.text = ""
                            }) {
                                Image(systemName: "multiply.circle.fill")
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 8)
                            }
                        }
                    }
                )
                .onTapGesture {
                    self.isEditing = true
                }

            if isEditing {
                Button(action: {
                    self.isEditing = false
                    self.text = ""
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }) {
                    Text("Cancel")
                }
                .padding(.trailing, 10)
                .transition(.move(edge: .trailing))
                .animation(.default)
            }
        }
    }
}


struct Files: View {
    @State private var searchText: String = ""
    @State private var tiles: [Tile] = []
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    var body: some View {
        NavigationView {
            VStack {
                Divider()
                HStack {
                    NavigationLink(destination: startupPage()) {
                        Image(systemName: "person.crop.circle")
                            .resizable()
                            .frame(width: 32, height: 32)
                            .foregroundColor(.blue)
                    }.padding(.horizontal, 10)
                    Spacer()
                    SearchBar(text: $searchText)
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Logout")
                            .foregroundColor(.blue)
                            .padding(.horizontal, 10)
                    }
                }
                ScrollView {
                    LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 2), spacing: 20) {
                        ForEach(filteredTiles(), id: \.id) { tile in
                            TileView(title: tile.title) {
                                    deleteTile(tile: tile)
                            }                        }
                        Button(action: addTile) {
                            VStack(spacing: 0) {
                                ZStack {
                                    Rectangle()
                                        .fill(Color.white)
                                        .frame(width: 150, height: 150)
                                        .cornerRadius(12)
                                        .padding(.top, 35)
                                    
                                    Text("Add New")
                                        .foregroundColor(.black)
                                        .bold()
                                }
                                    .background(Color(hex: "#3C91E6", alpha: 0))
                                    .cornerRadius(12)
                                Text("+")
                                    .font(.system(size: 35, weight: .bold))
                                    .foregroundColor(Color.black)
                            }
                        }
                    }
                    .padding(.all)
                }
                .background(Color(hex: "F3E1A0", alpha: 27))
                .navigationBarTitle("Your Paintings", displayMode: .inline)
            }
        }
    }

    private func filteredTiles() -> [Tile] {
        if searchText.isEmpty {
            return tiles
        } else {
            return tiles.filter { $0.title.lowercased().contains(searchText.lowercased()) }
        }
    }

    private func addTile() {
        tiles.append(Tile(title: "Tile \(tiles.count + 1)"))
    }
    
    func deleteTile(tile: Tile) {
        if let index = tiles.firstIndex(where: { $0.id == tile.id }) {
            tiles.remove(at: index)
        }
    }
}

struct Tile: Identifiable {
    let id = UUID()
    let title: String
}

struct TileView: View {
    let title: String
    let onDelete: () -> Void
    @State private var isLongPressed = false

    var body: some View {
        ZStack(alignment: .topLeading) {
            NavigationLink(destination: GridView()){
                Rectangle()
                    .fill(Color.white)
                    .frame(width: 150, height: 150)
                    .cornerRadius(12)
                    .padding(.top, 5)
                    .onLongPressGesture {
                        isLongPressed.toggle()
                    }
                    .gesture(TapGesture(count: 2).onEnded({
                        isLongPressed = false
                    }))
                ZStack(alignment: .center) {
                    Text(title)
                        .foregroundColor(.black)
                        .bold()
                        .padding()
                }

                if isLongPressed {
                    Button(action: onDelete) {
                        Image(systemName: "xmark.circle")
                            .foregroundColor(.red)
                            .padding(EdgeInsets(top: 0, leading: -3, bottom: 0, trailing: 0))
                    }
                }
            }
            .cornerRadius(12)
            }
    }
}
