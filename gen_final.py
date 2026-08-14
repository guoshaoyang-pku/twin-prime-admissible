#!/usr/bin/env python3
"""Generate TwinPrimeAdmissible.lean from sorted_witnesses.json."""
import json

with open("sorted_witnesses.json") as f:
    W = json.load(f)

HEADER = """-- ============================================================================
-- TwinPrimeAdmissible.lean
-- 可容许素数 k 元组 (admissible prime k-tuples) 的形式化验证
-- Lean 4.33.0,仅使用核心库 (不依赖 mathlib)
-- ============================================================================
-- 数学背景:
--   一个 k 元整数集 T 称为"可容许的"(admissible),若对每个素数 p ≤ k,
--   T 中元素模 p 的剩余类不覆盖全部 p 个剩余类 (对 p > k 自动成立)。
--   H(k) := 可容许 k 元组的最小直径 (Maynard 筛法的关键量)。
--   已发表值:H(46)=216, H(50)=246 (Clark–Jarvis 2001 / OEIS A008407),
--   Polymath8b 用 H(50)=246 证明素数间隔纪录 246。
--
-- 本文件形式化:
--   A. 六个关键见证 (k=43..50) 的可容许性 + 直径断言 (SAT 侧);
--   B. k=46 的 14 个下行见证 (直径 246..216) 的可容许性 + 直径断言 (SAT 侧);
--   C. 小 k (k=2..12) 的精确最小性 H(k) (对直径 < H(k) 的穷举搜索)。
--
-- 重要说明:
--   * 大 k (43..50) 的 UNSAT 侧 (不存在更小直径的可容许元组) 是外部精确搜索
--     (C 程序 / Polymath8b) 的计算结果,本文件**不**形式化它,也不使用
--     sorry/axiom 伪造——相关定理只断言 SAT 侧 (存在性)。
--   * Part C 的穷举依据"平移不改变可容许性":直径 ≤ d 的 k 元组可平移为
--     包含 0 的 [0,d] 子集,故只需枚举 (0 :: sub) 且 sub ⊆ [1..d]。
--   * 搜索优化 (结果与原穷举完全相同):可容许元组若包含 0,则模 2 下剩余
--     类 {0} 已被覆盖,为不覆盖全部 {0,1},所有元素必须为偶数;故只需枚举
--     [1..d] 中的偶数。下方 existsAdmissibleWithMin0Full 是未优化的参照
--     定义,在小情形上与优化版本做了 #eval 对拍;第 6 节还形式化证明了
--     "含 0 的可容许元组必全为偶数"(theorem admissible_with_zero_all_even),
--     从而该优化不丢失任何候选。
-- ============================================================================

import Init

-- ############################# 1. 基础定义 #############################
-- 以下定义直接复用 smoke.lean (本会话已验证可编译)。

-- 试除判定素数:isPrimeLoop n d 检查 n 是否被 [2..d+2] 中任何数整除
def isPrimeLoop : Nat → Nat → Bool
| n, 0 => true
| n, d + 1 =>
    let c := n - (d + 1)
    if 2 ≤ c && n % c == 0 then false else isPrimeLoop n d

def isPrimeBool (n : Nat) : Bool :=
  if n < 2 then false else isPrimeLoop n (n - 2)

-- T 中元素模 p 的剩余类个数 (去重后)
def residueCount (p : Nat) (t : List Nat) : Nat :=
  (t.map (fun v => v % p)).eraseDups.length

-- 可容许性:t 恰含 k 个互异元素,且对每个素数 p ≤ k,剩余类数 < p
def admissible (k : Nat) (t : List Nat) : Bool :=
  t.length = k && t.Nodup &&
  (List.filter (fun p => isPrimeBool p) (List.range (k + 1))).all
    (fun p => residueCount p t < p)

-- 直径:max − min (空表为 0)
def diameter (t : List Nat) : Nat :=
  match t with
  | [] => 0
  | x :: xs => (xs.foldl (fun a b => max a b) x) - (xs.foldl (fun a b => min a b) x)

-- ############################# 2. Part C 的穷举工具 #############################

-- 枚举 l 的所有 n 元子表 (保持原顺序,故结果互异且递增)
def comb (n : Nat) (l : List Nat) : List (List Nat) :=
  match n, l with
  | 0, _ => [[]]
  | _ + 1, [] => []
  | m + 1, x :: xs => (comb m xs).map (fun c => x :: c) ++ comb (m + 1) xs

-- [1..n] 中的偶数 (见文件头注释:含 0 的可容许元组必全为偶数)
def evensInRange (n : Nat) : List Nat :=
  ((List.range (n + 1)).filter (fun x => x % 2 == 0)).tail

-- 参照定义 (未优化):枚举 [1..d] 的全部 (k-1) 子集。
-- 仅用于对拍,不用于定理。
def existsAdmissibleWithMin0Full (k d : Nat) : Bool :=
  (comb (k - 1) (List.range (d + 1)).tail).any (fun sub => admissible k (0 :: sub))

-- 优化后的穷举:只枚举偶数子集 (结果与原定义等价,见文件头注释)。
-- 返回 true 当且仅当存在可容许的 k 元组 {0} ∪ sub,sub ⊆ [1..d]。
def existsAdmissibleWithMin0 (k d : Nat) : Bool :=
  (comb (k - 1) (evensInRange d)).any (fun sub => admissible k (0 :: sub))

-- 对拍:小情形下优化版本与原穷举版本结果一致 (k=6 的 H 值 16 处两者都找到见证)
#eval existsAdmissibleWithMin0Full 6 16
#eval existsAdmissibleWithMin0 6 16
#eval existsAdmissibleWithMin0Full 6 15
#eval existsAdmissibleWithMin0 6 15
#eval existsAdmissibleWithMin0Full 8 12
#eval existsAdmissibleWithMin0 8 12
#eval existsAdmissibleWithMin0Full 8 18
#eval existsAdmissibleWithMin0 8 18
#eval existsAdmissibleWithMin0 2 1
#eval existsAdmissibleWithMin0 2 2
"""

