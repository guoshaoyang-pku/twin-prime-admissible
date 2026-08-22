#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""legendre_fix.py — 良态化 (I, J1) 广义特征值: 高精度全空间正交化 + float64 特征值

背景 (Maynard 筛法泛函 M_{k,eps} = k * lambda_max(J1, I), 严格证明 M<4):
  frac_cache_{k}_{D}.pkl 提供精确有理 Gram 矩阵对 (I, J1) (混合基 {(1-P1)^r p_gamma}).
  I 病态 (cond ~ 1e54), float64 广义特征值不可靠 (jitter 敏感 ~ ±0.02).
  legendre_eig.py 尝试块对角 Legendre 变换失败 (cond 仍 4.82e67, M 错).

诊断 (见 diag_cond.py 输出):
  1. 块对角 Legendre 变换错在两点:
     a. 多项式族错误: 块内测度是 x^{k+2|gamma|-1}dx (moments s!/(k+2|gamma|+s)!),
        正确正交多项式是位移 Jacobi P^{(0,k+2|gamma|-1)}(2x-1), 不是 Legendre;
     b. 块对角结构错误: 跨块条目 (r1+r2)!·H(alpha∪beta;k)/(k+|alpha|+|beta|+r1+r2)!
        的 (r1+r2) Hankel 衰减把不同块的 r 指标耦合在一起, 块对角变换无法消除;
     故任何"逐块正交化"都不能把 cond 降到 < 1e6.
  2. 可行方案 (本脚本): 全空间正交化 —— 高精度 (gmpy2.mpfr, bits 位) 计算
     I = L D L^T (LDL^T, SPD 无选主元), 令 T = D^{-1/2} L^{-1}:
        Ĩ = T I T^T = I (cond = 1),  J̃ = T J1 T^T.
     合同变换保持广义特征值: J1 v = λ I v  ⟺  J̃ w = λ w,  w = T^{-T} v.
     最后 float64 eigvalsh(J̃) 即得 λ_max; J̃ 对称且特征值良态 (Weyl 定理),
     对 J̃ 的 float64 舍入/抖动稳定.

用法:
  python3 legendre_fix.py k D [bits]            # 主流程 (默认 bits=512)
  python3 legendre_fix.py k D [bits] --jit      # + 抖动测试
  python3 legendre_fix.py k D [bits] --no-verify  # 跳过 Rayleigh 验证 (更快)
