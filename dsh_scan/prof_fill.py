import sys, time, math, random
sys.path.insert(0, '.')
from gmpy2 import mpq
from routeB2 import H_exact, split_a, gen_even_partitions, build_marginals
k, DP, DM, eps = 49, 25, 7, mpq(1,25)
partsP = gen_even_partitions(DP); partsM = gen_even_partitions(DM)
basisP = []
for g in partsP:
    dg=sum(g)
    for r in range(0, DP-dg+1): basisP.append((r,g))
basisM = []
for g in partsM:
    dg=sum(g)
    for a in range(0, DM-dg+1): basisM.append((a,g))
H_cache = {}
allparts = sorted(set(partsP+partsM), key=lambda p:(sum(p),p))
for coords in (k,k-1,k-2):
    for g in allparts: H_exact(list(g),coords,H_cache)
    for g in allparts:
        for dl in allparts: H_exact(list(sorted(g+dl)),coords,H_cache)
fac = {m2: math.factorial(m2) for m2 in range(0, 3*DP+3*DM+2*k+100)}
splits = {g: split_a(list(g)) for g in set(partsP+partsM)}
marP, marM = build_marginals(k, DP, DM, eps, basisP, basisM, splits, fac)
Pstructs = set()
for m in marP:
    for (_, e1, e2, B, B2, mu, _, B3) in m: Pstructs.add((e1,e2,B,B2,mu,B3))
Mstructs = set()
for m in marM:
    for (_, e1, e2, B, B2, mu, _, B3) in m: Mstructs.add((e1,e2,B,B2,mu,B3))
print('Pstructs', len(Pstructs), 'Mstructs', len(Mstructs), flush=True)
# 抽 30 个代表性键 (按 (len(mu), e2, B3) 分层)
keys = set()
for (e1p,e2p,Bp,B2p,mup,B3p) in list(Pstructs)[:600]:
    for (e1m,e2m,Bm,B2m,mum,B3m) in Mstructs:
        mu = tuple(sorted(mup+mum))
        keys.add((e1p+e1m, e2p+e2m, Bp+Bm, B2p+B2m, B3p+B3m, mu))
kl = sorted(keys, key=lambda t: (len(t[5]), t[1], t[3]))
sel = kl[:5] + kl[len(kl)//4:len(kl)//4+5] + kl[len(kl)//2:len(kl)//2+5] + kl[-5:]
maxE = 3*DP+3*DM+2*k+300
cJT = mpq(1)-eps
cpow=[mpq(1)]
for _ in range(maxE+1): cpow.append(cpow[-1]*cJT)
mstarJT = cJT/(k-1)
mspow=[mpq(1)]
for _ in range(maxE+1): mspow.append(mspow[-1]*mstarJT)
twoeps_pow=[mpq(1)]
for _ in range(maxE+1): twoeps_pow.append(twoeps_pow[-1]*(mpq(2)*eps))
Jc={}
def JT0(a,B,B2,C):
    v=Jc.get((a,B,B2,C))
    if v is not None: return v
    tot=mpq(0)
    for s in range(B2+1):
        cs = mpq(math.comb(B2,s))*mpq(math.factorial(a+s)*math.factorial(C), math.factorial(a+s+C+1))
        E=a+s+C+1; Bp=B+B2-s
        for r in range(E+1):
            tot += cs*mpq(math.comb(E,r))*cpow[E-r]*((-(k-1))**r)*mspow[Bp+r+1]/mpq(Bp+r+1)
    Jc[(a,B,B2,C)]=tot
    return tot
branch_cache={}
def branches(mu):
    v=branch_cache.get(mu)
    if v is not None: return v
    out=[]
    def rec(l,Badd,J,coef):
        if l==len(mu): out.append((coef,Badd,tuple(J))); return
        mm=mu[l]
        rec(l+1,Badd+mm,J,coef*(k-1))
        for jj in range(1,mm+1):
            rec(l+1,Badd+(mm-jj),J+[jj],coef*math.comb(mm,jj))
    rec(0,0,[],mpq(1))
    branch_cache[mu]=out
    return out
for (e1,e2,B,B2,B3,mu) in sel:
    t1=time.time()
    expanded=[(mpq(math.comb(B3,p3))*twoeps_pow[B3-p3]*((-2)**p3), B+p3) for p3 in range(B3+1)]
    tot=mpq(0)
    br=branches(mu)
    for q in range(e2+1):
        cq=mpq(math.comb(e2,q))*twoeps_pow[e2-q]*mpq(k-1)
        for (c3,Bp) in expanded:
            for (cbr,Badd,J) in br:
                dJ=sum(J)
                Hval = mpq(1) if len(J)==0 else H_exact(J,k-2,H_cache)
                tot += cq*c3*cbr*Hval/mpq(math.factorial(k-3+dJ))*JT0(e1+q,Bp+Badd,B2,k-3+dJ)
    print(f'key (e1={e1},e2={e2},B={B},B2={B2},B3={B3},|mu|={len(mu)}): {time.time()-t1:.2f}s (JT0 {len(Jc)})', flush=True)
