% Routines for opening audio files and convert them to feature vectors
% by means of periodogram.
%
% Last modification: 20/01/2022
% Author: Guilherme Barreto

clear; clc; close all

%pkg load image

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Fase 1 -- Carrega arquivo de audio disponiveis
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
part1 = 'comando_';
part2 = {'avancar_0' 'direita_0' 'esquerda_0' 'parar_0' 'recuar_0'};
part3 = char(part2);
part4 = '.wav';

Ncom=5;   % Quantidade de comandos
Nreal=10;  % Quantidade de realizacoes

X=[];   % Matriz de dados (vetores de atributos)
Y=[];   % Matriz de rotulos (one-hot encoding);

for i=1:Ncom  % Indice para os comandos
    for j=1:Nreal   % Indice para expressoes
        nome = strcat('./Audio_files_TCC_Jefferson/', part1,part3(i,:),int2str(j),part4);    % Monta o nome do arquivo de audio
        
        [sinal, Fs]=audioread(nome);
        
        % Etapa 2: SUBAMOSTRAGEM
        N=length(sinal);
        sinal1=sinal(:,1);   % sinal original canal 1
        sinal2=sinal(:,2);   % sinal original canal 2
        
        Ipar=2:2:N;
        Iimpar=1:2:N-1;
        
        sinal1a = sinal1(Iimpar);  % 1o. sinal subamostrado do canal 1
        sinal1b = sinal1(Ipar);    % 2o. sinal subamostrado do canal 1
        sinal2a = sinal2(Iimpar);  % 1o. sinal subamostrado do canal 2
        sinal2b = sinal2(Ipar);    % 2o. sinal subamostrado do canal 2
        
        % Etapa 3: PERIODOGRAMA
        [P1a, ~]=periodogram(sinal1a,[],[],Fs/2);
        [P1b, ~]=periodogram(sinal1b,[],[],Fs/2);
        [P2a, ~]=periodogram(sinal2a,[],[],Fs/2);
        [P2b, W]=periodogram(sinal2b,[],[],Fs/2);
%         figure; plot(W,P1a);
        
        % Etapa 4: GERAR VETORES DE ATRIBUTOS
        % limite inferior
        Li=[0 100 200 360 500 700 850 1000 1200 1320 1500 2200 2700];
        % limite superior
        Ls=[Li(2:end) 3700];
        
        % Monta vetor de atributos a partir dos periodogramas
        Nint=length(Li);  % No. de faixas de frequencias escolhidas
        for l=1:Nint
            I=find(W>=Li(l) & W<=Ls(l));   % l-esima banda de frequencia
            x1a(l)=max(P1a(I));    % Pega maior potencia dentro da l-esima
            x1b(l)=max(P1b(I));    % Pega maior potencia dentro da l-esima
            x2a(l)=max(P2a(I));    % Pega maior potencia dentro da l-esima
            x2b(l)=max(P2b(I));    % Pega maior potencia dentro da l-esima
        end
        
        X=[X x1a(:) x1b(:) x2a(:) x2b(:)];
        ROT=zeros(Ncom,1); ROT(i)=1;  % Cria rotulo binario do vetor de atributos (one-hot encoding)
        Y=[Y ROT ROT ROT ROT];
    end
end

save spd.mat X Y

% save -ascii comandos_input.txt X
% save -ascii comandos_output.txt Y