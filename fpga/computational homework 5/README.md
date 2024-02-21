# Prática 5

- Use linguagem VHDL para descrever o circuito de controle de farol no arquivo em anexo.
- No bloco de controle utilizar função type e função case-when na implementação da máquina de estados.
- Verifique o funcionamento através do Waveform.
- Configure o circuito no FPGA da placa DE0 e utilizando switches e leds para representar as entras e saídas.
- Monte e entregue o relatório segundo o modelo.
- Atividade em dupla.


Code provided by the Professor:


```vhdl
ENTITY traffic_control IS
PORT (clock, car, reset                    :         IN BIT;
        tmaingrn, tsidegrn                :         IN INTEGER RANGE 0 TO 15;
        light                                    :        INOUT INTEGER RANGE 0 TO 3;
        change                                :        INOUT BIT;
        mainred, mainyellow, maingrn    :        OUT BIT;
        sidered, sideyellow,sidegrn    :        OUT BIT);
END traffic_control;
        
ARCHITECTURE top_level OF traffic_control IS 

COMPONENT delay
    PORT (clock, car, reset        :        IN BIT;
            light                        :        IN INTEGER RANGE 0 TO 3;
            tmaingrn, tsidegrn    :        IN INTEGER RANGE 0 TO 3;
            change                    :        OUT BIT);
END COMPONENT;

COMPONENT control 
    PORT  (clock, enable, reset:        IN BIT;
             light                    :         OUT INTEGER RANGE 0 TO 3);
END COMPONENT;

COMPONENT light_control
    PORT (light
            mainred, mainyellow, maingrn    :        OUT BIT;
            sidered, sideyellow,sidegrn    :        OUT BIT);
END COMPONENT;

BEGIN

modulo1: delay PORT MAP     (clock, car, reset, light,tmaingrn,tsidegrn,change);

module2: control PORT MAP (clock, change,reset);

module3: light_control PORT MAP (light, mainred, mainyellow, maingrn, sidered, sideyellow, sidegrn);

END top_level;
```