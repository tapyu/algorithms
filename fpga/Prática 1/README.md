# Problema

Suponha que você deseja projetar um sistema para controlar uma porta de correr automática, como as que podem ser encontradas nas entradas de algumas lojas. Em nosso sistema, uma entrada p indica se um sensor detectou a presença de uma pessoa à frente da porta (p = 1 significa que uma pessoa foi detectada). Uma entrada h indica se a porta deve permanecer aberta manualmente (h = 1) independentemente da detecção ou não da presença de uma pessoa. Uma entrada c = 1 significa que a porta deve permanecer fechada. Normalmente, estes últimos casos seriam acionados por um gerente autorizado. Uma saída f abre a porta quando f é 1. Queremos abrir a porta quanto ela está sendo acionada manualmente para ser mantida aberta, ou (OR) quando a porta não está sendo mantida aberta manualmente, mas uma pessoa está sendo detectada. Entretanto, em ambos esses casos, somente abriremos a porta se ela não estiver sendo acionada para permanecer fechada.

Projete o circuito lógico para solucionar o problema acima. Mostre passo a passo o processo.
Use linguagem VHDL para descrever o circuito. Verifique o funcionamento através do Waveform.
Configure o circuito no FPGA da placa DE0 e utilize o switches e leds para verificar o funcionamento.
Monte e entregue o relatório.