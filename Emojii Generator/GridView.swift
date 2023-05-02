//
//  GridView.swift
//  Emojii Generator
//
//  Created by Kartavya Sharma on 5/1/23.
//

import SwiftUI

struct GridView: View {
    let columns: Int = 5
    let rows: Int = 5
    let secretTitle: String;
    
    @State private var predefinedCharacter: String = " "
    @State private var currentCharacter: String = " "
    
    @State private var gridCharacters: [[String]] = Array(repeating: Array(repeating: " ", count: 5), count: 5)
    //backend.init(filename : nil)
    /* let rows : Int = gridCharacters.count
    let columns : Int = gridCharacters[0].count*/
    @State private var currentPosition: CGPoint = .zero
    
    @State private var erasing : Bool = false
    
    @State private var button1 : String = ""
    @State private var button2 : String = ""
    @State private var button3 : String = ""
    @State private var button4 : String = ""
    @State private var button5 : String = ""
    
    @State private var outputSheet : Bool = false
    
    private func generateString() -> String{
        var result = ""

        for row in 0..<rows {
            for column in 0..<columns {
                result.append(gridCharacters[row][column])
            }
            if row != rows - 1 {
                result.append("\n")
            }
        }

        return result
    }
    
    private func indexForLocation(_ location: CGPoint, gridSize: CGSize) -> (Int, Int)? {
        let cellWidth = gridSize.width / CGFloat(columns)
        let cellHeight = gridSize.height / CGFloat(rows)
        
        let column = Int(location.x / cellWidth)
        let row = Int(location.y / cellHeight)
        
        guard column >= 0 && column < columns && row >= 0 && row < rows else {
            return nil
        }
        
        return (column, row)
    }
    
