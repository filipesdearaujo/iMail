//import UIKit
//import CoreData
//
//class EmailRandomGenerator {
//    static let shared = EmailRandomGenerator()
//    
//    private init() {}
//    
//    private let domains = [
//        "example.com", "test.com", "fake.com", "demo.com", "sample.com", "mock.com",
//        "mail.com", "email.com", "webmail.com", "inbox.com", "myemail.com", "yourmail.com",
//        "coolmail.com", "hitechmail.com", "fastmail.com", "securemail.com", "privatemail.com",
//        "protonmail.com", "tutanota.com", "post.com", "netmail.com", "mymail.com", "quickmail.com",
//        "safemail.com", "mailbox.com", "cloudmail.com", "supermail.com", "easymail.com", "onlinemail.com",
//        "webemail.com", "virtualmail.com", "modernmail.com", "directmail.com", "freemail.com", "nowmail.com",
//        "trustedmail.com", "mailsafe.com", "mailsecure.com", "openmail.com", "simplemail.com", "newmail.com",
//        "globalmail.com", "networkmail.com", "instantmail.com", "internetmail.com", "mailservice.com", "usermail.com",
//        "hostmail.com", "domainmail.com"
//    ]
//    
//    private let names = [
//        "Ana", "Bruno", "Carla", "Daniel", "Eduarda", "Felipe", "Gabriela", "Henrique", "Isabela", "João",
//        "Karla", "Lucas", "Mariana", "Nicolas", "Olivia", "Pedro", "Quintino", "Raquel", "Sofia", "Tiago",
//        "Ursula", "Vitor", "Wesley", "Ximena", "Yago", "Zilda", "Amanda", "Brenda", "César", "Diana",
//        "Evandro", "Fernanda", "Gustavo", "Helena", "Igor", "Julia", "Kevin", "Larissa", "Marcelo",
//        "Natália", "Otávio", "Patrícia", "Rafael", "Simone", "Túlio", "Vanessa", "Wagner", "Yasmin", "Zé"
//    ]
//    
//    private let messages: [String: String] = [
//        "Agradecimento pela Compra": "Prezado cliente, agradecemos por sua recente compra. Seu pedido está sendo processado com o maior cuidado e será enviado em breve. Caso tenha dúvidas ou precise de qualquer assistência, nossa equipe está à disposição para ajudar.",
//        "Renovação de Assinatura": "Olá, estamos felizes em informar que sua assinatura foi renovada com sucesso. Agradecemos por continuar utilizando nossos serviços. Se precisar de ajuda ou tiver alguma dúvida, por favor, entre em contato conosco.",
//        "Solicitação de Suporte Recebida": "Caro usuário, sua solicitação de suporte foi recebida e nossa equipe está trabalhando para resolver o seu problema o mais rápido possível. Agradecemos pela paciência e compreensão.",
//        "Pagamento Aprovado": "Prezado cliente, seu pagamento foi aprovado com sucesso. Seu pedido está sendo preparado para envio e você receberá uma notificação assim que for despachado. Agradecemos pela preferência.",
//        "Cadastro Concluído": "Olá, estamos entusiasmados em informar que seu cadastro foi concluído com sucesso. Bem-vindo à nossa comunidade! Explore os recursos disponíveis e não hesite em nos contatar se precisar de assistência.",
//        "Devolução Processada": "Caro cliente, sua devolução foi processada com sucesso e o reembolso será creditado em sua conta em até 7 dias úteis. Se tiver alguma dúvida, nossa equipe de suporte está pronta para ajudar.",
//        "Plano Atualizado": "Prezado usuário, seu plano foi atualizado com sucesso. Aproveite os novos recursos disponíveis e, se tiver alguma dúvida, não hesite em entrar em contato conosco.",
//        "Reserva Confirmada": "Olá, sua reserva foi confirmada e estamos ansiosos para recebê-lo. Qualquer necessidade adicional ou dúvida, por favor, entre em contato com nossa equipe.",
//        "Atualização nos Termos de Serviço": "Caro cliente, informamos que houve uma atualização em nossos termos de serviço. Recomendamos que você revise as mudanças visitando nosso site. Obrigado por continuar utilizando nossos serviços.",
//        "Cancelamento de Assinatura Recebido": "Prezado assinante, seu pedido de cancelamento foi recebido e processado. Sentimos muito em vê-lo partir e esperamos poder atendê-lo novamente no futuro. Caso mude de ideia, estamos à disposição.",
//        "Boleto Gerado": "Olá, seu boleto para pagamento foi gerado. Por favor, efetue o pagamento até a data de vencimento para evitar qualquer interrupção nos serviços. Qualquer dúvida, estamos aqui para ajudar.",
//        "Feedback Solicitado": "Caro cliente, seu feedback é extremamente valioso para nós. Por favor, reserve um momento para responder à nossa pesquisa de satisfação. Agradecemos pela sua colaboração.",
//        "Senha Alterada": "Prezado usuário, sua senha foi alterada com sucesso. Se você não realizou essa alteração, por favor, entre em contato com nosso suporte imediatamente para garantir a segurança da sua conta.",
//        "Troca Aprovada": "Olá, sua solicitação de troca foi aprovada. Por favor, siga as instruções enviadas para enviar o produto de volta. Aguardamos o recebimento para continuar com o processo.",
//        "Pedido Despachado": "Caro cliente, seu pedido foi despachado e está a caminho. Você receberá um código de rastreamento em breve para acompanhar a entrega. Agradecemos pela confiança.",
//        "Agendamento Confirmado": "Prezado cliente, seu agendamento foi confirmado. Estamos prontos para atendê-lo na data e horário marcados. Caso precise de alguma alteração, não hesite em nos contatar.",
//        "Atualização de E-mail": "Olá, informamos que seu e-mail foi atualizado em nosso sistema. Caso não tenha solicitado essa alteração, por favor, entre em contato imediatamente para que possamos corrigir qualquer erro.",
//        "Relatório Mensal Disponível": "Caro usuário, seu relatório mensal está disponível em sua conta. Acesse para visualizar os detalhes e, se tiver alguma dúvida, nossa equipe está pronta para ajudar.",
//        "Reembolso Aprovado": "Prezado cliente, sua solicitação de reembolso foi aprovada. O valor será creditado em sua conta nos próximos dias. Se precisar de mais informações, estamos à disposição.",
//        "Conta Inativa": "Olá, sua conta está inativa há algum tempo. Sentimos sua falta! Volte a usar nossos serviços e descubra as novidades que preparamos para você.",
//        "Pagamento Pendente": "Caro cliente, informamos que seu pagamento está pendente. Por favor, regularize sua situação para evitar a suspensão do serviço. Estamos à disposição para ajudar com qualquer dúvida.",
//        "Avaliação Recebida": "Prezado usuário, sua avaliação foi recebida. Agradecemos por compartilhar sua opinião conosco e estamos sempre trabalhando para melhorar nossos serviços.",
//        "Encomenda a Caminho": "Olá, sua encomenda está a caminho. Você pode acompanhar o status pelo link de rastreamento enviado anteriormente. Agradecemos pela sua preferência e confiança.",
//        "Renovação de Plano Anual": "Caro cliente, informamos que seu plano anual foi renovado. Aproveite os benefícios exclusivos e, se precisar de qualquer assistência, nossa equipe está pronta para ajudar.",
//        "Tentativa de Login Suspeita": "Prezado assinante, houve uma tentativa de login em sua conta de um novo dispositivo. Se não foi você, por favor, altere sua senha imediatamente para garantir a segurança.",
//        "Assinatura Cancelada": "Olá, sua assinatura foi cancelada conforme solicitado. Lamentamos vê-lo partir e esperamos poder atendê-lo novamente no futuro. Qualquer dúvida, estamos à disposição.",
//        "Alteração de Dados Processada": "Caro cliente, seu pedido de alteração de dados foi processado com sucesso. Verifique as informações atualizadas em sua conta e, se precisar de ajuda, estamos à disposição."
//    ]
//    
//    func generateRandomEmailAddress() -> String {
//        let randomName = names.randomElement()!
//        let randomDomain = domains.randomElement()!
//        return "\(randomName.lowercased())@\(randomDomain)"
//    }
//
//    func generateRandomDate() -> Date {
//        let startDate = DateFormatter.dateFromString("01/01/2024 00:00")!
//        let interval = TimeInterval.random(in: 0...365*24*60*60)
//        return startDate.addingTimeInterval(interval)
//    }
//
//    func fetchEmail() -> String? {
//        guard let context = getContext() else { return nil }
//        
//        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Person")
//        
//        do {
//            let result = try context.fetch(fetchRequest)
//            return result.first?.value(forKey: "email") as? String
//        } catch {
//            print("Failed to fetch email: \(error)")
//            return nil
//        }
//    }
//
//    func fetchIndex() -> Float {
//        guard let context = getContext() else { return 0 }
//
//        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Emails")
//        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "index", ascending: false)]
//        fetchRequest.fetchLimit = 1
//
//        do {
//            let result = try context.fetch(fetchRequest)
//            if let lastEmail = result.first, let lastIndex = lastEmail.value(forKey: "index") as? Float {
//                return lastIndex + 1
//            } else {
//                return 0
//            }
//        } catch {
//            print("Failed to fetch index: \(error)")
//            return 0
//        }
//    }
//
//    func getRandomMessage() -> (subject: String, message: String) {
//        let randomMessage = messages.randomElement()!
//        return (randomMessage.key, randomMessage.value)
//    }
//    
//    private func getContext() -> NSManagedObjectContext? {
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
//        return appDelegate.persistentContainer.viewContext
//    }
//}
//
//private extension DateFormatter {
//    static func dateFromString(_ date: String) -> Date? {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "dd/MM/yyyy HH:mm"
//        return formatter.date(from: date)
//    }
//}

