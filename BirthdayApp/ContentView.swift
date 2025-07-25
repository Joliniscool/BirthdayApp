//
//  ContentView.swift
//  BirthdayApp
//
//  Created by Jolin Wang on 7/25/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Query private var friends: [Friend]
    @Environment(\.modelContext) private var context

    @State private var newName = ""
    @State private var newBirthday = Date.now
    @State private var editingFriend: Friend? = nil

    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(friends) { friend in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(friend.name)
                                Text(friend.birthday, format: .dateTime.month(.wide).day().year())
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                            Button("Edit") {
                                editingFriend = friend
                                newName = friend.name
                                newBirthday = friend.birthday
                            }
                            .buttonStyle(.bordered)
                        }
                    }
                    .onDelete(perform: deleteFriend)
                }
                .navigationTitle("Birthdays")

                Divider()

                VStack(spacing: 12) {
                    Text(editingFriend == nil ? "Add New Birthday" : "Update Birthday")
                        .font(.headline)

                    TextField("Name", text: $newName)
                        .textFieldStyle(.roundedBorder)
                        .padding(.horizontal)

                    DatePicker("Birthday", selection: $newBirthday, in: ...Date(), displayedComponents: .date)
                        .datePickerStyle(.compact)
                        .padding(.horizontal)

                    Button(editingFriend == nil ? "Save" : "Update") {
                        if let friend = editingFriend {
                            // Update mode
                            friend.name = newName
                            friend.birthday = newBirthday
                            editingFriend = nil
                        } else {
                            // Create mode
                            let newFriend = Friend(name: newName, birthday: newBirthday)
                            context.insert(newFriend)
                        }

                        newName = ""
                        newBirthday = .now
                    }
                    .bold()
                    .padding(.bottom)
                }
                .padding()
                .background(.bar)
            }
        }
    }

    func deleteFriend(at offsets: IndexSet) {
        for index in offsets {
            let friendToDelete = friends[index]
            context.delete(friendToDelete)
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Friend.self)
}
