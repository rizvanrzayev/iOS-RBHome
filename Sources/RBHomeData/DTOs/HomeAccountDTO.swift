import RBHomeDomain

struct HomeAccountListResponseDTO: Decodable {
    let allAccountList: [HomeAccountDTO]?
    enum CodingKeys: String, CodingKey {
        case allAccountList = "AllAccountList"
    }
}

struct HomeAccountDTO: Decodable {
    let accountNumber: String?
    let accountName: String?
    let iban: String?
    let amount: Double?
    let currency: String?
    let contractNumber: String?
    let isMortgage: Bool?
    let mortgageID: String?
    let birthDate: String?
    let calcDepositInterest: Double?

    enum CodingKeys: String, CodingKey {
        case accountNumber = "AccountNumber"
        case accountName = "AccountName"
        case iban = "Iban"
        case amount = "Amount"
        case currency = "Currency"
        case contractNumber = "ContractNumber"
        case isMortgage = "IsMortgage"
        case mortgageID = "MortgageId"
        case birthDate = "BirthDate"
        case calcDepositInterest = "CalcDepositInterest"
    }

    func toAccount() -> HomeAccount {
        HomeAccount(
            accountNumber: accountNumber ?? "",
            accountName: accountName ?? "",
            iban: iban ?? "",
            amount: amount ?? 0,
            currency: currency ?? ""
        )
    }

    func toLoan() -> HomeLoan {
        HomeLoan(
            contractNumber: contractNumber ?? accountNumber ?? "",
            accountName: accountName ?? "",
            amount: amount ?? 0,
            currency: currency ?? "",
            isMortgage: isMortgage ?? false,
            mortgageID: mortgageID ?? "",
            birthDate: birthDate ?? ""
        )
    }

    func toDeposit() -> HomeDeposit {
        HomeDeposit(
            accountNumber: accountNumber ?? "",
            accountName: accountName ?? "",
            amount: amount ?? 0,
            currency: currency ?? "",
            calcInterest: calcDepositInterest ?? 0
        )
    }
}
