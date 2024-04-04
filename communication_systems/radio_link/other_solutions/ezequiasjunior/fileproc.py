# #!/usr/bin/env python3
# #%%
# import numpy as np
# import csv

# visada = np.zeros(2001)
# fresnel = np.zeros(2001)
# perfil = np.zeros(2001)
# dist = np.zeros(2001)
# with open('profile_demo.txt', 'r+') as f:
#     r = csv.reader(f, delimiter='\t')
#     r = list(r)
#     for i in range(len(r)):
#         perfil[i] = float(r[i][1])
#         dist[i] = float(r[i][0])
#         fresnel[i] = float(r[i][11])
#         visada[i] = float(r[i][9])

# #%%
# np.save('dist_igatemi_farol', dist)
# np.save('alturas_igatemi_farol', perfil)
# np.save('fresneltop', fresnel+visada)
# np.save('fresnelbot', -fresnel+visada)
# np.save('los', visada)