import UIKit
import CoreData

class EmailRandomGenerator {
    static let shared = EmailRandomGenerator()
    
    private init() {}
    
    private let domains = [
        "example.com", "test.com", "fake.com", "demo.com", "sample.com", "mock.com",
        "mail.com", "email.com", "webmail.com", "inbox.com", "myemail.com", "yourmail.com",
        "coolmail.com", "hitechmail.com", "fastmail.com", "securemail.com", "privatemail.com",
        "protonmail.com", "tutanota.com", "post.com", "netmail.com", "mymail.com", "quickmail.com",
        "safemail.com", "mailbox.com", "cloudmail.com", "supermail.com", "easymail.com", "onlinemail.com",
        "webemail.com", "virtualmail.com", "modernmail.com", "directmail.com", "freemail.com", "nowmail.com",
        "trustedmail.com", "mailsafe.com", "mailsecure.com", "openmail.com", "simplemail.com", "newmail.com",
        "globalmail.com", "networkmail.com", "instantmail.com", "internetmail.com", "mailservice.com", "usermail.com",
        "hostmail.com", "domainmail.com"
    ]

    private let names = [
        "Ana", "Bruno", "Carla", "Daniel", "Eduarda", "Felipe", "Gabriela", "Henrique", "Isabela", "João",
        "Karla", "Lucas", "Mariana", "Nicolas", "Olivia", "Pedro", "Quintino", "Raquel", "Sofia", "Tiago",
        "Ursula", "Vitor", "Wesley", "Ximena", "Yago", "Zilda", "Amanda", "Brenda", "César", "Diana",
        "Evandro", "Fernanda", "Gustavo", "Helena", "Igor", "Julia", "Kevin", "Larissa", "Marcelo",
        "Natália", "Otávio", "Patrícia", "Rafael", "Simone", "Túlio", "Vanessa", "Wagner", "Yasmin", "Zé"
    ]

