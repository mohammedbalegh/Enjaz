import Foundation
import UIKit

class MedalsManager {
    
    static func checkForMedals(itemAdded: ItemModel) {
        
        switch itemAdded.type_id {
        
        case ItemType.achievement.id:
            checkForAchievements(category: itemAdded.category_id)
        case ItemType.demah.id:
            checkForDemahsMedals()
        case ItemType.goal.id:
            checkForGoalsMedals()
            checkForDailyGoals()
            checkForWeaklyGoals()
            checkForTasksMedals()
        case ItemType.task.id:
            checkForTasksMedals()
        default:
            break
        }
    }
    
    static func checkForAchievements(category: Int) {
        switch category {
        case 0:
            checkForReligiousAchievementMedals()
        case 1:
            checkForScientificAchievementMedals()
        case 2:
            checkForHealthAchievementMedals()
        case 3:
            checkForSocialAchievementMedals()
        case 4:
            checkForCareerAchievementMedals()
        case 5:
            checkForPersonalAchievementMedals()
        case 6:
            checkForFinancialAchievementMedals()
        case 7:
            checkForFamilyAchievementMedals()
        case 8:
            checkForEntertainmentAchievementMedals()
        default:
            break
        }
    }
    
    static func presentMedalPopUp(id: Int) {
        let medalPopUp = AlertPopup()
        let medal = RealmManager.retrieveMedalById(id: id)
        
        if medal?.image == "" {
            medalPopUp.present(withImage: UIImage(named:"medalIcon-1"), title: medal!.name, message: medal!.medalDescription)
        } else {
            medalPopUp.present(withImage: medal!.image.toImage(), title: medal!.name, message: medal!.medalDescription)
        }
        
        RealmManager.updateMedal(id: id, earned: true)
    }
    
    static func retrieveItemsWithFilter(type: Int, category: Int?) -> [ItemModel] {
        if let category = category {
            return  RealmManager.retrieveItems(withFilter: "type_id == \(type) && category_id == \(category) && is_completed == true")
        } else {
            return RealmManager.retrieveItems(withFilter: "type_id == \(type) && is_completed == true")
        }
    }
    
    static func checkForTasksMedals() {
        let tasks = retrieveItemsWithFilter(type: ItemType.task.id, category: nil)
        
        if tasks.count == 50 {
            presentMedalPopUp(id: 33)
        } else if tasks.count == 100 {
            presentMedalPopUp(id: 34)
        } else if tasks.count == 500 {
            presentMedalPopUp(id: 35)
        }
    }
    
    static func checkForGoalsMedals() {
        let goals = retrieveItemsWithFilter(type: ItemType.goal.id, category: nil)
        
        if goals.count == 10 {
            presentMedalPopUp(id: 2)
        } else if goals.count == 30 {
            presentMedalPopUp(id: 3)
        } else if goals.count == 50 {
            presentMedalPopUp(id: 4)
        }
    }
    
    static func checkForDemahsMedals() {
        let demahs = retrieveItemsWithFilter(type: ItemType.demah.id, category: nil)
        
        if demahs.count == 3 {
            presentMedalPopUp(id: 5)
        } else if demahs.count == 10 {
            presentMedalPopUp(id: 6)
        } else if demahs.count == 50 {
            presentMedalPopUp(id: 7)
        }
    }
    
    static func checkForReligiousAchievementMedals() {
        let religiousAchievements = retrieveItemsWithFilter(type: ItemType.achievement.id, category: 0)
        
        if religiousAchievements.count == 60 {
            presentMedalPopUp(id: 8)
        } else if religiousAchievements.count == 100 {
            presentMedalPopUp(id: 9)
        }
    }
    
    static func checkForScientificAchievementMedals() {
        let scientificAchievement = retrieveItemsWithFilter(type: ItemType.achievement.id, category: 1)
        
        if scientificAchievement.count == 60 {
            presentMedalPopUp(id: 10)
        } else if scientificAchievement.count == 100 {
            presentMedalPopUp(id: 11)
        }
    }
    
    static func checkForHealthAchievementMedals() {
        let healthAchievement = retrieveItemsWithFilter(type: ItemType.achievement.id, category: 2)
        
        if healthAchievement.count == 60 {
            presentMedalPopUp(id: 22)
        } else if healthAchievement.count == 100 {
            presentMedalPopUp(id: 23)
        }
    }
    
    static func checkForSocialAchievementMedals() {
        let socialAchievement = retrieveItemsWithFilter(type: ItemType.achievement.id, category: 3)
        
        if socialAchievement.count == 60 {
            presentMedalPopUp(id: 12)
        } else if socialAchievement.count == 100 {
            presentMedalPopUp(id: 13)
        }
    }
    
