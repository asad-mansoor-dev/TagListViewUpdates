import Foundation
import ObjectMapper
typealias GetCategoriesCompletionHandler = ((_ products: [Categories]?, _ error: NSError?, _ status: Int?, _ message: String?) ->())
class Categories : Mappable {
    
	var id : String?
	var name : String?
	var createdAt : String?
	var updatedAt : String?
	var isActive : Bool?
	var isDeleted : Bool?
    var imageUrl : String?

	required init?(map: Map) {

	}

	func mapping(map: Map) {

		id <- map["id"]
		name <- map["name"]
		createdAt <- map["createdAt"]
		updatedAt <- map["updatedAt"]
		isActive <- map["isActive"]
		isDeleted <- map["isDeleted"]
        imageUrl <- map["imageUrl"]
	}
    
    class func fetchCategories( _ completion: @escaping GetCategoriesCompletionHandler) {
                completion(nil, nil,1, "")
            }

}