    private let messages: [String: String] = [
        "Agradecimento pela Compra": "Prezado cliente, agradecemos por sua recente compra. Seu pedido está sendo processado com o maior cuidado e será enviado em breve. Caso tenha dúvidas ou precise de qualquer assistência, nossa equipe está à disposição para ajudar.",
        "Renovação de Assinatura": "Olá, estamos felizes em informar que sua assinatura foi renovada com sucesso. Agradecemos por continuar utilizando nossos serviços. Se precisar de ajuda ou tiver alguma dúvida, por favor, entre em contato conosco.",
        "Solicitação de Suporte Recebida": "Caro usuário, sua solicitação de suporte foi recebida e nossa equipe está trabalhando para resolver o seu problema o mais rápido possível. Agradecemos pela paciência e compreensão.",
        "Pagamento Aprovado": "Prezado cliente, seu pagamento foi aprovado com sucesso. Seu pedido está sendo preparado para envio e você receberá uma notificação assim que for despachado. Agradecemos pela preferência.",
        "Cadastro Concluído": "Olá, estamos entusiasmados em informar que seu cadastro foi concluído com sucesso. Bem-vindo à nossa comunidade! Explore os recursos disponíveis e não hesite em nos contatar se precisar de assistência.",
        "Devolução Processada": "Caro cliente, sua devolução foi processada com sucesso e o reembolso será creditado em sua conta em até 7 dias úteis. Se tiver alguma dúvida, nossa equipe de suporte está pronta para ajudar.",
        "Plano Atualizado": "Prezado usuário, seu plano foi atualizado com sucesso. Aproveite os novos recursos disponíveis e, se tiver alguma dúvida, não hesite em entrar em contato conosco.",
        "Reserva Confirmada": "Olá, sua reserva foi confirmada e estamos ansiosos para recebê-lo. Qualquer necessidade adicional ou dúvida, por favor, entre em contato com nossa equipe.",
        "Atualização nos Termos de Serviço": "Caro cliente, informamos que houve uma atualização em nossos termos de serviço. Recomendamos que você revise as mudanças visitando nosso site. Obrigado por continuar utilizando nossos serviços.",
        "Cancelamento de Assinatura Recebido": "Prezado assinante, seu pedido de cancelamento foi recebido e processado. Sentimos muito em vê-lo partir e esperamos poder atendê-lo novamente no futuro. Caso mude de ideia, estamos à disposição.",
        "Boleto Gerado": "Olá, seu boleto para pagamento foi gerado. Por favor, efetue o pagamento até a data de vencimento para evitar qualquer interrupção nos serviços. Qualquer dúvida, estamos aqui para ajudar.",
        "Feedback Solicitado": "Caro cliente, seu feedback é extremamente valioso para nós. Por favor, reserve um momento para responder à nossa pesquisa de satisfação. Agradecemos pela sua colaboração.",
        "Senha Alterada": "Prezado usuário, sua senha foi alterada com sucesso. Se você não realizou essa alteração, por favor, entre em contato com nosso suporte imediatamente para garantir a segurança da sua conta.",
        "Troca Aprovada": "Olá, sua solicitação de troca foi aprovada. Por favor, siga as instruções enviadas para enviar o produto de volta. Aguardamos o recebimento para continuar com o processo.",
        "Pedido Despachado": "Caro cliente, seu pedido foi despachado e está a caminho. Você receberá um código de rastreamento em breve para acompanhar a entrega. Agradecemos pela confiança.",
        "Agendamento Confirmado": "Prezado cliente, seu agendamento foi confirmado. Estamos prontos para atendê-lo na data e horário marcados. Caso precise de alguma alteração, não hesite em nos contatar.",
        "Atualização de E-mail": "Olá, informamos que seu e-mail foi atualizado em nosso sistema. Caso não tenha solicitado essa alteração, por favor, entre em contato imediatamente para que possamos corrigir qualquer erro.",
        "Relatório Mensal Disponível": "Caro usuário, seu relatório mensal está disponível em sua conta. Acesse para visualizar os detalhes e, se tiver alguma dúvida, nossa equipe está pronta para ajudar.",
        "Reembolso Aprovado": "Prezado cliente, sua solicitação de reembolso foi aprovada. O valor será creditado em sua conta nos próximos dias. Se precisar de mais informações, estamos à disposição.",
        "Conta Inativa": "Olá, sua conta está inativa há algum tempo. Sentimos sua falta! Volte a usar nossos serviços e descubra as novidades que preparamos para você.",
        "Pagamento Pendente": "Caro cliente, informamos que seu pagamento está pendente. Por favor, regularize sua situação para evitar a suspensão do serviço. Estamos à disposição para ajudar com qualquer dúvida.",
        "Avaliação Recebida": "Prezado usuário, sua avaliação foi recebida. Agradecemos por compartilhar sua opinião conosco e estamos sempre trabalhando para melhorar nossos serviços.",
        "Encomenda a Caminho": "Olá, sua encomenda está a caminho. Você pode acompanhar o status pelo link de rastreamento enviado anteriormente. Agradecemos pela sua preferência e confiança.",
        "Renovação de Plano Anual": "Caro cliente, informamos que seu plano anual foi renovado. Aproveite os benefícios exclusivos e, se precisar de qualquer assistência, nossa equipe está pronta para ajudar.",
        "Tentativa de Login Suspeita": "Prezado assinante, houve uma tentativa de login em sua conta de um novo dispositivo. Se não foi você, por favor, altere sua senha imediatamente para garantir a segurança.",
        "Assinatura Cancelada": "Olá, sua assinatura foi cancelada conforme solicitado. Lamentamos vê-lo partir e esperamos poder atendê-lo novamente no futuro. Qualquer dúvida, estamos à disposição.",
        "Alteração de Dados Processada": "Caro cliente, seu pedido de alteração de dados foi processado com sucesso. Verifique as informações atualizadas em sua conta e, se precisar de ajuda, estamos à disposição."
    ]
    
