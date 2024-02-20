# Prática 4

Considere quatro sensores para um carro: um sensor de ignição, um sensor para o cinto de segurança, um sensor para os faróis e um sensor para as portas. Os estados dos sensores são definidos da seguinte forma:

Sensor Nível Alto Nível Baixo
Ignição Motor ligado Motor desligado
Cinto de segurança Travado Destravado
Faróis Ligados Desligados
Portas Fechadas Abertas

Deseja-se projetar um circuito combinacional que acione um alarme caso o motor esteja ligado e o cinto destravado ou as portas abertas, ou caso o motor esteja desligado e os faróis acesos. Inclua um display de 7 segmentos que irá mostrar a letra C caso o alarme venha da condição do cinto de segurança, a letra F caso o alarme venha da condição dos faróis e a letra P caso o alarme venha da condição das portas. A condição da porta terá prioridade sobre a condição do cintos.

Utilizar comando When-Else ou With-Select na solução proposta.

Projete o circuito lógico para solucionar o problema acima. Mostre passo a passo o processo.
Use linguagem VHDL para descrever o circuito. Verifique o funcionamento através do Waveform.
Configure o circuito no FPGA da placa DE0 e utilize o switches e display de 7 segmentos para verificar o funcionamento.
Monte e entregue o relatório segundo o modelo.
Atividade em dupla.