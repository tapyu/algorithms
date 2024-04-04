from cvxopt.modeling import variable, op

VI = 60 # volume inicial
AFL = 100 # afluente

gt = variable(2, 'Geração Térmica')
vf = variable(1, 'Volume Final')
vt = variable(1, 'Volume Turbinado')
vv = variable(1, 'Volume Vertido')
defict = variable(1, 'Deficit')

fob = 10*gt[0] + 25*gt[1] + 500*defict[0] + 0.001*vv[0] # fução objetivo

restricoes = [
    vf[0] == VI + AFL - vt[0] - vv[0],
    0.95+vt[0] + gt[0] + gt[1] + defict[0] == 50,
    gt[0] >= 0,
    gt[1] >= 0,
    vt[0] >= 0,
    vv[0] >= 0,
    defict[0] >= 0,
    vf[0] >= 20,

    gt[0] <= 15,
    gt[1] <= 10,
    vt[0] <= 60,
    vf[0] <= 100
]

despacho = op(fob, restricoes)

despacho.solve('dense', 'glpk') # glpk -> GNU Linear Programming Kit (the solver); dense -> matriz densa

print(despacho.status)

for i, var_dec in enumerate(gt):
    print(f"O defict é {defict[0].value()[0]}")
    print(f"A geração térmica é {var_dec[0].value()[0]}")
    print(f"O volume vertido é {vv[0].value()[0]}")
    print(f"O volume final é {vf[0].value()[0]}")