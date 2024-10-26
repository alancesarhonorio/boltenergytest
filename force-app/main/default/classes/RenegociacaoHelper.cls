public with sharing class RenegociacaoHelper {

    public static String processRenegociacao(RenegociacaoModel inputData) {
        Account account = [SELECT Id FROM Account WHERE CPF__c = :inputData.cpf LIMIT 1];
        if (account == null) {
            return 'Conta não encontrada para o CPF informado';
        }
        if (!isValidRenegociacao(inputData.valorTotal, inputData.parcelas)) {
            return 'Dados de renegociação inválidos. Verifique a quantidade de parcelas e o valor total';
        }

        Decimal valorParcela = calculateParcelaValue(inputData.valorTotal, inputData.parcelas);
        Renegociacao__c pedido = new Renegociacao__c(
            CPF__c = inputData.cpf,
            TotalRenegotiatedValue__c = inputData.valorTotal,
            NumberInstallments__c = inputData.parcelas,
            ValueEachInstallment__c = valorParcela,
            Account__c = account.Id
        );
        insert pedido;

        return 'Pedido de renegociação criado com sucesso';
    }

    private static Decimal calculateParcelaValue(Decimal valorTotal, Integer parcelas) {
        return valorTotal / parcelas;
    }

    private static Boolean isValidRenegociacao(Decimal valorTotal, Integer parcelas) {
        if (valorTotal < 500 && parcelas > 3) {
            return false;
        }
        if (parcelas > 6) {
            return false;
        }
        return true;
    }
}