# A Gap in the Proof of Prop 6.5 (M_{k,ε} Upper Bound) in the Polymath8b Paper

> Date: 2026-09-01
> Reference: D.H.J. Polymath, *New equidistribution estimates of Zhang type*,
> arXiv:1407.4897 — **Proposition 6.5** and **Remark 6.6**
> Nature: a **gap in the proof** of an auxiliary proposition; **not** a disproof
> of the statement; main results (e.g. H₁ ≤ 246) **unaffected**
> Verification: `verify_mkeps_gap.py` (exact rationals + mpmath 50 dps, 5/5 checks pass)

---

## Summary

Prop 6.5 of arXiv:1407.4897 asserts M_{k,ε} ≤ (k/(k−1))·log(2k−1) for all
k ≥ 2, 0 ≤ ε < 1. The final step of its proof ("summing in i") implicitly
requires Σ_{i ∈ E(t)} (1−Σt+kt_i) ≤ k for a.e. t in (1+ε)R_k, where
E(t) is the set of "active" coordinates t_{≠i} ∈ (1−ε)R_{k−1}. We exhibit a
**positive-measure open set** of violations: for k=49, ε=1/25, any t with
13 coordinates equal to 2ε+η (η ∈ (−0.003, 0)) and the rest zero satisfies
u = Σt ∈ (1.001, 1.04) ⊂ [0, 1+ε] yet Σ_{i∈E} w_i ≈ 50.4 > k = 49.
The a-parameterized family of Remark 6.6 is affected for **a > 1/(1+ε)**;
for **a ≤ 1/(1+ε)** the argument is rigorous, and the endpoint gives
M_{k,ε} ≤ (1+ε)·k/(k−1)·log k (k=49, ε=1/25: **4.1318…**) — the optimal
rigorous bound in this weight family.

**Scope (important)**: the main theorems of the paper (H₁ ≤ 246) do **not**
depend on Prop 6.5 — the main chain uses *numerical lower bounds* on M_{k,ε}
(Thm 6.7: M_{50,1/25} > 4.0043 etc.), while Prop 6.5 appears only in the
upper-bound discussion of §6. We do **not** disprove the bound 4.67 itself
(for k=49, ε=1/25 one has numerically M ≈ 3.99 < 4.67); it may well be true,
but the published proof cannot be cited as rigorous.

## 1. Setup

Following Theorem 3.12 of the paper, for F supported on (1+ε)R_k
(R_k := {t ≥ 0 : Σt ≤ 1}):
I(F) = ∫_{(1+ε)R_k} F² dt,
J_{i,1−ε}(F) = ∫_{(1−ε)R_{k−1}} (∫₀^∞ F dt_i)² dt_{≠i},
M_{k,ε} = sup_F [Σ_i J_{i,1−ε}(F)]/I(F).

## 2. The proof and the gap

For t_{≠i} ∈ (1−ε)R_{k−1} (s := 1−Σ_{j≠i}t_j ≥ ε):
∫₀^{s+ε} dt_i/(s+(k−1)t_i) ≤ (1/(k−1))·log(2k−1), hence by Cauchy–Schwarz
(∫₀^{s+ε} F dt_i)² ≤ (log(2k−1)/(k−1))·∫₀^{s+ε} w_i F² dt_i, w_i := 1−Σt+kt_i.
Integrating over t_{≠i} ∈ (1−ε)R_{k−1} and summing over i gives
Σ_i J_{i,1−ε}(F) ≤ (log(2k−1)/(k−1))·Σ_i ∫_{D_i} w_i F² dt, D_i := {t_{≠i} ∈ (1−ε)R_{k−1}}.

**Gap**: the paper then states "Integrating in t_{≠i} and summing in i, we
obtain the claim", which implicitly requires
Σ_{i∈E(t)} w_i(t) ≤ k for a.e. t ∈ (1+ε)R_k, E(t) := {i : t_{≠i} ∈ (1−ε)R_{k−1}}.
The identity Σ_{i=1}^k w_i = k holds only when summing over *all* i
(negative contributions from inactive coordinates cancel); it does **not**
hold over active i alone.