    static func checkForCareerAchievementMedals() {
        let careerAchievement = retrieveItemsWithFilter(type: ItemType.achievement.id, category: 4)
        
        if careerAchievement.count == 60 {
            presentMedalPopUp(id: 24)
        } else if careerAchievement.count == 100 {
            presentMedalPopUp(id: 25)
        }
    }
    
    static func checkForPersonalAchievementMedals() {
        let personalAchievement = retrieveItemsWithFilter(type: ItemType.achievement.id, category: 5)
        
        if personalAchievement.count == 60 {
            presentMedalPopUp(id: 18)
        } else if personalAchievement.count == 100 {
            presentMedalPopUp(id: 19)
        }
    }
    
    static func checkForFinancialAchievementMedals() {
        let financialAchievement = retrieveItemsWithFilter(type: ItemType.achievement.id, category: 6)
        
        if financialAchievement.count == 60 {
            presentMedalPopUp(id: 20)
        } else if financialAchievement.count == 100 {
            presentMedalPopUp(id: 21)
        }
    }
    
    static func checkForFamilyAchievementMedals() {
        let familyAchievement = retrieveItemsWithFilter(type: ItemType.achievement.id, category: 7)
        
        if familyAchievement.count == 60 {
            presentMedalPopUp(id: 14)
        } else if familyAchievement.count == 100 {
            presentMedalPopUp(id: 15)
        }
    }
    
    static func checkForEntertainmentAchievementMedals() {
        let achievement = retrieveItemsWithFilter(type: ItemType.achievement.id, category: 8)
        
        if achievement.count == 60 {
            presentMedalPopUp(id: 16)
        } else if achievement.count == 100 {
            presentMedalPopUp(id: 17)
        }
    }
    
    
    static func checkForDailyGoals() {
        let goals = retrieveItemsWithFilter(type: ItemType.goal.id, category: nil)
        
        var threeDailyGoals = 100
        var tenDailyGoals = 100
        
        if goals.count >= 10 {
            tenDailyGoals =  Date.getNumberOfDaysBetween(Date(timeIntervalSince1970:goals[0].end_date), Date(timeIntervalSince1970:goals[9].end_date))!
        }
        
        if goals.count >= 3 {
            threeDailyGoals =  Date.getNumberOfDaysBetween(Date(timeIntervalSince1970:goals[0].end_date), Date(timeIntervalSince1970:goals[2].end_date))!
        }
        
        if threeDailyGoals == 0  && RealmManager.retrieveMedalEarnedById(id: 30) == false {
            presentMedalPopUp(id: 30)
        } else if tenDailyGoals == 0 && RealmManager.retrieveMedalEarnedById(id: 31) == false {
            presentMedalPopUp(id: 31)
        }
    }
    
    static func checkForWeaklyGoals() {
        let goals = retrieveItemsWithFilter(type: ItemType.goal.id, category: nil)
        
        var WeaklyGoals = 100
        
        if goals.count >= 70 {
            WeaklyGoals =  Date.getNumberOfDaysBetween(Date(timeIntervalSince1970:goals[0].date), Date(timeIntervalSince1970:goals[69].end_date))!
        }
        
        if WeaklyGoals <= 7  && RealmManager.retrieveMedalEarnedById(id: 32) == false {
            presentMedalPopUp(id: 32)
        }
    }
    
    static func firstItemAdded() {
        let itemsCount = RealmManager.retrieveItems().count
        
        if itemsCount == 1 {
            presentMedalPopUp(id: 1)
        }
    }
    
    static func checkForBlogsMedals() {
        let blog = UserDefaultsManager.blogs
        
        if blog?.count == 10 {
            presentMedalPopUp(id: 36)
        } else if blog?.count == 50 {
            presentMedalPopUp(id: 37)
        }
    }
    
    static func treeWateringMedals(tree: [TreeModel]) {
        let stageCount = tree.first?.stages.count
        
        let oneTreeMedal = RealmManager.retrieveMedalById(id: 27)
        let twoTreeMedal = RealmManager.retrieveMedalById(id: 28)
        let fiveTreeMedal = RealmManager.retrieveMedalById(id: 29)
        
        if tree.count == 1 && stageCount == 1 {
            presentMedalPopUp(id: 26)
        }
        
        if tree.count == 2 && oneTreeMedal?.earned == false {
            presentMedalPopUp(id: 27)
        }
        
        if tree.count == 3 && twoTreeMedal?.earned == false {
            presentMedalPopUp(id: 28)
        }
        
        if tree.count == 6 && fiveTreeMedal?.earned == false {
            presentMedalPopUp(id: 29)
        }
    }
}
