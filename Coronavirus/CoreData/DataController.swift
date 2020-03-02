//
//  DataController.swift
//  Coronavirus
//
//  Created by Marius Lazar on 28/02/2020.
//  Copyright © 2020 Biolazard. All rights reserved.
//

import UIKit
import CoreData

class DataController: NSObject {
    
    
    private var persistentContainer: NSPersistentContainer
    
    override init() {
        persistentContainer = NSPersistentContainer(name: "Coronavirus")
        persistentContainer.loadPersistentStores { (description, error) in
            if let error = error {
                fatalError("Failed to load Core Data \(error)")
            }
        }
    }
    
    func insert(c19: Covid) {
        let manageContext = self.persistentContainer.viewContext
        let caseOfCoronavirus = NSEntityDescription.insertNewObject(forEntityName: "Coronavirus", into: manageContext) as! Covid19
        caseOfCoronavirus.confirmed = c19.confirmed
        caseOfCoronavirus.country = c19.country
        caseOfCoronavirus.recovered = c19.recovered
        caseOfCoronavirus.deaths = c19.deaths
        caseOfCoronavirus.lastUpdate = c19.lastUpdate
        caseOfCoronavirus.latitude = c19.coordinates.latitude
        caseOfCoronavirus.longitude = c19.coordinates.longitude
        do {
            try manageContext.save()
        } catch {
            fatalError("ERROR SAVE CORE DATA \(error)")
        }
        
    }
    
    func deleteData(completion: @escaping () -> ()) {
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Coronavirus")
        let delete = NSBatchDeleteRequest(fetchRequest: fetch)
        let manageContext = self.persistentContainer.viewContext
        do {
            try manageContext.execute(delete)
            completion()
        } catch {
            fatalError("ERROR DELETE DATA \(error)")
        }
    }
    
    func getDataSpread() -> [Covid19] {
        let fetch = NSFetchRequest<Covid19>(entityName: "Coronavirus")
        do {
            let datas = try persistentContainer.viewContext.fetch(fetch)
            return datas
        } catch {
            fatalError("ERROR FETCH CORE DATA \(error)")
        }
    }
    
}

extension DataController {
    
    
    func insertLastUpdate(date: String) {
        if let lastUpdate = self.getLastUpdate(), lastUpdate < date {
            self.deleteLastUpdate()
        }
        let manageContext = self.persistentContainer.viewContext
        let update = NSEntityDescription.insertNewObject(forEntityName: "Aggiornamento", into: manageContext) as! Aggiornamento
        update.lastUpdate = date
        do {
            try manageContext.save()
        } catch {
            fatalError("ERROR INSERT LAST UPDATE \(error)")
        }
        
    }
    
    func getLastUpdate() -> String? {
        let fetch = NSFetchRequest<Aggiornamento>(entityName: "Aggiornamento")
        do {
            let datas = try persistentContainer.viewContext.fetch(fetch)
            return datas.first?.lastUpdate
        } catch {
            fatalError("ERROR FETCH LAST UPDATE \(error)")
        }
    }
    
    private func deleteLastUpdate() {
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Aggiornamento")
        let delete = NSBatchDeleteRequest(fetchRequest: fetch)
        let manageContext = self.persistentContainer.viewContext
        do {
            try manageContext.execute(delete)
        } catch {
            fatalError("ERROR DELETE LAST UPDATE \(error)")
        }
    }
}
