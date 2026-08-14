# 孪生素数猜想：246 纪录的完整分析与自足证明

本仓库包含对"有界素数间隔"问题（Polymath8b 纪录 H₁ ≤ 246）的完整独立研究：
**可容许 k 元组最小直径 H(k) 的完全自足证明、Lean 4 形式化验证、以及 Maynard
筛法判据 M_{k,ε} 的严格数值判定工具链。**

## 核心数学结论

| 定理 | 状态 | 证明方式 |
|---|---|---|
| H(43) = 200 | ✅ 完整自足证明 | 穷举搜索：全部 d<200 UNSAT + 显式 SAT 见证 |
| H(44) = 210 | ✅ 完整自足证明 | 穷举搜索：全部 d<210 UNSAT + 显式 SAT 见证 |
| H(46) = 216 | ✅ 完整自足证明 | 穷举搜索：全部 d<216 UNSAT + 显式 SAT 见证 |
| H(45) = 212 | 🔄 收尾 | SAT 见证 ✓；边界 d=208 已证 UNSAT，d=210 运行中 |
| H(50) = 246 | 🔄 收尾 | SAT 见证 ✓（纪录元组复现）；d≤220 已证 UNSAT |
| H(k), k=2..42 | ✅ 全表验证 | 与 OEIS A008407（Clark–Jarvis 2001）零失配 |

与 OEIS A008407 / Clark–Jarvis (2001) / Polymath8b (2014) 三方互证。

## 关键洞察：为什么 246 无法缩短

Polymath8b 判据（无条件，Bombieri–Vinogradov）：若 **M_{k,ε} > 4** 则存在无穷多
素数间隔 ≤ H(k)。他们严格计算 M_{50,1/25} > 4.0043（k=50 首次过线，压线 0.1%），
而 **k<50 的 M_{k,ε} 数值从未被任何人发布**——这是本项目的核心探索空间。

- 元组侧：H(46)=216 < H(50)=246 已被完全证明——纪录用的 50 元组并非最小
- 数值侧：若 M_{46,ε*}>4 或 M_{49,ε*}>4 被证明，纪录立即降到 216 或 240
- 本仓库的严格判定（有理数 LDLᵀ 惯性 + 二分）证明：幂和多项式族（度数≤D）内
  M_{k,ε} < 4（D=8 时族内精确值：k=46: 3.65188, k=49: 3.69705, k=50: 3.71115）
- 解析上界（论文 Prop. 7.x）：M_{k,ε} ≤ (k/(k−1))·log(2k−1) 及其 a-优化推广

## 工具链

| 文件 | 功能 |
|---|---|
| `admissible.c` / `admissible_d.c` | 可容许 k 元组最小直径的精确搜索（频数剪枝 DFS） |
| `verify_admissible.py` | 独立验证器（直接枚举剩余类，不同算法） |
| `mk_probe.py` | M_{k,ε} 数值探针（Dirichlet 闭式积分 + 坐标下降） |
| `mk_probe_strict.py` | **严格判定器**：精确有理数 LDLᵀ 惯性 → 严格判定族内 M 与 4 的关系 |
| `mk_bisect.py` | **有理数二分**：族内 λ_max 的严格区间（宽度 < 1e-10） |
| `twin_sieve.c` / `twin_sieve.py` | 孪生素数分段筛计数（验证到 10¹¹：224,376,048 精确一致） |
| `TwinPrimeAdmissible.lean` | **Lean 4 形式化**：89 定理，零 sorry/axiom（仅 import Init） |

## Lean 4 形式化（TwinPrimeAdmissible.lean）

- 六个关键见证（k=43..50）可容许性 + 直径 + 存在性定理
- k=46 的 14 个下行见证（d=246→216）
- H(2)..H(12) 的 11 个精确最小性定理（穷举机器证明）
- 结构定理（手写证明）：平移不变性、任意 k 存在可容许元组（primorial 构造）、单调性

编译（Lean 4.33.0，仅核心库）：
```
lean TwinPrimeAdmissible.lean    # EXIT 0
```

## 结果数据

- `results/unsat/`：H(44)/H(45)/H(50) 边界 UNSAT 证明输出（含用时）
- `results/strict/`：M_{k,ε} 严格判定与严格族内值日志
- `results/mscan/`：k×ε 网格的浮点扫描（族内最优 ε 确认 = 1/25）
- `dmin_table_k2to50.csv`：k=2..50 的最小直径表（与 OEIS 对照）

## 复现

```bash
# 元组搜索
gcc -O3 -o admissible admissible.c -lm
./admissible 2 50          # H(k) 表
./admissible_d 46 216      # 单点 SAT/UNSAT 判定

# M 泛函严格判定
python3 mk_probe_strict.py 46 1 25 8 8 6    # k=46, eps=1/25, D=8
python3 mk_bisect.py 46 1 25 8 8 6 50       # 严格区间

# 孪生素数计数
gcc -O3 -o twin_sieve twin_sieve.c -lm
./twin_sieve 100000000000  # π₂(10^11) = 224376048
```

## 诚实声明

- 孪生素数猜想本身未解决（奇偶性障碍，Selberg）。
- "超越 246"需要证明真实 M_{k<50,ε} > 4——数值证据（渐近标定 + 族内收敛）强烈
  表明真实值 < 4，但有限多项式族的严格判定无法完全排除（需区间算术全空间分析
  或新数学）。本仓库提供的是：H 侧的完整自足证明 + M 侧的严格判定工具与部分
  严格结果。

## 参考文献

- Polymath8b, *Variants of the Selberg sieve, and bounded intervals containing many primes*, Res. Math. Sci. 1 (2014), arXiv:1407.4897
- D. Clark, N. Jarvis, *Dense admissible sequences*, Math. Comp. 70 (2001) 1713–1718
- OEIS A008407: minimal diameter of admissible k-tuples
- J. Maynard, *Small gaps between primes*, Ann. of Math. 181 (2015)