PART_A_TMPL = """
-- ############################# 3. Part A:六个关键见证 #############################
-- 对每个 (k, d) 证明:见证元组可容许、直径恰为 d、从而 H(k) ≤ d。
-- 注意:UNSAT 侧 (不存在直径 < d 的可容许 k 元组) 是外部精确搜索的结果,
-- 本文件不作形式化,也不使用 sorry/axiom。

{blocks}
"""

PART_A_BLOCK = """-- k={k}, d={d}:见证元组 (升序,min 0,max {d},{k} 个元素)
def witness_k{k}_d{d} : List Nat := {lst}

-- 可容许性:对每个素数 p ≤ {k},模 p 剩余类数 < p (native_decide 直接计算验证)
theorem witness_admissible_k{k}_d{d} : admissible {k} witness_k{k}_d{d} = true := by
  native_decide

-- 直径 (max − min) 恰为 {d}
theorem witness_diameter_k{k}_d{d} : diameter witness_k{k}_d{d} = {d} := by
  native_decide

-- 存在直径恰为 {d} 的可容许 {k} 元组,即 H({k}) ≤ {d}
theorem H{k}_le_{d} : ∃ t : List Nat, t.length = {k} ∧ admissible {k} t = true ∧ diameter t = {d} := by
  refine ⟨witness_k{k}_d{d}, ?_, ?_, ?_⟩ <;> native_decide
"""

PART_B_TMPL = """
-- ############################# 4. Part B:k=46 的 14 个下行见证 #############################
-- 每个见证都是 46 元可容许元组,直径分别从 246 降到 216 (SAT 侧;UNSAT 侧不作形式化)。
-- 定理形式:admissible 46 t = true ∧ diameter t = d

{blocks}
"""

PART_B_BLOCK = """-- k=46, d={d}:{d} 元见证 (升序,min 0,max {d},46 个元素)
def witness46_d{d} : List Nat := {lst}

-- 可容许且直径恰为 {d}
theorem witness46_d{d}_ok : admissible 46 witness46_d{d} = true ∧ diameter witness46_d{d} = {d} := by
  native_decide
"""

PART_C_TMPL = """
-- ############################# 5. Part C:小 k 精确最小性 H(k) #############################
-- 思路:由平移不变性,直径 ≤ d 的 k 元组可平移为含 0 的 [0,d] 子集;
-- 故 "H(k) = h" 等价于:
--   (存在性) 存在可容许 k 元组直径恰为 h —— 用显式见证 native_decide 证明;
--   (最小性) 对所有 d < h,穷举搜索 existsAdmissibleWithMin0 k d 返回 false —— native_decide
--            直接在原生代码中跑完 C(⌊h/2⌋, k-1) 规模的枚举 (含 0 ⇒ 全偶,见文件头)。
-- 精确值来自 OEIS A008407 与本会话 C 程序对拍:H(2)=2,...,H(8)=26。

{blocks}
"""

PART_C_BLOCK = """-- k={k} 见证 (min=0)
def witness_k{k} : List Nat := {lst}

-- H({k}) = {h}:存在直径恰为 {h} 的可容许 {k} 元组,且不存在直径 < {h} 的可容许 {k} 元组
theorem H{k}_eq_{h} :
    (∃ t : List Nat, t.length = {k} ∧ admissible {k} t = true ∧ diameter t = {h}) ∧
    (∀ d : Nat, d < {h} → existsAdmissibleWithMin0 {k} d = false) := by
  constructor
  · exact ⟨witness_k{k}, by native_decide, by native_decide, by native_decide⟩
  · native_decide
"""

