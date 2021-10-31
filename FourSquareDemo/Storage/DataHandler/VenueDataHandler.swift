//
//  VenueDataHandler.swift
//  FourSquareDemo
//
//  Created by Elvis Mwenda on 31/10/2021.
//

import Foundation
import CoreData

class VenueDataHandler: NSObject, DataHandler {
    typealias APIResponse = PlacesResponse
    typealias DataType = VenueData
    typealias IdType = String
    static func getData() -> [VenueData] {
        let moc = StorageService.shared.container.viewContext
        let entityDescription = NSEntityDescription.entity(forEntityName: "VenueData", in: moc)
        let request: NSFetchRequest<VenueData> = VenueData.fetchRequest()
        request.entity = entityDescription
        let systemTimeSort = NSSortDescriptor(key: "id", ascending: true)
        request.sortDescriptors = [systemTimeSort]
        do {
            return try moc.fetch(request)
        } catch {
            Logger.shared.log(error, #file, #line)
        }
        return []
    }
    
    static func saveData(response: PlacesResponse) {
        performSave(response)
    }
    
    static func saveAndReturnData(response: PlacesResponse) -> [DataType] {
        deleteAllItems()
        performSave(response)
        return getData()
    }
    
    private static func performSave(_ response: PlacesResponse) {
        let moc = StorageService.shared.container.viewContext
        for item in response.response.venues {
            let data = VenueData(context: moc)
            data.name = item.name
            data.id = item.id
            var categorySet = Set<VenueCategory>()
            item.categories.forEach { cat in
                let category = VenueCategory(context: moc)
                category.id = cat.id
                category.name = cat.name
                category.shortName = cat.shortName
                category.pluralName = cat.pluralName
                category.iconPath = cat.icon.iconPrefix + Constants.fourSquareImageSize + cat.icon.suffix
                categorySet.update(with: category)
            }
            
            let location = VenuLocation(context: moc)
            var address = item.location.formattedAddress.reduce(",", +)
            address.removeFirst()
            location.formattedAddress = address
            location.country = item.location.country
            location.address = item.location.address
            location.postalCode = item.location.postalCode
            location.distance = Double(item.location.distance)
            location.cc = item.location.cc
            location.city = item.location.city
            location.state = item.location.state
            location.lat = item.location.lat
            location.lng = item.location.lng
            location.crossStreet = item.location.crossStreet
            data.location = location
            data.categories = categorySet as NSSet
        }
        StorageService.shared.saveContext()
    }
    
    // Delete all stored cat items
     private static func deleteAllItems() {
         let request = NSFetchRequest<NSFetchRequestResult>(entityName: "VenueData")
         do {
             if let all = try StorageService.shared.container.viewContext.fetch(request) as? [VenueData] {
                 for item in all {
                     StorageService.shared.container.viewContext.delete(item)
                 }
             }
         } catch {
             let nserror = error as NSError
             #if DEBUG
                 fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
             #else
                 Logger.shared.log(error, #file, #line, nsError.userInfo)
             #endif
         }
         
         StorageService.shared.saveContext()
     }
    
    static func getSingle(id: IdType) -> DataType? {
        let moc = StorageService.shared.container.viewContext
        let entityDescription = NSEntityDescription.entity(forEntityName: "VenueData", in: moc)
        let predicate = NSPredicate(format: "id = %@", argumentArray: [id])
        let request: NSFetchRequest<VenueData> = VenueData.fetchRequest()
        request.predicate = predicate
        request.entity = entityDescription
        request.fetchLimit = 1
        do {
            let results = try moc.fetch(request)
            return results.last
        } catch {
            Logger.shared.log(error, #file, #line)
        }
        return nil
    }
}
