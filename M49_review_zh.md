# Maynard–Polymath8b 筛法泛函数值与 k=49 阈值评估（文献综述）

> 检索日期：2026 年（本综述基于 arXiv:1407.4897 全文、Polymath wiki 现行/历史页面、OEIS A008407 及多篇综述/论文的核验）。

## 0. 一句话结论

**未找到任何已发表的 k<50（含 k=49）的 M_{k,ε} 数值**；Polymath8b 论文明确将 k=49 列为"可能但未完成"的开放问题。246 至今（2026）仍是最小无条件素数间隔界。解析约束：ε=0 时 M_49 ≤ (49/48)ln49 ≈ **3.9729 < 4**（不可能超过 4），ε=1/50 时上界 ≈ **4.0524**（与你引用的数值一致），因此 **M_{49,ε}>4 在解析上未被排除，但可行窗口极窄，且自 2014 年以来无人公开发表过该计算**。

## 1. Polymath8b 论文中发布的 M_{k,ε} 数值（已发表）

文献：DHJ Polymath, *Variants of the Selberg sieve, and bounded intervals containing many primes*, arXiv:[1407.4897](https://arxiv.org/abs/1407.4897)，Res. Math. Sci. **1:12** (2014)（[ar5iv 全文](https://ar5iv.labs.arxiv.org/html/1407.4897)）。

论文只发布了 **三个** M_{k,ε} 下界（Theorem 3.13，§7.2–7.3 证明）：

| 量 | 已发布下界 | 备注 |
|---|---|---|
| M_{50,1/25} | > **4.0043**（d=27，2526×2526 矩阵，两周计算）；d=25 时 > 4.00124 | ⇒ DHL[50,2] ⇒ **H_1 ≤ H(50) = 246**（无条件，Theorem 3.2(i)/1.4(i)） |
| M_{51,1/50} | > **4.00156**（d=22） | ⇒ 在 GEH 下 H_2 ≤ H(51) = 252（Theorem 1.4(xiii)） |
| M_{4,0.168} | > 2.00558（显式函数，可手算验证） | 与 GEH 下 H_1 ≤ 6 相关 |

ε=0（未放大单纯形）的 Krylov 子空间下界（论文 Table 3）：k=50: 3.93586；k=53: 3.98621；k=54: 4.00223（→H_1≤270，Theorem 1.4 未用此值）；k=60: 4.09101；k=100: 4.46424。**表中没有 k=46–49 的行**（只列 k=2,3,4,5,10,20,30,40,50,53,54,60,100）。

Polymath wiki 的 [Selberg sieve variational problem](https://michaelnielsen.org/polymath/index.php?title=Selberg_sieve_variational_problem) 世界纪录表同样只有 k=50,51,53,54,59 附近的 M_{k,ε} 条目，**无 k=46–49**。

## 2. "k=49 开放"的公开陈述（论文原文）

论文 §8（收尾评注，原文）：

> "In Theorem 3.13, the bound M_{k,ε} > 4 was obtained for some ε > 0 and k = 50. **It is possible that k could be lowered slightly, for instance to k = 49, by further numerical computations, but we were only barely able to establish the k = 50 bound after two weeks of computation.** However, there may be a more efficient way to solve the required variational problem (e.g. by selecting a more efficient basis than the symmetric monomial basis) ... **this would improve the bound H_1 ≤ 246 slightly.** Extrapolation of existing numerics also raises the possibility that M_53 exceeds 4, in which case the bound of 270 in Theorem 1.4 (vii) could be lowered to 264."

（注：M_53 那句涉及的是 EH 假设下 H_2：270→264，与 H_1 无关。论文未写 "240"，但 "improve 246 slightly" 结合 H(49)=240 即指 240。）

同期博客（Tao, [Polymath8b, IX: Large quadratic programs](http://lj.rossia.org/users/syn_terrytao/138624.html)，2014-02-21）与 wiki [时间线](https://michaelnielsen.org/polymath/index.php?title=Timeline_of_prime_gap_bounds)记录进程：2014-02-17 k=53→264；02-22 k=51→252；04-14 **k=50→246**（"A 2-week computer calculation!"）。从未达到 k=49。回顾文（arXiv:[1409.8361](https://ar5iv.labs.arxiv.org/html/1409.8361)）亦称："further improvement beyond this point seemed to require enormous amounts of computation, and by early May we were happy to 'declare victory'"。

## 3. 后续工作检索（2014–2026）：未找到

检索了 arXiv、Polymath wiki、综述与近年论文，**未发现任何对 k<50（尤其 k=46–49）的 M_{k,ε} 的后续计算、改进或证明**。核验过的相关材料：

- Maynard 综述 *Primes in intervals of bounded length*（arXiv:[1410.8400](https://ar5iv.labs.arxiv.org/html/1410.8400)，Bull. AMS 52 (2015)）：k=50 → 246，未提 k=49。
- Feng, *Bounded gaps between primes*（[Berkeley 讲义](https://math.berkeley.edu/~fengt/bounded_gaps.pdf)）："DHL[50,2] ... **This is currently the world record.**"；且指出 "The smallest k for which the upper bound gives M_k < 4 is k=50"（ε=0 视角）。
- Box, *Bounded intervals containing primes*（[Warwick Part III 论文](https://warwick.ac.uk/fac/sci/maths/people/staff/box/bounded_intervals_containing_primes.pdf)）：复述 M_{50,1/25} ≥ 4.00124 与 M_50 ≤ 3.99186 < 4（"ε-trick" 必不可少）。
- 2022 年 Lewulis（[arXiv:2203.09432](https://ar5iv.labs.arxiv.org/html/2203.09432)，almost prime k-tuples）与 Su（[arXiv:2210.10980](https://ar5iv.labs.arxiv.org/html/2210.10980)，概率方法综述）：均未计算 k<50 的 M_{k,ε}，未改变纪录。
- 2025 年 arXiv:[2507.17986](https://arxiv.org/abs/2507.17986)（"chaotic multidimensional sieve + RMT"）：**明确声明是 heuristic**（"heuristically suggests unconditional gaps of at most 180"），非证明，未被认可。
- 2025 年 ResearchGate 上 "A Weighted Distribution of Primes and a New Unconditional Bound on Gaps Between Primes"：无 arXiv/同行评审记录，站点限制无法核实内容，不构成可信来源。

**结论：k<50 的数值 = 未找到（开放）。**

## 4. OEIS A008407 与纪录现状

- [OEIS A008407](https://oeis.org/A008407)（n 元可容许组的最小直径 H(n)，n≤342 为精确值）：a(47)=226, **a(48)=236, a(49)=240, a(50)=246**, a(51)=252, a(53)=264, a(54)=270。
- **⇒ 若 M_{49,ε} > 4 成立，则无条件纪录 H_1 ≤ H(49) = 240**（机制见 §6，完全成立）。
- 当前（2026 年核验）：Polymath wiki [Bounded gaps between primes](https://michaelnielsen.org/polymath/index.php?title=Bounded_gaps_between_primes) 纪录表仍为 **H_1 ≤ 246**（无条件）/ 12（EH）/ 6（GEH）；**246 仍是最小无条件界**。

## 5. k=49 的已知理论约束（解析界，均为已发表）

定义（论文 Theorem 3.12）：M_{k,ε} 为 F 支撑在 (1+ε)R_k 上、泛函用 J_{i,1−ε} 的商的最大值。

1. **ε=0**：M_k ≤ (k/(k−1))·ln k（论文 Corollary/Lemma 6.4；亦见博客 [Polymath8b, III](https://readpipe.org/posts/7aa29bb4-a08d-448d-9f89-d7b70817cf75)）。对 k=49：**3.9729 < 4**。⇒ **ε=0 时 M_49 > 4 被解析排除**，任何"240 路线"必须用 ε-放大（M_{49,ε}）。
2. **ε>0**：论文 Proposition 6.5：M_{k,ε} ≤ (k/(k−1))·ln(2k−1)（k=49：4.670）；Remark 6.6 用权重 1+a(−Σt+kt_i) 优化得
   M_{k,ε} ≤ (k/(a(k−1)))·ln( k + (a(1+ε)−1)(k−1)/(1−a(1−ε)) )，a∈(1/(1+ε), 1/(1−ε))；在 a→1/(1+ε) 时趋近 **(1+ε)·(k/(k−1))·ln k**。
   对 k=49, ε=1/50：**≈ 4.0524**（即你引用的数值；精确值 1.02×(49/48)ln49 = 4.05236）。⇒ **M_{49,1/50} ∈ (4, 4.0524] 解析上未被排除，窗口宽度仅 ≈0.052**；增大 ε 可放宽（ε=1/25：≈4.132；ε=1/10：≈4.370），但数值上 ε 需取 1/m（m 素因子小）以控制运行时间。
3. **无条件路由的机制（B-V 足够）**：Theorem 3.12(i) + Bombieri–Vinogradov（任意固定 ϑ<1/2）：只要 M_{k,ε} > 2/ϑ（即 M_{k,ε} > 4，取 ϑ<2/M_{k,ε}<1/2）且 1+ε < 1/ϑ（ε<1 即可，远宽于实际所用 ε），即得无条件 DHL[k,2]。**故 "M_{49,ε} > 4 ⇒ H_1 ≤ 240 无条件成立" 在机制上完全成立，无需 GEH。**
4. **参照系**：k=50 时 M_{50,1/25}=4.0043 仅超出 4 约 0.0043，且需 d=27、2526×2526 矩阵、两周计算；k=49 的 ε=0 Krylov 下界约 3.90–3.92（论文表插值 ≈3.916），与 4 的缺口（≈0.08）明显大于 k=50 情形，需更高次数 d 或更大 ε，计算量急剧上升——这与论文"barely able to establish k=50"的判断一致。

## 6. 对你方数值工作的定位（非发表文献的对照）

- ε=0、D=20 混合基 {(1−P₁)^r p_γ} 的子空间下界 **≈3.89**：与论文 Krylov 表（k=40: 3.73919，k=50: 3.93586，线性插值 k=49 ≈3.916）同量级且略低，合理（基更小、无 even-signature 优化）。
- 外推全空间 ≈3.97–4.05：注意 ε=0 的解析上限是 **3.9729**，外推中 >3.97 的部分**只能由 ε>0（放大单纯形）实现**，否则与已发表的 Proposition 6.5/Remark 6.6 矛盾。即：你的外推若要取到 >4，必须显式纳入 ε-放大（M_{49,ε}），并落在 (4, 4.0524]（ε=1/50）等窗口内；同时数值下界要超过 4 才有资格申报纪录，Polymath8b 在 k=50 的经验是余量仅 0.0043 且计算两周——k=49 的可行性与基的效率（如论文建议的 piecewise-polynomial 基）直接相关。

## 7. 主要文献与链接

1. Polymath8b 论文：arXiv:[1407.4897](https://arxiv.org/abs/1407.4897)（Thm 3.13、Table 3、Prop 6.5、Remark 6.6、§8 评注）；[ar5iv HTML](https://ar5iv.labs.arxiv.org/html/1407.4897)
2. Polymath wiki：[Bounded gaps between primes](https://michaelnielsen.org/polymath/index.php?title=Bounded_gaps_between_primes)（现行纪录 246）、[Selberg sieve variational problem](https://michaelnielsen.org/polymath/index.php?title=Selberg_sieve_variational_problem)、[Timeline of prime gap bounds](https://michaelnielsen.org/polymath/index.php?title=Timeline_of_prime_gap_bounds)
3. Tao 博客：[Polymath8b, II](https://readpipe.org/posts/294ec776-50a9-49a9-a901-a2454ada2291)、[III](https://readpipe.org/posts/7aa29bb4-a08d-448d-9f89-d7b70817cf75)、[IX](http://lj.rossia.org/users/syn_terrytao/138624.html)
4. 回顾：[arXiv:1409.8361](https://ar5iv.labs.arxiv.org/html/1409.8361)（EMS Newsletter 94, 2014）
5. Maynard 综述：[arXiv:1410.8400](https://ar5iv.labs.arxiv.org/html/1410.8400)（Bull. AMS 52 (2015)）
6. [OEIS A008407](https://oeis.org/A008407)（H(49)=240, H(50)=246 精确）
7. Feng 讲义（[PDF](https://math.berkeley.edu/~fengt/bounded_gaps.pdf)）；Box Part III 论文（[PDF](https://warwick.ac.uk/fac/sci/maths/people/staff/box/bounded_intervals_containing_primes.pdf)）
8. 2025 年（非证明/未核实）：[arXiv:2507.17986](https://arxiv.org/abs/2507.17986)（明确 heuristic）；ResearchGate 上 "A Weighted Distribution of Primes..."（无法核实）
9. mersenneforum 讨论帖（[线程 t=20830](https://www.mersenneforum.org/showthread.php?t=20830)，需登录，未核实内容）

---
*综述完毕。k<50 数值：未找到（开放）。纪录：246（无条件）至今未变。*