APPENDIX = """
-- ############################# 6. 附录:穷举优化 (仅偶数) 的可靠性证明 #############################
-- existsAdmissibleWithMin0 只枚举 [1..d] 中的偶数子集。这里形式化证明该优化不丢失候选:
--
--   主定理 admissible_with_zero_all_even:
--     若 k ≥ 2 且 (0 :: sub) 可容许,则 sub 的每个元素都是偶数。
--   证明要点:0 模 2 已覆盖剩余类 0;可容许性要求模 2 剩余类数 < 2,故不允许
--   奇数元素出现 (否则剩余类 {0,1} 全覆盖)。归纳引理按首元素 y % 2 分情况:
--   y 偶则与表头 0 同余,剩余类数不变;y 奇则剩余类数 ≥ 2,与 < 2 矛盾。
--
-- 因此任何可容许的含 0 元组都在优化搜索的枚举范围内,Part C 的穷举结论不受影响。

-- 归纳引理:模 2 剩余类数 < 2 时,(0 :: sub) 中除 0 外全为偶数
theorem residueCount2_lt_two_all_even (sub : List Nat) :
    residueCount 2 (0 :: sub) < 2 → sub.all (fun x => x % 2 == 0) = true := by
  induction sub with
  | nil => intro h; rfl
  | cons y ys ih =>
      intro hlt
      rcases Nat.mod_two_eq_zero_or_one y with hy | hy
      · -- y 为偶数:y 与表头 0 模 2 同余,剩余类数不变
        have hstep : residueCount 2 (0 :: y :: ys) = residueCount 2 (0 :: ys) := by
          unfold residueCount
          rw [List.map_cons, List.map_cons, hy]
          rfl
        have hlt' : residueCount 2 (0 :: ys) < 2 := by
          rw [hstep] at hlt
          exact hlt
        have hys : ys.all (fun x => x % 2 == 0) = true := ih hlt'
        have hyb : (y % 2 == 0) = true := by
          rw [hy]
          rfl
        simp [hyb, hys]
      · -- y 为奇数:0 与 1 两个剩余类都被覆盖,剩余类数 ≥ 2
        have hge : 2 ≤ residueCount 2 (0 :: y :: ys) := by
          unfold residueCount
          rw [List.map_cons, List.map_cons, hy]
          simp [List.eraseDups_cons, List.length_cons]
        exact False.elim (Nat.not_lt_of_ge hge hlt)

-- 主定理:含 0 的可容许元组的非零元素必全为偶数
theorem admissible_with_zero_all_even {k : Nat} (hk : 2 ≤ k) (sub : List Nat) :
    admissible k (0 :: sub) = true → sub.all (fun x => x % 2 == 0) = true := by
  intro h
  simp [admissible] at h
  have h2mem : 2 < k + 1 := by exact Nat.lt_succ_of_le hk
  have hp := h.2 2 h2mem
  have his : isPrimeBool 2 = true := by native_decide
  have hlt : residueCount 2 (0 :: sub) < 2 := by
    cases hp with
    | inl hb =>
        have hne : ¬ isPrimeBool 2 = false := by
          rw [his]
          exact fun hh => Bool.noConfusion hh
        exact False.elim (hne hb)
    | inr hr => exact hr
  exact residueCount2_lt_two_all_even sub hlt
"""

# Part A order: k=43,46,47,48,49,50
a_order = ["k43_d200", "k46_d216", "k47_d226", "k48_d236", "k49_d240", "k50_d246"]
a_blocks = []
for key in a_order:
    k, d = key.split("_")[0][1:], key.split("_")[1][1:]
    a_blocks.append(PART_A_BLOCK.format(k=k, d=d, lst=W[key]))

# Part B order: the 14 descending witnesses (d-values from the task)
b_order = [f"k46_d{d}" for d in [246, 244, 242, 240, 238, 236, 234, 232, 230, 228, 226, 222, 218, 216]]
b_blocks = []
for key in b_order:
    d = key.split("_")[1][1:]
    b_blocks.append(PART_B_BLOCK.format(d=d, lst=W[key]))

# Part C: k=2..12 with H values
small = [(2, 2, "small_k2"), (3, 6, "small_k3"), (4, 8, "small_k4"),
         (5, 12, "small_k5"), (6, 16, "small_k6"), (7, 20, "small_k7"), (8, 26, "small_k8"),
         (9, 30, "small_k9"), (10, 32, "small_k10"), (11, 36, "small_k11"), (12, 42, "small_k12")]
c_blocks = []
for k, h, key in small:
    c_blocks.append(PART_C_BLOCK.format(k=k, h=h, lst=W[key]))

with open("F_part.lean") as f:
    F_PART = f.read()

full = (HEADER + PART_A_TMPL.format(blocks="\n".join(a_blocks))
        + PART_B_TMPL.format(blocks="\n".join(b_blocks))
        + PART_C_TMPL.format(blocks="\n".join(c_blocks))
        + APPENDIX
        + F_PART)

with open("TwinPrimeAdmissible.lean", "w") as f:
    f.write(full)
print(f"Generated TwinPrimeAdmissible.lean: {len(full.splitlines())} lines")
