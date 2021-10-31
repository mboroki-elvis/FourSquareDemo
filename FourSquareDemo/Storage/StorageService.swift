//
//  StorageService.swift
//  FourSquareDemo
//
//  Created by Elvis Mwenda on 31/10/2021.
//

import CoreData

struct StorageService {
    // MARK: Lifecycle

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "FourSquareDemo")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { _, error in
            if let error = error as NSError? {
                #if DEBUG
                    fatalError("Unresolved error \(error), \(error.userInfo)")
                #else
                    Logger.shared.log(error, #file, #line, error.userInfo)
                #endif
            }
        })
    }

    // MARK: Internal

    static let shared = StorageService()

    let container: NSPersistentContainer

    // MARK: - Core Data Saving support

    func saveContext() {
        let context = container.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                #if DEBUG
                    fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                #else
                    Logger.shared.log(error, #file, #line, nsError.userInfo)
                #endif
            }
        }
    }
}