## 3. Counterexample (positive measure)

k=49, ε=1/25. Take t = (2ε+η repeated 13 times, 0 repeated 36 times),
η ∈ (−0.003, 0):
- u = 13(2ε+η) ∈ (1.001, 1.04) ⊂ [0, 1+ε]: t lies in the **interior** of (1+ε)R_k;
- active coordinates are exactly those 13 (t_i = 2ε+η ≥ u−(1−ε));
- Σ_{i∈E} w_i = 13[1−u+k(2ε+η)] = 13(3.88+36η) ∈ (49.5, 50.4) **> k = 49**.

Since η varies continuously, violations occur on a **positive-measure open set**
(hence also in the essential-sup sense). In a 50k-point random scan, 38.7% of
points satisfy Σ_{i∈E} w_i > k. At such points the paper's CS upper bound takes
value log(97)/48 · 50.4 ≈ **4.80 > 4.67** (the claimed constant).

## 4. Remark 6.6 (a-parameterized): rigorous range

w_i^a := 1+a(−Σt+kt_i). For an active set E with |E| = m:
Σ_{i∈E} w_i^a ≤ m(1−au) + aku = m + au(k−m), u = Σt ≤ 1+ε.
- **a ≤ 1/(1+ε)**: au ≤ 1 ⟹ Σ_E w_i^a ≤ m + (k−m) = k — **rigorous**;
- **a > 1/(1+ε)**: t = (1+ε, 0, …, 0) gives Σ_E w_i^a = 1+a(1+ε)(k−1) > k — **gap**.

Consequently the claimed range a ∈ (1/(1+ε), 1/(1−ε)) is not rigorous;
a = 1 (Prop 6.5) falls inside. The rigorous endpoint a → 1/(1+ε)⁻ yields
M_{k,ε} ≤ (1+ε)·k/(k−1)·log k (k=49, ε=1/25: 4.1318…).

## 5. Impact assessment

| Item | Status |
|---|---|
| Proof of Prop 6.5 | **gap** (constant 4.67 not established by this argument) |
| Statement of Prop 6.5 | **not disproved** (no numerical counterexample; k=49,ε=1/25: M≈3.99 ≪ 4.67) |
| Proof of Remark 6.6, a > 1/(1+ε) | **gap** |
| Proof of Remark 6.6, a ≤ 1/(1+ε) | **rigorous** (endpoint 4.1318) |
| Main theorems (H₁ ≤ 246 etc.) | **unaffected** (they use numerical lower bounds, Thm 6.7) |
| Cor 6.4 (ε=0: M_k ≤ (k/(k−1))log k) | **unaffected** (ε=0: counterexample degenerates to equality) |

## 6. Verification / reproduction

`verify_mkeps_gap.py` (branch feature/mkeps-proof-gap of this repository):
5 assertions, all pass —
① Σ_{i∈E} w₁ = k(1+ε)−ε = 1273/25 = 50.92 > k (exact rationals);
② CS bound at counterexample = 4.853 > 4.670 (claimed);
③ a = 1/(1+ε): numerical max Σ_E w_i^a = 49.000 ≤ k (400-grid) + analytic proof;
④ a > 1/(1+ε): counterexample holds;
⑤ F(1/(1+ε)) = 4.13181588316 = (1+ε)k/(k−1)·log k (mpmath 50 dps).
Positive-measure confirmation: open-η scan η ∈ (−0.003, 0) + 50k random points
(38.7% violating).

## 7. Recommendation

We recommend phrasing any communication as **"a gap in the proof of
Proposition 6.5"** rather than "the paper is wrong", and contacting the
Polymath8 authors for verification. The 246 bound rests on numerical lower
bounds that have been independently verified; this note does not affect it.
