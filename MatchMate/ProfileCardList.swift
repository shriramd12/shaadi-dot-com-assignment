//
//  ContentView.swift
//  MatchMate
//
//  Created by Shriram Dharmadhikari on 02/09/24.
//

import SwiftUI
import CoreData
import CachedAsyncImage

struct ProfileCardList: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>

    var body: some View {
        List {
            profileCardItem()
        }
    }

    @ViewBuilder func profileCardItem() -> some View {
        VStack(content: {
            CachedAsyncImage(url: URL(string: "https://randomuser.me/api/portraits/women/37.jpg"), content: { image in
                image
            }, placeholder: {
                Image("photo.artframe")
            }).frame(width: 128, height: 128)
            Text("Jon Doe")
            HStack(content: {
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                    Image(systemName: "checkmark")
                })
                .buttonBorderShape(ButtonBorderShape.circle)
                .buttonStyle(.borderedProminent)
                .tint(.green)
                .controlSize(.large)
                Spacer()
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                    Image(systemName: "xmark")
                })
                .buttonBorderShape(ButtonBorderShape.circle)
                .buttonStyle(.borderedProminent)
                .tint(.red)
                .controlSize(.large)
            })
        })
    }
    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()
