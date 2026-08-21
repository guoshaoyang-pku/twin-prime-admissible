import pickle, sys, math
sys.path.insert(0,'.')
from gmpy2 import mpq
k, D, en, ed = int(sys.argv[1]), int(sys.argv[2]), int(sys.argv[3]), int(sys.argv[4])
with open(f'frac_cache_{k}_{D}_e{en}_{ed}.pkl','rb') as f: I,J1 = pickle.load(f)
n=len(I); print('n =', n, flush=True)
exec(open('eps_scan.py').read().split('def main')[0])
eps = en/ed
parts = gen_even_partitions(D)
basis=[]
for g in parts:
    dg=sum(g)
    for r in range(0,D-dg+1): basis.append((r,g))
H_cache={}
for coords in (k,k-1):
    for g in parts: H_of_float(list(g),coords,H_cache)
    for g in parts:
        for dl in parts: H_of_float(list(sorted(g+dl)),coords,H_cache)
fac={m2:math.factorial(m2) for m2 in range(0,2*D+100)}
c1,c2=1.0-eps,2.0*eps; e1=1.0+eps
splits={g:split_a(list(g)) for g in parts}
maxerrI=maxerrJ=0
for ia,(r1,alpha) in enumerate(basis):
    for ib,(r2,beta) in enumerate(basis):
        gamma=multiset_key(tuple(sorted(alpha+beta))); deg=sum(gamma); rr=r1+r2
        fI = e1**(k+deg+rr)*fac[rr]*H_of_float(list(gamma),k,H_cache)/fac[k+rr+deg]
        exI = float(mpq(I[ia][ib].numerator, I[ia][ib].denominator))
        if abs(exI)>1e-320: maxerrI=max(maxerrI,abs(fI-exI)/abs(exI))
        tot=0.0
        for ca,Sa,ga in splits[alpha]:
            Ba=fac[r1]*fac[Sa]/fac[r1+Sa+1]
            for cb,Sb,gb in splits[beta]:
                Bb=fac[r2]*fac[Sb]/fac[r2+Sb+1]
                mu=multiset_key(tuple(sorted(ga+gb))); dmu=sum(mu); s=rr+2+Sa+Sb
                G=sum(math.comb(s,j)*c1**j*c2**(s-j)*fac[j]/fac[k-1+j+dmu] for j in range(s+1))
                tot+=ca*cb*Ba*Bb*c1**(k-1+dmu)*H_of_float(list(mu),k-1,H_cache)*G
        exJ = float(mpq(J1[ia][ib].numerator, J1[ia][ib].denominator))
        if abs(exJ)>1e-320: maxerrJ=max(maxerrJ,abs(tot-exJ)/abs(exJ))
print(f'k={k} D={D} eps={en}/{ed}: max rel err I = {maxerrI}  J1 = {maxerrJ}', flush=True)
