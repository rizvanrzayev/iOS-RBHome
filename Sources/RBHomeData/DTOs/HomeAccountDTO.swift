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
    let nickname: String?
    let iban: String?
    let amount: Double?
    let currency: String?
    let accountType: String?
    let contractNumber: String?
    let isMortgage: Bool?
    let mortgageID: String?
    let birthDate: String?
    let calcDepositInterest: Double?

    enum CodingKeys: String, CodingKey {
        case accountNumber = "AccountNumber"
        case accountName = "AccountName"
        case nickname = "Nickname"
        case iban = "Iban"
        case amount = "Amount"
        case currency = "Currency"
        case accountType = "AccountType"
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
            nickname: nickname,
            iban: iban ?? "",
            amount: amount ?? 0,
            currency: currency ?? "",
            accountTypeRaw: accountType
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
            iban: iban ?? "",
            amount: amount ?? 0,
            currency: currency ?? "",
            calcInterest: calcDepositInterest ?? 0
        )
    }
}
