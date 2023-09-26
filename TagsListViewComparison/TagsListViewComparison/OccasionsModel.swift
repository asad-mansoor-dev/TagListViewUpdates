import Foundation
import ObjectMapper

class OccasionsModel : Mappable {
    var id : String?
    var name : String?
    var imageUrl : String?
    var createdAt : String?
    var updatedAt : String?
    var isActive : Bool?
    var isDeleted : Bool?
    
    typealias GetOccasionsCompletionHandler = ((_ products: [OccasionsModel]?, _ error: NSError?, _ status: Int?, _ message: String?) ->())
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        id <- map["id"]
        name <- map["name"]
        imageUrl <- map["imageUrl"]
        createdAt <- map["createdAt"]
        updatedAt <- map["updatedAt"]
        isActive <- map["isActive"]
        isDeleted <- map["isDeleted"]
    }
    
    class func fetchOccasions( _ completion: @escaping GetOccasionsCompletionHandler) {
       
                    completion(nil, nil,1, "")
          
    }
}
