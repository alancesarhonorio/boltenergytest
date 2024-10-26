@RestResource(urlMapping='/renegociacao')
global with sharing class RenegociacaoService {

    @HttpPost
    global static String createRenegociacao() {
        try {
            
            String requestBody = RestContext.request.requestBody.toString();
            Map<String, Object> dataMap = (Map<String, Object>) JSON.deserializeUntyped(requestBody);

            RenegociacaoModel inputData = new RenegociacaoModel();
            inputData.cpf = (String) dataMap.get('cpf');
            inputData.valorTotal = (Decimal) dataMap.get('valorTotal');
            inputData.parcelas = ((Double) dataMap.get('parcelas')).intValue(); // Convertendo Double para Integer

            return RenegociacaoHelper.processRenegociacao(inputData);
        } catch (Exception e) {
            System.debug('Erro ao processar a renegociação: ' + e.getMessage());
            return 'Erro ao criar o pedido de renegociação';
        }
    }
}