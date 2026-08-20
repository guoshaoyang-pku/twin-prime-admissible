# 复现指南（REPRODUCE）

本文说明如何从零复现本仓库的全部证明链：大规模 UNSAT 穷举、三算法交叉验证、
Lean 证书与定理。

## 0. 环境

- Linux x86_64，`gcc`（任意版本，-O2）、Python 3.10+（标准库，无第三方依赖）
- Lean 4.33.0 核心库（`lean` 可执行文件；无需 Mathlib）
- 可选：192 核集群（无集群也能跑，只是慢）

## 1. Lean 证书与定理（正式审计入口，推荐先跑）

```bash
cd lean_cert
export LEAN_PATH=.
lean CertVerify.lean      # 定义 + 验证器（几秒）
lean Sound.lean           # 可靠性证明，0 sorry（约 1 分钟）
# 编译全部 1436 个证书与定理（约 20-40 分钟，取决于核数）：
./build_all.sh /path/to/lean
```

`build_all.sh` 需要 `lean` 在 PATH 或作为参数/`LEAN_BIN`。
全部编译 EXIT 0 即证书链完整。抽验：

```bash
lean lean_theorems/T_50_244.lean   # H50_gt_244
lean lean_theorems/T_42_194.lean   # H42_gt_194（k=42 下界）
```

**信任边界**：定理用 `native_decide`（VM 执行 + 内核 `ofReduceBool`）。
无自定义 `axiom`/`sorry`（`grep -c sorry Sound.lean` 应为 0）。

### 1.1 纯内核版本（可选）

小证书可用 `by decide`（纯内核归约，无 native_decide）：
`lean_cert/TestDecide.lean`（k=43 d=84，4 节点证书，0.25 秒）。
中等证书（~2k 节点）需 `set_option maxHeartbeats 4000000`，约数分钟。
大证书（12k+ 节点）纯内核不现实，用 `native_decide`。

## 2. 证书生成（确定性，可复现）

```bash
cd lean_cert
python3 cert_gen.py        # 自测：代表性 (k,d) 的证书生成与验证
python3 gen_all.py         # 生成 k=43..50 的 529 个文本证书（~5 秒）
python3 gen_numeric.py     # 数字编码版本
python3 gen_extended.py    # k=47,48,49（含在 gen_all 范围外的 210 个）
python3 gen_smallk.py      # k=20..42 的 907 个
python3 gen_lean_certs.py  # 生成 Lean 证书定义（lean_certs/）
python3 gen_theorems.py    # 生成 Lean 定理（lean_theorems/）
```

生成器（`cert_gen.py`）实现**算法 C**：剩余类分配搜索的完备判定
（∃ 直径 ≤ d 可容许 k 元组 ⟺ ∃ 素数非零类分配使幸存位置 ≥ k），
每个目标输出一棵"失败树"证书。

## 3. 大规模 UNSAT 穷举（k=43..50 的原始证明，可选重跑）

早期 319 个目标（k=43,44,45,46,50）另有六层子空间划分 DFS 穷举
（`admissible_par1..6.c`，42.4 万子空间）。**重跑约需 1-3 天（192 核）**：

```bash
# 1) 编译求解器
gcc -O2 -o admissible_par1 admissible_par1.c   # …同理 par2..par6
# 2) 生成任务（层间划分由 splitter 完成）
python3 par1_daemon.py      # level-1 任务守护
python3 unified_daemon.py   # 多队列调度（par2..par6，配额可调）
python3 par5_splitter.py    # 长任务拆分（>1500s 拆到下一层）
# 3) 验证覆盖
python3 verify_coverage.py  # 319 目标 0 反例 0 缺口
```

注意：原始 42.4 万个结果文件未随仓库发布（约 1.6 GB）；正式审计以 Lean 证书为准。

## 4. 三算法交叉验证（秒级）

```bash
python3 verify_admissible_independent.py
```

输出：算法 A（双实现可容许性检查）、算法 B（朴素穷举 H(k)，k=2..20，与 OEIS
A008407 对拍）、算法 C（剩余类分配完备判定；k=50: d=244 UNSAT / d=246 SAT）。

## 5. SAT 侧见证

- `sorted_witnesses.json`：30 个见证元组（k=43..50 及 k=46 系列）
- `TwinPrimeAdmissible.lean`：96 定理（见证可容许性 + 小 k H(k) 精确值），EXIT 0

## 6. M 泛函侧（数值工具，非证明）

```bash
cd dsh_scan
python3 dscan.py 50 1 25 6 8 12   # k=50, ε=1/25, r=6, D=8/12 族内浮点值
python3 batch_k.py 49 8 6 55 1 25 1 50   # 严格有理数 LDL^T 判定
```

`M_exclusion_analysis_k47_49.md` 记录严格结果与开放缺口。

## 7. 复现验证清单

| 步骤 | 命令 | 预期 |
|---|---|---|
| 验证器编译 | `lean CertVerify.lean Sound.lean` | EXIT 0 |
| 全量编译 | `./build_all.sh <lean>` | 1436/1436 无 FAIL |
| 证书生成 | `python3 gen_all.py` | 529 个，全部 verify=True |
| 交叉验证 | `python3 verify_admissible_independent.py` | 全部 PASS |
| SAT 形式化 | `lean TwinPrimeAdmissible.lean` | EXIT 0 |