    func generateRandomEmailAddress() -> String {
        let randomName = names.randomElement()!
        let randomDomain = domains.randomElement()!
        return "\(randomName.lowercased())@\(randomDomain)"
    }

    func generateRandomDate() -> Date {
        let startDate = DateFormatter.dateFromString("01/01/2024 00:00")!
        let interval = TimeInterval.random(in: 0...365*24*60*60)
        return startDate.addingTimeInterval(interval)
    }

    func fetchEmail() -> String? {
        guard let context = getContext() else { return nil }
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Person")
        
        do {
            let result = try context.fetch(fetchRequest)
            return result.first?.value(forKey: "email") as? String
        } catch {
            print("Failed to fetch email: \(error)")
            return nil
        }
    }

    func fetchIndex() -> Float {
        guard let context = getContext() else { return 0 }

        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Emails")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "index", ascending: false)]
        fetchRequest.fetchLimit = 1

        do {
            let result = try context.fetch(fetchRequest)
            if let lastEmail = result.first, let lastIndex = lastEmail.value(forKey: "index") as? Float {
                return lastIndex + 1
            } else {
                return 0
            }
        } catch {
            print("Failed to fetch index: \(error)")
            return 0
        }
    }

    func createRandomEmail() {
        guard let context = getContext() else { return }

        let entity = NSEntityDescription.entity(forEntityName: "Emails", in: context)!
        let email = NSManagedObject(entity: entity, insertInto: context)
        
        email.setValue(generateRandomEmailAddress(), forKey: "sender")
        email.setValue(generateRandomEmailAddress(), forKey: "to")
        email.setValue(generateRandomDate(), forKey: "date")
        email.setValue(fetchIndex(), forKey: "index")
        email.setValue("usuarioRecebeu", forKey: "topic")
        print(email.value(forKey: "topic")!)
        
        let message = getRandomMessage()
        email.setValue(message.subject, forKey: "subject")
        email.setValue(message.message, forKey: "message")
        
        do {
            try context.save()
        } catch {
            print("Failed to save email: \(error)")
        }
    }

    func getRandomMessage() -> (subject: String, message: String) {
        let randomMessage = messages.randomElement()!
        return (randomMessage.key, randomMessage.value)
    }
    
    private func getContext() -> NSManagedObjectContext? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        return appDelegate.persistentContainer.viewContext
    }
}

private extension DateFormatter {
    static func dateFromString(_ date: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy HH:mm"
        return formatter.date(from: date)
    }
}