    var body: some View {
        VStack{
            Spacer()
            HStack{
                TextField(
                    "enter your character",
                    text: $currentCharacter
                )
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
                .border(.secondary)
                .onSubmit {
                    predefinedCharacter = currentCharacter
                    button5 = button4
                    button4 = button3
                    button3 = button2
                    button2 = button1
                    button1 = currentCharacter
                    erasing = false
                }
                .onAppear {
                    fetchEmojiGrid()
                }
                .font(.title)
                .frame(width: 250, height: 40)
                .foregroundColor(Color.black)
                .background(Color(UIColor(red: CGFloat(0xF3) / 255, green: CGFloat(0xE1) / 255, blue: CGFloat(0xA0) / 255, alpha: 1)))
                Button("erase"){
                   erasing = erasing ? false : true
                   predefinedCharacter = erasing ? " " : currentCharacter
                }
                .font(.title)
                .frame(width: 100, height: 40)
                .foregroundColor(Color.black)
                .background(Color(erasing ? .blue : .gray))
            }
            Text(String(predefinedCharacter))
                .font(.title2)
            HStack{
                Button(button1){
                    currentCharacter = button1
                    if(!erasing){
                        predefinedCharacter = currentCharacter
                    }
                }
                .font(.title)
                .frame(width: 40, height: 40)
                .foregroundColor(Color.black)
                .background(currentCharacter == button1 ? Color(UIColor(red: CGFloat(0x0B) / 255, green: CGFloat(0xC4) / 255, blue: CGFloat(0xFF) / 255, alpha: 1)) : Color(UIColor(red: 0, green: 0, blue: 0, alpha: 0)))
                Button(button2){
                    currentCharacter = button2
                    if(!erasing){
                        predefinedCharacter = currentCharacter
                    }
                }
                .font(.title)
                .frame(width: 40, height: 40)
                .foregroundColor(Color.black)
                .background(currentCharacter == button2 ? Color(UIColor(red: CGFloat(0x0B) / 255, green: CGFloat(0xC4) / 255, blue: CGFloat(0xFF) / 255, alpha: 1)) : Color(UIColor(red: 0, green: 0, blue: 0, alpha: 0)))
                Button(button3){
                    currentCharacter = button3
                    if(!erasing){
                        predefinedCharacter = currentCharacter
                    }
                }
                .font(.title)
                .frame(width: 40, height: 40)
                .foregroundColor(Color.black)
                .background(currentCharacter == button3 ? Color(UIColor(red: CGFloat(0x0B) / 255, green: CGFloat(0xC4) / 255, blue: CGFloat(0xFF) / 255, alpha: 1)) : Color(UIColor(red: 0, green: 0, blue: 0, alpha: 0)))
                Button(button4){
                    currentCharacter = button4
                    if(!erasing){
                        predefinedCharacter = currentCharacter
                    }
                }
                .font(.title)
                .frame(width: 40, height: 40)
                .foregroundColor(Color.black)
                .background(currentCharacter == button4 ? Color(UIColor(red: CGFloat(0x0B) / 255, green: CGFloat(0xC4) / 255, blue: CGFloat(0xFF) / 255, alpha: 1)) : Color(UIColor(red: 0, green: 0, blue: 0, alpha: 0)))
                Button(button5){
                    currentCharacter = button5
                    if(!erasing){
                        predefinedCharacter = currentCharacter
                    }
                }
                .font(.title)
                .frame(width: 40, height: 40)
                .foregroundColor(Color.black)
                .background(currentCharacter == button5 ? Color(UIColor(red: CGFloat(0x0B) / 255, green: CGFloat(0xC4) / 255, blue: CGFloat(0xFF) / 255, alpha: 1)) : Color(UIColor(red: 0, green: 0, blue: 0, alpha: 0)))
            }
            GeometryReader { geometry in
                VStack(spacing: 0) {
                    ForEach(0..<rows, id: \.self) { row in
                        HStack(spacing: 0) {
                            ForEach(0..<columns, id: \.self) { column in
                                GridCell(character: $gridCharacters[row][column])
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .contentShape(Rectangle())
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { value in
                            if let (column, row) = indexForLocation(value.location, gridSize: geometry.size) {
                                gridCharacters[row][column] = predefinedCharacter
                            }
                        }
                )
            }
            HStack{
                Button("Save"){
                   saveGrid()
                }
                    .font(.headline)
                    .frame(width: 132, height: 46)
                    .foregroundColor(Color.black)
                    .background(Color(UIColor(red: CGFloat(0x0B) / 255, green: CGFloat(0xC4) / 255, blue: CGFloat(0xFF) / 255, alpha: 1)))
                Button("Output") {
                    outputSheet.toggle()
                }
                .sheet(isPresented: $outputSheet){} content:{
                    Output(output: generateString())
                }
                .font(.headline)
                .frame(width: 132, height: 46)
                .foregroundColor(Color.black)
                .background(Color(UIColor(red: CGFloat(0x0B) / 255, green: CGFloat(0xC4) / 255, blue: CGFloat(0xFF) / 255, alpha: 1)))
            }
            Spacer()
        }
        .background(Color(UIColor(red: CGFloat(0xf3) / 255, green: CGFloat(0xe1) / 255, blue: CGFloat(0xa1) / 255, alpha: 0.625)))
    }
    
    private func saveGrid() {
        guard let authToken = UserDefaults.standard.string(forKey: "authToken") else {
            print("No authToken found in UserDefaults")
            return
        }
        guard let url = URL(string: "http://localhost:3333/emoji/create-emoji") else {
            print("Invalid URL")
            return
        }

        let gridData = GridSaveData(emoji: gridCharacters, name: secretTitle)

        do {
            let requestData = try JSONEncoder().encode(gridData)

            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = requestData

            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error occurred: \(error)")
                } else {
                    print("Grid saved successfully")
                }
            }.resume()
        } catch {
            print("Failed to encode grid data: \(error)")
        }
    }
    
    private func fetchEmojiGrid() {
        guard let authToken = UserDefaults.standard.string(forKey: "authToken") else {
            print("No authToken found in UserDefaults")
            return
        }
        guard let url = URL(string: "http://localhost:3333/emoji/get-user-emojis") else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                do {
                    let decodedResponse = try JSONDecoder().decode(EmojiGridResponse.self, from: data)
                    DispatchQueue.main.async {
                        if let emojiGrid = decodedResponse.payload.first(where: { $0._name == secretTitle }) {
                            gridCharacters = emojiGrid._emoji
                        } else {
                            print("No grid found with the name: \(secretTitle)")
                        }
                    }
                } catch {
                    print("Failed to decode JSON: \(error)")
                }
            } else if let error = error {
                print("Error occurred: \(error)")
            }
        }.resume()
    }

    struct EmojiGridResponse: Codable {
        let code: Int
        let payload: [EmojiGrid]
    }

    struct EmojiGrid: Codable {
        let _emoji: [[String]]
        let _name: String
        let _userId: String
    }
    
    struct GridSaveData: Codable {
        let emoji: [[String]]
        let name: String
    }

}

struct Output: View {
    //This code allows us to call the dismiss() function which closes the sheet view
    @Environment(\.dismiss) var dismiss
    let result : String
    
    init(output : String){
        result = output
    }
    
    var body: some View {
        //Add some content to the body of your sheet!
        //Remember to include a button that just calls dismiss() in the action
        HStack{
            Button("Back"){
                dismiss()
            }
            .padding()
            .foregroundColor(.blue)
            Spacer()
        }
        Spacer()
        VStack{
            Text(result)
                .font(.largeTitle)
                .frame(width: 300)
                .foregroundColor(.black)
            Button("Copy") {
                UIPasteboard.general.string = result
            }
            .font(.headline)
            .frame(width: 132, height: 46)
            .foregroundColor(Color.black)
            .background(Color(UIColor(red: CGFloat(0x0B) / 255, green: CGFloat(0xC4) / 255, blue: CGFloat(0xFF) / 255, alpha: 1)))

        }
        Spacer()
    }

}
