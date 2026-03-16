import RBHomeDomain

struct HomeDTO: Decodable {
    let id: String
    let name: String

    func toEntity() -> HomeProfile {
        HomeProfile(id: id, name: name)
    }
}