"""
import sys, time, math, pickle, random
from fractions import Fraction as Fr
from collections import defaultdict
import numpy as np
import gmpy2
from gmpy2 import mpfr, mpz, get_context

# ---------------- 基与块结构 ----------------
def gen_even_partitions(max_deg):
    res = []
    def rec(deg_used, parts):
        res.append(tuple(parts))
        start = parts[-1] if parts else 2
        for v in range(start, max_deg - deg_used + 1, 2):
            rec(deg_used + v, parts + [v])
    rec(0, [])
    return res

def build_basis(D):
    parts = gen_even_partitions(D)
    basis = []
    for gamma in parts:
        for r in range(0, D - sum(gamma) + 1):
            basis.append((r, gamma))
    blocks = defaultdict(list)
    for i, (r, gamma) in enumerate(basis):
        blocks[gamma].append(i)
    return parts, basis, blocks

# ---------------- 高精度线性代数 (gmpy2 mpfr) ----------------
def to_mpfr(M, bits):
    """Fraction 列表 -> mpfr 列表 (行主序); 已是 mpfr 则原样返回"""
    ctx = get_context(); old = ctx.precision
    ctx.precision = bits
    out = []
    for row in M:
        nr = []
        for x in row:
            if isinstance(x, mpfr):
                nr.append(x)
            else:
                nr.append(mpfr(x.numerator) / mpfr(x.denominator))
        out.append(nr)
    ctx.precision = old
    return out

def ldlt_inplace(A):
    """A 对称正定, in-place LDL^T (L 单位下三角存于严格下三角, D 存于对角)。
    返回 None; 若出现非正枢轴返回 (i, pivot) 指示失败。"""
    n = len(A)
    for i in range(n):
        di = A[i][i]
        for j in range(i):
            l = A[i][j]
            for k in range(j):
                l -= A[i][k] * A[j][k] * A[k][k]
            l /= A[j][j]
            A[i][j] = l
            di -= l * l * A[j][j]
        if di <= 0:
            return (i, di)
        A[i][i] = di
    return None

def solve_forward_unit(L, B):
    """L 单位下三角 (L[i][j] 存于 A[i][j], j<i; 对角为 1), 解 L Y = B。
    B: n 行列表; 返回 Y 同样结构。"""
    n = len(B)
    Y = [row[:] for row in B]
    for i in range(n):
        Yi = Y[i]
        for m in range(i):
            l = L[i][m]
            if l != 0:
                Ym = Y[m]
                for j in range(n):
                    Yi[j] -= l * Ym[j]
    return Y

def reduce_pair(I, J1, bits):
    """核心: 高精度 LDL^T(I) + J̃ = D^{-1/2} L^{-1} J1 L^{-T} D^{-1/2}。
    返回 (Jt, s, L, d) 其中 s[i]=1/sqrt(d[i]), L 单位下三角, d 对角; Ĩ ≡ I。"""
    ctx = get_context(); old = ctx.precision
    ctx.precision = bits
    t0 = time.time()
    print(f"[reduce] converting to mpfr @ {bits} bits ...", flush=True)
    A = to_mpfr(I, bits)
    B = to_mpfr(J1, bits)
    n = len(A)
    t1 = time.time()
    print(f"[reduce] convert done ({t1-t0:.0f}s); LDL^T of I ...", flush=True)
    fail = ldlt_inplace(A)
    if fail is not None:
        return ('fail', fail)
    print(f"[reduce] LDL^T done ({time.time()-t1:.0f}s); solving L Y = J1 ...", flush=True)
    # A 中: 严格下三角 = L, 对角 = d
    Y = solve_forward_unit(A, B)
    t2 = time.time()
    print(f"[reduce] L_inv J1 done ({t2-t1:.0f}s); solving L V^T = Y^T ...", flush=True)
    # V = Y L^(-T) ⟺ L V^T = Y^T
    YT = [list(col) for col in zip(*Y)]
    del Y
    Vt = solve_forward_unit(A, YT)
    del YT
    V = [list(col) for col in zip(*Vt)]
    del Vt
    print(f"[reduce] L_inv J1 L_invT done ({time.time()-t2:.0f}s); scaling D_inv2 ...", flush=True)
    s = [mpfr(1) / gmpy2.sqrt(A[i][i]) for i in range(n)]
    for i in range(n):
        si = s[i]
        Vi = V[i]
        for j in range(n):
            Vi[j] *= si * s[j]
    print(f"[reduce] total {time.time()-t0:.0f}s", flush=True)
    # 提取 L, d (供验证)
    d = [A[i][i] for i in range(n)]
    L = [[A[i][j] if j < i else mpfr(0) for j in range(n)] for i in range(n)]
    ctx.precision = old
    return (V, s, L, d)

# ---------------- 验证 ----------------
def verify(v, J1, I, lam, bits, label=""):
    """高精度 Rayleigh 验证: v^T J1 v / v^T I v 应 ≈ lam (合同不变性端到端检验)"""
    n = len(v)
    ctx = get_context(); old = ctx.precision
    ctx.precision = bits
    J1m = [[mpfr(x.numerator) / mpfr(x.denominator) for x in row] for row in J1]
    Im = [[mpfr(x.numerator) / mpfr(x.denominator) for x in row] for row in I]
    num = mpfr(0); den = mpfr(0)
    for i in range(n):
        vi = v[i]
        J1i = J1m[i]; Ii = Im[i]
        sn = mpfr(0); sd = mpfr(0)
        for j in range(n):
            sn += J1i[j] * v[j]
            sd += Ii[j] * v[j]
        num += vi * sn
        den += vi * sd
    rq = num / den
    ctx.precision = old
    print(f"[verify{label}] Rayleigh(v) = {mpfr2str(rq, 18)}   (λ_max = {lam:.15f},  diff = {float(rq - lam):.2e})", flush=True)
    return float(rq)

def mpfr2str(x, nd=15):
    return format(x, f'%.{nd}f')

# ---------------- 主流程 ----------------
def main():
    k = int(sys.argv[1]); D = int(sys.argv[2])
    bits = int(sys.argv[3]) if len(sys.argv) > 3 else 512
    cache = sys.argv[4] if len(sys.argv) > 4 and not sys.argv[4].startswith('--') else f'frac_cache_{k}_{D}.pkl'
    do_jit = '--jit' in sys.argv
    do_verify = '--no-verify' not in sys.argv
    seed = 12345
    random.seed(seed)

    t_load = time.time()
    with open(cache, 'rb') as f:
        I, J1 = pickle.load(f)
    n = len(I)
    parts, basis, blocks = build_basis(D)
    assert len(basis) == n
    print(f"k={k} D={D} n={n} bits={bits} cache={cache}  (#blocks={len(blocks)})  loaded in {time.time()-t_load:.0f}s", flush=True)

    # ---- 主约化 ----
    res = reduce_pair(I, J1, bits)
    if res[0] == 'fail':
        i, piv = res[1]
        print(f"FATAL: LDL^T pivot {i} non-positive ({float(piv):.3e}) — I 非 SPD?", flush=True)
        sys.exit(1)
    V, s, L, d = res
    # V 已是 J̃ (D^{-1/2} L^{-1} J1 L^{-T} D^{-1/2})
    Jtf = np.array([[float(x) for x in row] for row in V], dtype=np.float64)
    del V
    print(f"[main] J̃ (float64) ready; ||J̃||_inf = {np.abs(Jtf).max():.3e}", flush=True)
    try:
        cJ = float(np.linalg.cond(Jtf))
        print(f"[main] cond(J̃) [float64, 饱和于 ~1e16 以上] = {cJ:.3e}", flush=True)
    except Exception:
        pass

    ev = np.linalg.eigvalsh(Jtf)
    lam = float(ev[-1])
    print(f"[main] λ_max(J̃) = {lam:.15f}   M = k·λ_max = {k*lam:.10f}", flush=True)
    print(f"[main] top 5 eigenvalues: {', '.join(f'{x:.10f}' for x in ev[-5:])}", flush=True)
    print(f"[main] smallest 3: {', '.join(f'{x:.3e}' for x in ev[:3])}", flush=True)
    print(f"[main] spread (min,max) = ({ev[0]:.3e}, {ev[-1]:.3e})  gap1 = {ev[-1]-ev[-2]:.3e}", flush=True)
    print(f"RESULT k={k} D={D}: λ_max = {lam:.15f}  M = {k*lam:.10f}  (float64 eig of well-conditioned J̃, cond(Ĩ)=1)", flush=True)

    # ---- 端到端验证: 提升特征向量, 在原矩阵上高精度 Rayleigh ----
    if do_verify:
        wvec = np.linalg.eigh(Jtf)[1][:, -1]
        ctx = get_context(); old = ctx.precision
        ctx.precision = bits
        wm = [mpfr(float(x)) for x in wvec]
        # v = L^{-T} D^{-1/2} w: 解 L^T z = s·w (s[i]=1/sqrt(d[i]))
        b = [s[i] * wm[i] for i in range(n)]
        z = [mpfr(0)] * n
        for i in range(n - 1, -1, -1):
            zi = b[i]
            for m in range(i + 1, n):
                zi -= L[m][i] * z[m]
            z[i] = zi
        ctx.precision = old
        del wm, b
        verify(z, J1, I, lam, bits)
        # 同时验证 I 侧: v^T I v 应 ≈ 1 (因为 Ĩ = I, w^T w = 1)
        ctx = get_context(); old = ctx.precision; ctx.precision = bits
        Im = [[mpfr(x.numerator) / mpfr(x.denominator) for x in row] for row in I]
        den = mpfr(0)
        for i in range(n):
            zi = z[i]
            sd = mpfr(0)
            Ii = Im[i]
            for j in range(n):
                sd += Ii[j] * z[j]
            den += zi * sd
        ctx.precision = old
        del Im, z
        print(f"[verify] v^T I v = {float(den):.15f}  (应 ≈ 1)", flush=True)

    # ---- 抖动测试 ----
    if do_jit:
        print("\n===== jitter tests =====", flush=True)
        # (A) 约化矩阵 J̃ 的 float64 舍入级抖动: 扰动 Jtf 条目, 重算 eigvalsh
        for delta in (1e-12, 1e-10, 1e-8):
            vals = []
            for t in range(20):
                J2 = Jtf * (1.0 + delta * np.random.uniform(-1, 1, size=Jtf.shape))
                J2 = (J2 + J2.T) / 2
                vals.append(float(np.linalg.eigvalsh(J2)[-1]))
            spread = max(vals) - min(vals)
            print(f"[jit-A] J̃ relative jitter δ={delta:.0e}: λ_max in [{min(vals):.10f}, {max(vals):.10f}]  spread = {spread:.3e}", flush=True)
        # (B) 输入级逐项抖动 (高精度重算, bits 减半以省时):
        #     I, J1 条目乘 (1 + δ·u), u∈[-1,1]; 注意原始 I 的 λ_min ~ 1e-54·λ_max,
        #     任何 δ ≥ ~1e-55 都会使抖动后 I 非 SPD → 广义特征值不再良定义;
        #     此时报告固定已证向量 v* 的 Rayleigh 商灵敏度 (即 Maynard 泛函对输入的灵敏度).
        bits_jit = max(256, bits // 2)
        # 先取已证向量 v* (上面 z 已释放 — 重新计算一次 v* 的 RQ 灵敏度即可)
        print(f"[jit-B] entrywise input jitter (high-precision recompute @ {bits_jit} bits):", flush=True)
        # 重新做一次主约化得到 v* 的原始基坐标
        res2 = reduce_pair(I, J1, bits_jit)
        if res2[0] == 'fail':
            print("[jit-B] skip (SPD fail)", flush=True)
        else:
            V2, s2, L2, d2 = res2
            J2f = np.array([[float(x) for x in row] for row in V2])
            del V2
            wvec2 = np.linalg.eigh(J2f)[1][:, -1]
            lam2 = float(np.linalg.eigvalsh(J2f)[-1])
            ctx = get_context(); old = ctx.precision; ctx.precision = bits_jit
            wm2 = [mpfr(float(x)) for x in wvec2]
            b2 = [s2[i] * wm2[i] for i in range(n)]
            z2 = [mpfr(0)] * n
            for i in range(n - 1, -1, -1):
                zi = b2[i]
                for m in range(i + 1, n):
                    zi -= L2[m][i] * z2[m]
                z2[i] = zi
            ctx.precision = old
            del J2f, wvec2, wm2, b2, s2, L2, d2
            for delta in (1e-12, 1e-10, 1e-8):
                rqs = []
                ok_spd = True
                lamjit = None
                for t in range(3):
                    # 抖动输入
                    Ij = [[mpfr(x.numerator) * (1 + delta * random.uniform(-1, 1)) / mpfr(x.denominator) for x in row] for row in I]
                    Jj = [[mpfr(x.numerator) * (1 + delta * random.uniform(-1, 1)) / mpfr(x.denominator) for x in row] for row in J1]
                    # (c) 固定 v* 的 Rayleigh 商
                    num = mpfr(0); den = mpfr(0)
                    ctx = get_context(); old = ctx.precision; ctx.precision = bits_jit
                    for i in range(n):
                        zi = z2[i]
                        sn = mpfr(0); sd = mpfr(0)
                        Jji = Jj[i]; Iji = Ij[i]
                        for j in range(n):
                            sn += Jji[j] * z2[j]
                            sd += Iji[j] * z2[j]
                        num += zi * sn
                        den += zi * sd
                    rq = num / den
                    ctx.precision = old
                    rqs.append(float(rq))
                    # (b) 若抖动后 I 仍 SPD, 尝试全管线重算
                    ctx = get_context(); old = ctx.precision; ctx.precision = bits_jit
                    fail = ldlt_inplace(Ij)
                    ctx.precision = old
                    if fail is not None:
                        ok_spd = False
                    else:
                        # 用 Ij 的 L,d 对 Jj 做约化太贵 — 此处只记录 SPD 失败, 主路径见下方一次性全算
                        pass
                    del Ij, Jj
                spread = max(rqs) - min(rqs)
                print(f"[jit-B] δ={delta:.0e}: RQ(v*) spread = {spread:.3e}  (v*^T J1 v*/v*^T I v* baseline {rqs[0]:.12f}, SPD after jitter: {ok_spd})", flush=True)
        # (C) 一次性全管线输入抖动重算 (δ=1e-10, 3 个种子) — 若 SPD 保持
        print("[jit-C] full-pipeline recompute under input jitter δ=1e-10 (3 trials):", flush=True)
        for t in range(3):
            Ij = [[mpfr(x.numerator) * (1 + 1e-10 * random.uniform(-1, 1)) / mpfr(x.denominator) for x in row] for row in I]
            Jj = [[mpfr(x.numerator) * (1 + 1e-10 * random.uniform(-1, 1)) / mpfr(x.denominator) for x in row] for row in J1]
            res3 = reduce_pair(Ij, Jj, bits_jit)
            del Ij, Jj
            if res3[0] == 'fail':
                print(f"[jit-C] trial {t}: SPD fail", flush=True)
            else:
                V3, s3, L3, d3 = res3
                lam3 = float(np.linalg.eigvalsh(np.array([[float(x) for x in row] for row in V3]))[-1])
                del V3, s3, L3, d3
                print(f"[jit-C] trial {t}: λ_max = {lam3:.12f}  (Δ vs main = {lam3-lam:+.3e})", flush=True)

if __name__ == '__main__':
    main()
