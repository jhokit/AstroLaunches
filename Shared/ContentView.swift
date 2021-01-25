//
//  ContentView.swift
//  Shared
//
//  Created by rocketjeff on 1/12/21.
//

import SwiftUI
import CoreData
import AstroSwiftFoundation
import SwiftUIListSeparator

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>

    init(){
        UIView.appearance().backgroundColor = UIColor.astroUIBackground

        // These do nothing when the UIView backgroundColor is set above
        UINavigationBar.appearance().barStyle = .default
        UINavigationBar.appearance().isTranslucent = true
        UINavigationBar.appearance().barTintColor = UIColor.red
        UINavigationBar.appearance().backgroundColor = UIColor.red

    }
    
    var body: some View {
        #if os(iOS)
        // must embed List within a NavigationView on iOS or .toolbar wont work
        NavigationView{
            List {
                ForEach(items) { item in
                    Text("Item at \(item.timestamp!, formatter: itemFormatter)")
                }
                .onDelete(perform: deleteItems)
                .listRowBackground(Color(UIColor.astroUITableCell))
            }
            .listSeparatorStyle(.singleLine, color: .astroUITableSeparator)
            .navigationTitle("Launches")
            .toolbar {
                ToolbarItem(placement: .automatic)
                {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }

        }

        #endif
        
        #if os(macOS)
        List {
            ForEach(items) { item in
                Text("Item at \(item.timestamp!, formatter: itemFormatter)")
            }
            .onDelete(perform: deleteItems)
        }
        .toolbar {
            Button(action: addItem) {
                Label("Add Item", systemImage: "plus")
            }
        }
        #endif
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().preferredColorScheme(.dark).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
