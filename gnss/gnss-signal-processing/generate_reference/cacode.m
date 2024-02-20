function PRN=cacode(n)

%the  function PRN =cacode(n)
%returns the Gold code for GPS satellite ID n
%n=1...32
%the code is represented at levels :  1 for bit 0
%                                    -1 for bit 1

%phase assignments
phase=[2 6;3 7;4 8;5 9;1 9;2 10;1 8;2 9;3 10;2 3;3 4;5 6;6 7;7 8;8 9;9 10;
    1 4;2 5;3 6;4 7;5 8;6 9;1 3;4 6;5 7;6 8;7 9;8 10;1 6;2 7;3 8;4 9]; 
%initial state - all minus ones
G1=-1*ones(1,10);
G2=G1;

%select taps for G2 delay
s1=phase(n,1);
s2=phase(n,2);
tmp=0;
for i=1:1023;
    %Gold code
    G(i)=G2(s1)*G2(s2)*G1(10);
    %generator 1 - shift reg1 
    tmp=G1(1);
    G1(1)=G1(3)*G1(10);
    G1(2:10)=[tmp G1(2:9)];
    %generator 2 - shift reg2
    tmp=G2(1);
    G2(1)=G2(2)*G2(3)*G2(6)*G2(8)*G2(9)*G2(10);
    G2(2:10)=[tmp G2(2:9)];
    
end;%for

PRN=G;

