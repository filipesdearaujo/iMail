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
        "Agradecimento pela Compra": "Prezado cliente,\n\nAgradecemos por sua recente compra. Seu pedido está sendo processado\ncom o maior cuidado e será enviado em breve. Caso tenha dúvidas ou\nprecise de qualquer assistência, nossa equipe está à disposição para ajudar.\n\nAtenciosamente,\nEquipe de Atendimento ao Cliente.",
        
        "Renovação de Assinatura": "Olá,\n\nEstamos felizes em informar que sua assinatura foi renovada com sucesso.\nAgradecemos por continuar utilizando nossos serviços. Se precisar de ajuda\nou tiver alguma dúvida, por favor, entre em contato conosco.\n\nSinceramente,\nEquipe de Suporte.",
        
        "Solicitação de Suporte Recebida": "Caro usuário,\n\nSua solicitação de suporte foi recebida e nossa equipe está trabalhando para\nresolver o seu problema o mais rápido possível. Agradecemos pela paciência\ne compreensão.\n\nAtenciosamente,\nSuporte Técnico.",
        
        "Pagamento Aprovado": "Prezado cliente,\n\nSeu pagamento foi aprovado com sucesso. Seu pedido está sendo preparado\npara envio e você receberá uma notificação assim que for despachado.\nAgradecemos pela preferência.\n\nCordiais Saudações,\nEquipe de Faturamento.",
        
        "Cadastro Concluído": "Olá,\n\nEstamos entusiasmados em informar que seu cadastro foi concluído com sucesso.\nBem-vindo à nossa comunidade! Explore os recursos disponíveis e não hesite\nem nos contatar se precisar de assistência.\n\nMelhores Cumprimentos,\nEquipe de Suporte ao Cliente.",
        
        "Devolução Processada": "Caro cliente,\n\nSua devolução foi processada com sucesso e o reembolso será creditado em\nsua conta em até 7 dias úteis. Se tiver alguma dúvida, nossa equipe de\nsuporte está pronta para ajudar.\n\nAtenciosamente,\nEquipe de Devoluções.",
        
        "Plano Atualizado": "Prezado usuário,\n\nSeu plano foi atualizado com sucesso. Aproveite os novos recursos\ndisponíveis e, se tiver alguma dúvida, não hesite em entrar em\ncontato conosco.\n\nCom Cordialidade,\nEquipe de Atendimento.",
        
        "Reserva Confirmada": "Olá,\n\nSua reserva foi confirmada e estamos ansiosos para recebê-lo. Qualquer\nnecessidade adicional ou dúvida, por favor, entre em contato com nossa\nequipe.\n\nAtenciosamente,\nEquipe de Reservas.",
        
        "Atualização nos Termos de Serviço": "Caro cliente,\n\nInformamos que houve uma atualização em nossos termos de serviço.\nRecomendamos que você revise as mudanças visitando nosso site.\nObrigado por continuar utilizando nossos serviços.\n\nCordiais Saudações,\nEquipe de Atendimento ao Cliente.",
        
        "Cancelamento de Assinatura Recebido": "Prezado assinante,\n\nSeu pedido de cancelamento foi recebido e processado. Sentimos muito\nem vê-lo partir e esperamos poder atendê-lo novamente no futuro.\nCaso mude de ideia, estamos à disposição.\n\nSinceramente,\nEquipe de Atendimento.",
        
        "Boleto Gerado": "Olá,\n\nSeu boleto para pagamento foi gerado. Por favor, efetue o pagamento até\na data de vencimento para evitar qualquer interrupção nos serviços.\nQualquer dúvida, estamos aqui para ajudar.\n\nAtenciosamente,\nEquipe de Cobrança.",
        
        "Feedback Solicitado": "Caro cliente,\n\nSeu feedback é extremamente valioso para nós. Por favor, reserve um momento\npara responder à nossa pesquisa de satisfação. Agradecemos pela sua\ncolaboração.\n\nCordiais Saudações,\nEquipe de Atendimento ao Cliente.",
        
        "Senha Alterada": "Prezado usuário,\n\nSua senha foi alterada com sucesso. Se você não realizou essa alteração,\npor favor, entre em contato com nosso suporte imediatamente para garantir\na segurança da sua conta.\n\nAtenciosamente,\nEquipe de Suporte.",
        
        "Troca Aprovada": "Olá,\n\nSua solicitação de troca foi aprovada. Por favor, siga as instruções enviadas\npara enviar o produto de volta. Aguardamos o recebimento para continuar\ncom o processo.\n\nSinceramente,\nEquipe de Atendimento ao Cliente.",
        
        "Pedido Despachado": "Caro cliente,\n\nSeu pedido foi despachado e está a caminho. Você receberá um código de\nrastreamento em breve para acompanhar a entrega. Agradecemos pela\nconfiança.\n\nCom Cordialidade,\nEquipe de Logística.",
        
        "Agendamento Confirmado": "Prezado cliente,\n\nSeu agendamento foi confirmado. Estamos prontos para atendê-lo na data\ne horário marcados. Caso precise de alguma alteração, não hesite em\nnos contatar.\n\nAtenciosamente,\nEquipe de Agendamentos.",
        
        "Atualização de E-mail": "Olá,\n\nInformamos que seu e-mail foi atualizado em nosso sistema. Caso não tenha\nsolicitado essa alteração, por favor, entre em contato imediatamente para\nque possamos corrigir qualquer erro.\n\nAtenciosamente,\nEquipe de Suporte.",
        
        "Relatório Mensal Disponível": "Caro usuário,\n\nSeu relatório mensal está disponível em sua conta. Acesse para visualizar\nos detalhes e, se tiver alguma dúvida, nossa equipe está pronta para\najudar.\n\nCom Cordialidade,\nEquipe de Atendimento.",
        
        "Reembolso Aprovado": "Prezado cliente,\n\nSua solicitação de reembolso foi aprovada. O valor será creditado em sua\nconta nos próximos dias. Se precisar de mais informações, estamos à\ndisposição.\n\nAtenciosamente,\nEquipe de Atendimento.",
        
        "Conta Inativa": "Olá,\n\nSua conta está inativa há algum tempo. Sentimos sua falta! Volte a usar\nnossos serviços e descubra as novidades que preparamos para você.\n\nSinceramente,\nEquipe de Atendimento.",
        
        "Pagamento Pendente": "Caro cliente,\n\nInformamos que seu pagamento está pendente. Por favor, regularize sua\nsituação para evitar a suspensão do serviço. Estamos à disposição para\najudar com qualquer dúvida.\n\nAtenciosamente,\nEquipe de Cobrança.",
        
        "Avaliação Recebida": "Prezado usuário,\n\nSua avaliação foi recebida. Agradecemos por compartilhar sua opinião\nconosco e estamos sempre trabalhando para melhorar nossos serviços.\n\nCom Cordialidade,\nEquipe de Atendimento ao Cliente.",
        
        "Encomenda a Caminho": "Olá,\n\nSua encomenda está a caminho. Você pode acompanhar o status pelo link de\nrastreamento enviado anteriormente. Agradecemos pela sua preferência e\nconfiança.\n\nAtenciosamente,\nEquipe de Logística.",
        
        "Renovação de Plano Anual": "Caro cliente,\n\nInformamos que seu plano anual foi renovado. Aproveite os benefícios\nexclusivos e, se precisar de qualquer assistência, nossa equipe está\npronta para ajudar.\n\nSinceramente,\nEquipe de Atendimento.",
        
        "Tentativa de Login Suspeita": "Prezado assinante,\n\nHouve uma tentativa de login em sua conta de um novo dispositivo. Se não\nfoi você, por favor, altere sua senha imediatamente para garantir a\nsegurança.\n\nAtenciosamente,\nEquipe de Segurança.",
        
        "Assinatura Cancelada": "Olá,\n\nSua assinatura foi cancelada conforme solicitado. Lamentamos vê-lo partir\ne esperamos poder atendê-lo novamente no futuro. Qualquer dúvida, estamos\nà disposição.\n\nCordiais Saudações,\nEquipe de Atendimento.",
        
        "Alteração de Dados Processada": "Caro cliente,\n\nSeu pedido de alteração de dados foi processado com sucesso. Verifique as\ninformações atualizadas em sua conta e, se precisar de ajuda, estamos à\ndisposição.\n\nCom Cordialidade,\nEquipe de Atendimento ao Cliente.",
        
        "Mensagem de Boas-vindas": "Prezado novo cliente,\n\nBem-vindo à nossa comunidade! Estamos entusiasmados em tê-lo conosco. Aproveite\nos nossos serviços e sinta-se à vontade para explorar todos os recursos\ndisponíveis. Se precisar de qualquer assistência, nossa equipe está sempre\naqui para ajudar.\n\nAtenciosamente,\nEquipe de Atendimento ao Cliente.",
        
        "Confirmação de Pagamento": "Olá,\n\nSeu pagamento foi confirmado com sucesso. Estamos preparando sua encomenda\npara envio e você receberá uma notificação assim que for despachado. Agradecemos\npor sua confiança e preferência.\n\nSinceramente,\nEquipe de Faturamento.",
        
        "Informações de Entrega": "Caro cliente,\n\nSeu pedido está a caminho! Aqui estão as informações de entrega: Código de\nrastreamento: XXXX. Prazo estimado de entrega: 3-5 dias úteis. Se precisar\nde qualquer ajuda, nossa equipe de suporte está à disposição.\n\nAtenciosamente,\nEquipe de Logística.",
        
        "Atualização de Perfil": "Prezado usuário,\n\nInformamos que seu perfil foi atualizado com sucesso. Verifique as novas\ninformações e, se precisar de qualquer ajuste adicional, nossa equipe está\npronta para ajudar.\n\nCom Cordialidade,\nEquipe de Atendimento.",
        
        "Notificação de Segurança": "Olá,\n\nPara garantir a segurança da sua conta, recomendamos que você revise as\nconfigurações de segurança e altere sua senha regularmente. Se precisar\nde qualquer assistência, entre em contato com nosso suporte.\n\nAtenciosamente,\nEquipe de Segurança.",
        
        "Oferta Especial": "Prezado cliente,\n\nTemos uma oferta especial exclusiva para você! Descontos incríveis em\nnossos produtos. Não perca essa oportunidade. Visite nosso site para\naproveitar as promoções. Se precisar de ajuda, estamos à disposição.\n\nCom Cordialidade,\nEquipe de Vendas.",
        
        "Informações de Atualização": "Caro usuário,\n\nInformamos que uma nova atualização está disponível para o seu plano.\nAproveite os novos recursos e melhorias. Se precisar de ajuda, nossa\nequipe está pronta para auxiliar.\n\nAtenciosamente,\nEquipe de Suporte.",
        
        "Confirmação de Registro": "Olá,\n\nSeu registro foi confirmado com sucesso. Bem-vindo! Aproveite todos os\nrecursos disponíveis em nossa plataforma. Qualquer dúvida, estamos aqui\npara ajudar.\n\nCordiais Saudações,\nEquipe de Atendimento.",
        
        "Mensalidade Pendente": "Prezado cliente,\n\nInformamos que sua mensalidade está pendente. Por favor, efetue o pagamento\no quanto antes para evitar qualquer interrupção nos serviços. Se precisar\nde ajuda, nossa equipe de cobrança está à disposição.\n\nSinceramente,\nEquipe de Cobrança.",
        
        "Atualização de Sistema": "Caro usuário,\n\nInformamos que nosso sistema passará por uma atualização programada.\nDurante esse período, alguns serviços podem ficar temporariamente\nindisponíveis. Agradecemos pela compreensão.\n\nAtenciosamente,\nEquipe de Suporte Técnico.",
        
        "Confirmação de Agendamento": "Olá,\n\nSeu agendamento foi confirmado para a data e horário solicitados. Estamos\nansiosos para atendê-lo. Qualquer dúvida ou necessidade de alteração,\nentre em contato conosco.\n\nCordiais Saudações,\nEquipe de Atendimento.",
        
        "Promoção Exclusiva": "Prezado cliente,\n\nTemos uma promoção exclusiva para você! Descontos imperdíveis em nossos\nprodutos por tempo limitado. Visite nosso site para aproveitar. Qualquer\ndúvida, estamos à disposição.\n\nSinceramente,\nEquipe de Vendas.",
        
        "Reativação de Conta": "Caro usuário,\n\nSua conta foi reativada com sucesso. Bem-vindo de volta! Explore as\nnovidades e aproveite todos os recursos disponíveis. Se precisar de\nassistência, nossa equipe está pronta para ajudar.\n\nAtenciosamente,\nEquipe de Suporte.",
        
        "Confirmação de Inscrição": "Olá,\n\nSua inscrição foi confirmada com sucesso. Estamos felizes em tê-lo\nconosco. Acesse nossa plataforma e aproveite todos os benefícios.\nQualquer dúvida, estamos à disposição.\n\nSinceramente,\nEquipe de Atendimento.",
        
        "Notificação de Atualização": "Prezado cliente,\n\nInformamos que uma atualização importante foi realizada em nosso sistema.\nRecomendamos que você acesse sua conta para verificar as novidades. Se\nprecisar de ajuda, nossa equipe está pronta para auxiliar.\n\nCom Cordialidade,\nEquipe de Suporte Técnico.",
        
        "Novo Pedido Recebido": "Caro cliente,\n\nRecebemos seu novo pedido e estamos processando-o com prioridade. Você\nreceberá uma confirmação e código de rastreamento em breve. Agradecemos\npor sua preferência.\n\nAtenciosamente,\nEquipe de Atendimento.",
        
        "Aprovação de Crédito": "Prezado cliente,\n\nSeu crédito foi aprovado com sucesso. Agora você pode aproveitar nossos\nserviços com condições especiais. Se precisar de ajuda, nossa equipe está\npronta para auxiliar.\n\nCordiais Saudações,\nEquipe de Atendimento.",
        
        "Suspensão de Serviço": "Caro usuário,\n\nInformamos que seu serviço foi suspenso devido a um pagamento pendente.\nPor favor, regularize sua situação o quanto antes para reativar o serviço.\nQualquer dúvida, estamos à disposição.\n\nAtenciosamente,\nEquipe de Cobrança.",
        
        "Confirmação de Troca": "Olá,\n\nSua solicitação de troca foi confirmada. Por favor, siga as instruções\nenviadas para proceder com a troca do produto. Estamos à disposição\npara qualquer dúvida.\n\nSinceramente,\nEquipe de Atendimento.",
        
        "Relatório de Atividades": "Prezado cliente,\n\nSeu relatório de atividades está disponível para visualização em sua\nconta. Acesse para conferir os detalhes. Se precisar de ajuda, nossa\nequipe está pronta para auxiliar.\n\nCom Cordialidade,\nEquipe de Atendimento.",
        
        "Restabelecimento de Serviço": "Caro usuário,\n\nInformamos que seu serviço foi restabelecido. Agradecemos pela\ncompreensão durante o período de manutenção. Qualquer dúvida, estamos\nà disposição.\n\nAtenciosamente,\nEquipe de Suporte Técnico.",
        
        "Recebimento de Produto": "Prezado cliente,\n\nConfirmamos o recebimento do seu produto devolvido. Estamos processando\nseu pedido e você será notificado em breve sobre o andamento. Agradecemos\npela sua paciência.\n\nSinceramente,\nEquipe de Atendimento.",
        
        "Envio Confirmado": "Caro cliente,\n\nConfirmamos o envio do seu pedido. Você pode acompanhar o status pelo\ncódigo de rastreamento fornecido. Qualquer dúvida, estamos à disposição.\n\nAtenciosamente,\nEquipe de Logística.",
        
        "Recuperação de Senha": "Prezado usuário,\n\nRecebemos uma solicitação para recuperação de senha. Siga as instruções\nenviadas para redefinir sua senha. Se precisar de ajuda, nossa equipe\nde suporte está à disposição.\n\nCom Cordialidade,\nEquipe de Suporte.",
        
        "Informações de Assinatura": "Olá,\n\nInformamos que sua assinatura foi renovada automaticamente. Você pode\nverificar os detalhes e benefícios em sua conta. Qualquer dúvida,\nestamos à disposição.\n\nSinceramente,\nEquipe de Atendimento."
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

