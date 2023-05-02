import SwiftUI

struct Files: View {
    @State private var searchText: String = ""
    @State private var tiles: [Tile] = []
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    let bearerToken = UserDefaults.standard.string(forKey: "authToken")!
    
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
                .onAppear {
                    getTiles()
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
    
    
    private func getTiles() {
        guard let url = URL(string: "http://localhost:3333/emoji/get-user-emojis") else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                do {
                    let decodedResponse = try JSONDecoder().decode(TileResponse.self, from: data)
                    DispatchQueue.main.async {
                        self.tiles = decodedResponse.payload.map { Tile(title: $0._name) }
                    }
                } catch {
                    self.tiles = []
                    print("Failed to decode JSON: \(error)")
                }
            } else if let error = error {
                print("Error occurred: \(error)")
            }
        }.resume()
    }
    
    struct TileResponse: Codable {
        let code: Int
        let payload: [TileData]
    }

    struct TileData: Codable {
        let _emoji: [[String]]
        let _name: String
        let _userId: String
    }

    private func addTile() {
        tiles.append(Tile(title: "Work \(tiles.count + 1)"))
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
                NavigationLink(destination: GridView(secretTitle: title)){
                    Text(title)
                        .foregroundColor(.black)
                        .bold()
                        .padding()
                }
            }

            if isLongPressed {
                Button(action: onDelete) {
                    Image(systemName: "xmark.circle")
                        .foregroundColor(.red)
                        .padding(EdgeInsets(top: 0, leading: -3, bottom: 0, trailing: 0))
                }
            }
        }
    }
}
