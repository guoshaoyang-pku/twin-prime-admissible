# [Draft] MathOverflow post: Gap in Prop 6.5 of Polymath8 (arXiv:1407.4897)?

*Title: "Is there a gap in the proof of Proposition 6.5 of 'New equidistribution estimates of Zhang type' (arXiv:1407.4897)?"*

## Body

In arXiv:1407.4897 (Polymath8b), Proposition 6.5 states that for all
k ≥ 2 and 0 ≤ ε < 1,

M_{k,ε} ≤ (k/(k−1))·log(2k−1),

where M_{k,ε} = sup_F [Σ_{i=1}^k J_{i,1−ε}(F)]/I(F) with F supported on the
enlarged simplex (1+ε)R_k (Theorem 3.12 of the paper).

The proof is a slice-wise Cauchy–Schwarz argument: for each fixed
t_{≠i} ∈ (1−ε)R_{k−1} (s := 1−Σ_{j≠i}t_j ≥ ε) one has

(∫₀^{s+ε} F dt_i)² ≤ (log(2k−1)/(k−1))·∫₀^{s+ε} (1−Σt+kt_i) F² dt_i,

and the claim follows after "integrating in t_{≠i} and summing in i".

**Question**: does the summation step require the pointwise bound
Σ_{i: t_{≠i}∈(1−ε)R_{k−1}} (1−Σt+kt_i) ≤ k on (1+ε)R_k? If so, it seems to
fail on a set of positive measure. For k=49, ε=1/25, take t with 13
coordinates equal to 2ε+η (η ∈ (−0.003, 0)) and the remaining 36 equal to 0.
Then u := Σt = 13(2ε+η) < 1+ε (t is interior), exactly 13 slices are active,
and

Σ_{active} (1−u+kt_i) = 13(3.88+36η) ∈ (49.5, 50.4) > k = 49.

At such points the paper's CS bound takes the value
log(97)/48·50.4 ≈ 4.80 > 4.67. A random scan finds ~39% of points violate the
bound. The same issue affects Remark 6.6 for a > 1/(1+ε); for a ≤ 1/(1+ε) the
argument is rigorous and yields M_{k,ε} ≤ (1+ε)k/(k−1)·log k at the endpoint.

Have I misread the summation step (e.g. is the intended inequality
essentially-sup over a smaller set, or is there a cancellation I am missing)?
If the gap is real, does it affect any main result of the paper? My reading is
that the main theorems rely on *lower bounds* on M_{k,ε} (Theorem 6.7) rather
than on Prop 6.5, so H₁ ≤ 246 would be unaffected — I would appreciate
confirmation.

(Exact-rational verification script available on request / in linked repo.)

## Tags
nt.number-theory · cauchy-schwarz-inequality · prime-gaps · sieve-theory
