# Parameter - functional relationships
Parameters = {
'conc'     : {'dynamic':'model_glm_conc','params':['stim0', 'stim1', 'drift_1', 'drift_2', 'constant']},  
'gamma'    : 'fixed',
'sigma'    : 'fixed',
'eps'      : 'fixed',
'baseline' : 'fixed',
'Phi_0'    : 'fixed',
'Phi_1'    : 'fixed'
}

# Bounds on free fitted parameters
Bounds = {
'gamma' : (0,None),
'constant': (0, None)}

# Dynamic models
from numpy import dot

# concentration model
def model_glm_conc(p, t):
    return dot(t[:, [0, 1, 2, 3, 4]], p)

# concentration model gradients
def model_glm_conc_grad(p, t):
    return t[:, [0, 1, 2, 3, 4]].T                  






