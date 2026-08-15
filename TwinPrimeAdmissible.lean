-- ============================================================================
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
--      (另含 k=44@210 与 k=45@212 见证,均为 OEIS A008407 最优直径)
--   B. k=46 的 14 个下行见证 (直径 246..216) 的可容许性 + 直径断言 (SAT 侧);
--   C. 小 k (k=2..14) 的精确最小性 H(k) (对直径 < H(k) 的穷举搜索)。
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

-- ############################# 3. Part A:六个关键见证 #############################
-- 对每个 (k, d) 证明:见证元组可容许、直径恰为 d、从而 H(k) ≤ d。
-- 注意:UNSAT 侧 (不存在直径 < d 的可容许 k 元组) 是外部精确搜索的结果,
-- 本文件不作形式化,也不使用 sorry/axiom。

-- k=43, d=200:见证元组 (升序,min 0,max 200,43 个元素)
def witness_k43_d200 : List Nat := [0, 2, 6, 8, 12, 18, 20, 26, 30, 32, 36, 42, 48, 50, 56, 62, 68, 72, 78, 86, 90, 96, 98, 102, 110, 116, 120, 128, 132, 138, 140, 146, 152, 156, 158, 162, 168, 176, 182, 186, 188, 198, 200]

-- 可容许性:对每个素数 p ≤ 43,模 p 剩余类数 < p (native_decide 直接计算验证)
theorem witness_admissible_k43_d200 : admissible 43 witness_k43_d200 = true := by
  native_decide

-- 直径 (max − min) 恰为 200
theorem witness_diameter_k43_d200 : diameter witness_k43_d200 = 200 := by
  native_decide

-- 存在直径恰为 200 的可容许 43 元组,即 H(43) ≤ 200
theorem H43_le_200 : ∃ t : List Nat, t.length = 43 ∧ admissible 43 t = true ∧ diameter t = 200 := by
  refine ⟨witness_k43_d200, ?_, ?_, ?_⟩ <;> native_decide

-- k=46, d=216:见证元组 (升序,min 0,max 216,46 个元素)
def witness_k46_d216 : List Nat := [0, 2, 6, 8, 12, 18, 20, 26, 30, 32, 36, 42, 48, 50, 56, 62, 68, 72, 78, 86, 90, 96, 98, 102, 110, 116, 120, 128, 132, 138, 140, 146, 152, 156, 158, 162, 168, 176, 182, 186, 188, 198, 200, 210, 212, 216]

-- 可容许性:对每个素数 p ≤ 46,模 p 剩余类数 < p (native_decide 直接计算验证)
theorem witness_admissible_k46_d216 : admissible 46 witness_k46_d216 = true := by
  native_decide

-- 直径 (max − min) 恰为 216
theorem witness_diameter_k46_d216 : diameter witness_k46_d216 = 216 := by
  native_decide

-- 存在直径恰为 216 的可容许 46 元组,即 H(46) ≤ 216
theorem H46_le_216 : ∃ t : List Nat, t.length = 46 ∧ admissible 46 t = true ∧ diameter t = 216 := by
  refine ⟨witness_k46_d216, ?_, ?_, ?_⟩ <;> native_decide

-- k=47, d=226:见证元组 (升序,min 0,max 226,47 个元素)
def witness_k47_d226 : List Nat := [0, 4, 6, 10, 12, 16, 24, 30, 34, 40, 42, 46, 52, 54, 60, 70, 72, 76, 82, 84, 90, 94, 96, 112, 114, 130, 132, 136, 142, 144, 150, 154, 156, 160, 166, 172, 174, 180, 184, 186, 192, 196, 210, 214, 220, 222, 226]

-- 可容许性:对每个素数 p ≤ 47,模 p 剩余类数 < p (native_decide 直接计算验证)
theorem witness_admissible_k47_d226 : admissible 47 witness_k47_d226 = true := by
  native_decide

-- 直径 (max − min) 恰为 226
theorem witness_diameter_k47_d226 : diameter witness_k47_d226 = 226 := by
  native_decide

-- 存在直径恰为 226 的可容许 47 元组,即 H(47) ≤ 226
theorem H47_le_226 : ∃ t : List Nat, t.length = 47 ∧ admissible 47 t = true ∧ diameter t = 226 := by
  refine ⟨witness_k47_d226, ?_, ?_, ?_⟩ <;> native_decide

-- k=48, d=236:见证元组 (升序,min 0,max 236,48 个元素)
def witness_k48_d236 : List Nat := [0, 2, 6, 8, 12, 20, 26, 30, 32, 36, 42, 48, 50, 56, 60, 68, 72, 78, 86, 92, 98, 102, 110, 116, 120, 126, 132, 138, 140, 146, 152, 156, 158, 162, 168, 170, 176, 180, 182, 186, 188, 210, 212, 218, 222, 228, 230, 236]

-- 可容许性:对每个素数 p ≤ 48,模 p 剩余类数 < p (native_decide 直接计算验证)
theorem witness_admissible_k48_d236 : admissible 48 witness_k48_d236 = true := by
  native_decide

-- 直径 (max − min) 恰为 236
theorem witness_diameter_k48_d236 : diameter witness_k48_d236 = 236 := by
  native_decide

-- 存在直径恰为 236 的可容许 48 元组,即 H(48) ≤ 236
theorem H48_le_236 : ∃ t : List Nat, t.length = 48 ∧ admissible 48 t = true ∧ diameter t = 236 := by
  refine ⟨witness_k48_d236, ?_, ?_, ?_⟩ <;> native_decide

-- k=49, d=240:见证元组 (升序,min 0,max 240,49 个元素)
def witness_k49_d240 : List Nat := [0, 2, 6, 8, 12, 20, 26, 30, 32, 36, 42, 48, 50, 56, 60, 68, 72, 78, 86, 92, 98, 102, 110, 116, 120, 126, 132, 138, 140, 146, 152, 156, 158, 162, 168, 170, 176, 180, 182, 186, 188, 210, 212, 218, 222, 228, 230, 236, 240]

-- 可容许性:对每个素数 p ≤ 49,模 p 剩余类数 < p (native_decide 直接计算验证)
theorem witness_admissible_k49_d240 : admissible 49 witness_k49_d240 = true := by
  native_decide

-- 直径 (max − min) 恰为 240
theorem witness_diameter_k49_d240 : diameter witness_k49_d240 = 240 := by
  native_decide

-- 存在直径恰为 240 的可容许 49 元组,即 H(49) ≤ 240
theorem H49_le_240 : ∃ t : List Nat, t.length = 49 ∧ admissible 49 t = true ∧ diameter t = 240 := by
  refine ⟨witness_k49_d240, ?_, ?_, ?_⟩ <;> native_decide

-- k=50, d=246:见证元组 (升序,min 0,max 246,50 个元素)
def witness_k50_d246 : List Nat := [0, 2, 6, 8, 12, 18, 20, 26, 30, 32, 36, 42, 48, 50, 56, 62, 68, 72, 78, 86, 90, 96, 98, 102, 110, 116, 120, 128, 132, 138, 140, 146, 152, 156, 158, 162, 168, 176, 182, 186, 188, 198, 200, 210, 212, 216, 230, 240, 242, 246]

-- 可容许性:对每个素数 p ≤ 50,模 p 剩余类数 < p (native_decide 直接计算验证)
theorem witness_admissible_k50_d246 : admissible 50 witness_k50_d246 = true := by
  native_decide

-- 直径 (max − min) 恰为 246
theorem witness_diameter_k50_d246 : diameter witness_k50_d246 = 246 := by
  native_decide

-- 存在直径恰为 246 的可容许 50 元组,即 H(50) ≤ 246
theorem H50_le_246 : ∃ t : List Nat, t.length = 50 ∧ admissible 50 t = true ∧ diameter t = 246 := by
  refine ⟨witness_k50_d246, ?_, ?_, ?_⟩ <;> native_decide


-- ############################# 4. Part B:k=46 的 14 个下行见证 #############################
-- 每个见证都是 46 元可容许元组,直径分别从 246 降到 216 (SAT 侧;UNSAT 侧不作形式化)。
-- 定理形式:admissible 46 t = true ∧ diameter t = d

-- k=46, d=246:246 元见证 (升序,min 0,max 246,46 个元素)
def witness46_d246 : List Nat := [0, 2, 6, 8, 12, 18, 20, 26, 30, 32, 36, 42, 48, 50, 56, 62, 68, 72, 78, 86, 90, 96, 98, 102, 110, 116, 120, 128, 132, 138, 140, 146, 152, 156, 158, 162, 168, 176, 182, 186, 188, 198, 200, 210, 212, 246]

-- 可容许且直径恰为 246
theorem witness46_d246_ok : admissible 46 witness46_d246 = true ∧ diameter witness46_d246 = 246 := by
  native_decide

-- k=46, d=244:244 元见证 (升序,min 0,max 244,46 个元素)
def witness46_d244 : List Nat := [0, 4, 6, 10, 12, 16, 24, 30, 34, 40, 42, 46, 52, 54, 60, 66, 70, 72, 76, 82, 84, 90, 94, 112, 114, 132, 136, 142, 144, 150, 154, 156, 160, 166, 172, 174, 180, 184, 186, 192, 196, 202, 210, 214, 220, 244]

-- 可容许且直径恰为 244
theorem witness46_d244_ok : admissible 46 witness46_d244 = true ∧ diameter witness46_d244 = 244 := by
  native_decide

-- k=46, d=242:242 元见证 (升序,min 0,max 242,46 个元素)
def witness46_d242 : List Nat := [0, 2, 6, 8, 12, 18, 20, 26, 30, 32, 36, 42, 48, 50, 56, 62, 68, 72, 78, 86, 90, 96, 98, 102, 110, 116, 120, 128, 132, 138, 140, 146, 152, 156, 158, 162, 168, 176, 182, 186, 188, 198, 200, 210, 212, 242]

-- 可容许且直径恰为 242
theorem witness46_d242_ok : admissible 46 witness46_d242 = true ∧ diameter witness46_d242 = 242 := by
  native_decide

-- k=46, d=240:240 元见证 (升序,min 0,max 240,46 个元素)
def witness46_d240 : List Nat := [0, 2, 6, 8, 12, 18, 20, 26, 30, 32, 36, 42, 48, 50, 56, 62, 68, 72, 78, 86, 90, 96, 98, 102, 110, 116, 120, 128, 132, 138, 140, 146, 152, 156, 158, 162, 168, 176, 182, 186, 188, 198, 200, 210, 212, 240]

-- 可容许且直径恰为 240
theorem witness46_d240_ok : admissible 46 witness46_d240 = true ∧ diameter witness46_d240 = 240 := by
  native_decide

-- k=46, d=238:238 元见证 (升序,min 0,max 238,46 个元素)
def witness46_d238 : List Nat := [0, 4, 6, 10, 16, 18, 24, 28, 30, 34, 40, 46, 48, 54, 58, 60, 66, 70, 76, 84, 88, 94, 96, 100, 114, 118, 126, 136, 138, 144, 150, 154, 156, 160, 178, 180, 184, 186, 198, 208, 210, 214, 216, 228, 234, 238]

-- 可容许且直径恰为 238
theorem witness46_d238_ok : admissible 46 witness46_d238 = true ∧ diameter witness46_d238 = 238 := by
  native_decide

-- k=46, d=236:236 元见证 (升序,min 0,max 236,46 个元素)
def witness46_d236 : List Nat := [0, 2, 6, 8, 12, 18, 20, 26, 30, 32, 42, 48, 56, 60, 62, 68, 72, 86, 90, 92, 96, 98, 110, 116, 120, 126, 132, 138, 140, 152, 156, 158, 162, 170, 176, 182, 186, 188, 198, 200, 210, 216, 222, 228, 230, 236]

-- 可容许且直径恰为 236
theorem witness46_d236_ok : admissible 46 witness46_d236 = true ∧ diameter witness46_d236 = 236 := by
  native_decide

-- k=46, d=234:234 元见证 (升序,min 0,max 234,46 个元素)
def witness46_d234 : List Nat := [0, 2, 6, 12, 14, 20, 24, 26, 30, 36, 42, 44, 50, 54, 56, 66, 72, 80, 90, 92, 104, 110, 114, 120, 122, 126, 132, 134, 140, 146, 152, 156, 170, 174, 176, 180, 182, 192, 204, 206, 210, 212, 222, 224, 230, 234]

-- 可容许且直径恰为 234
theorem witness46_d234_ok : admissible 46 witness46_d234 = true ∧ diameter witness46_d234 = 234 := by
  native_decide

-- k=46, d=232:232 元见证 (升序,min 0,max 232,46 个元素)
def witness46_d232 : List Nat := [0, 4, 6, 10, 12, 22, 24, 34, 36, 40, 42, 46, 54, 60, 64, 66, 76, 82, 84, 90, 94, 102, 106, 112, 124, 126, 130, 132, 136, 144, 150, 160, 166, 172, 180, 186, 190, 192, 196, 202, 204, 210, 214, 216, 220, 232]

-- 可容许且直径恰为 232
theorem witness46_d232_ok : admissible 46 witness46_d232 = true ∧ diameter witness46_d232 = 232 := by
  native_decide

-- k=46, d=230:230 元见证 (升序,min 0,max 230,46 个元素)
def witness46_d230 : List Nat := [0, 2, 6, 8, 12, 18, 20, 26, 30, 32, 36, 42, 48, 50, 56, 62, 68, 72, 78, 86, 90, 96, 98, 102, 110, 116, 120, 128, 132, 138, 140, 146, 152, 156, 158, 162, 168, 176, 182, 186, 188, 198, 200, 210, 212, 230]

-- 可容许且直径恰为 230
theorem witness46_d230_ok : admissible 46 witness46_d230 = true ∧ diameter witness46_d230 = 230 := by
  native_decide

-- k=46, d=228:228 元见证 (升序,min 0,max 228,46 个元素)
def witness46_d228 : List Nat := [0, 2, 6, 8, 12, 18, 20, 26, 30, 36, 42, 48, 50, 56, 62, 68, 72, 78, 86, 90, 96, 98, 102, 110, 116, 120, 128, 132, 138, 140, 146, 152, 156, 158, 162, 176, 180, 182, 186, 188, 198, 200, 210, 212, 216, 228]

-- 可容许且直径恰为 228
theorem witness46_d228_ok : admissible 46 witness46_d228 = true ∧ diameter witness46_d228 = 228 := by
  native_decide

-- k=46, d=226:226 元见证 (升序,min 0,max 226,46 个元素)
def witness46_d226 : List Nat := [0, 4, 6, 10, 12, 16, 24, 30, 34, 40, 42, 46, 52, 54, 60, 66, 70, 72, 76, 82, 84, 90, 94, 112, 114, 132, 136, 142, 144, 150, 154, 156, 160, 166, 172, 174, 180, 184, 186, 192, 196, 202, 210, 214, 220, 226]

-- 可容许且直径恰为 226
theorem witness46_d226_ok : admissible 46 witness46_d226 = true ∧ diameter witness46_d226 = 226 := by
  native_decide

-- k=46, d=222:222 元见证 (升序,min 0,max 222,46 个元素)
def witness46_d222 : List Nat := [0, 2, 6, 8, 12, 20, 26, 30, 36, 38, 42, 48, 50, 56, 66, 68, 72, 78, 80, 86, 90, 92, 108, 110, 126, 128, 132, 138, 140, 146, 150, 152, 156, 162, 168, 170, 176, 180, 182, 188, 192, 206, 210, 216, 218, 222]

-- 可容许且直径恰为 222
theorem witness46_d222_ok : admissible 46 witness46_d222 = true ∧ diameter witness46_d222 = 222 := by
  native_decide

-- k=46, d=218:218 元见证 (升序,min 0,max 218,46 个元素)
def witness46_d218 : List Nat := [0, 2, 6, 8, 12, 18, 20, 26, 30, 32, 36, 42, 48, 50, 56, 62, 68, 72, 78, 86, 90, 96, 98, 102, 110, 116, 120, 128, 132, 138, 140, 146, 152, 156, 158, 162, 180, 182, 186, 188, 198, 200, 210, 212, 216, 218]

-- 可容许且直径恰为 218
theorem witness46_d218_ok : admissible 46 witness46_d218 = true ∧ diameter witness46_d218 = 218 := by
  native_decide

-- k=46, d=216:216 元见证 (升序,min 0,max 216,46 个元素)
def witness46_d216 : List Nat := [0, 2, 6, 8, 12, 18, 20, 26, 30, 32, 36, 42, 48, 50, 56, 62, 68, 72, 78, 86, 90, 96, 98, 102, 110, 116, 120, 128, 132, 138, 140, 146, 152, 156, 158, 162, 168, 176, 182, 186, 188, 198, 200, 210, 212, 216]

-- 可容许且直径恰为 216
theorem witness46_d216_ok : admissible 46 witness46_d216 = true ∧ diameter witness46_d216 = 216 := by
  native_decide


-- ############################# 5. Part C:小 k 精确最小性 H(k) #############################
-- 思路:由平移不变性,直径 ≤ d 的 k 元组可平移为含 0 的 [0,d] 子集;
-- 故 "H(k) = h" 等价于:
--   (存在性) 存在可容许 k 元组直径恰为 h —— 用显式见证 native_decide 证明;
--   (最小性) 对所有 d < h,穷举搜索 existsAdmissibleWithMin0 k d 返回 false —— native_decide
--            直接在原生代码中跑完 C(⌊h/2⌋, k-1) 规模的枚举 (含 0 ⇒ 全偶,见文件头)。
-- 精确值来自 OEIS A008407 与本会话 C 程序对拍:H(2)=2,...,H(8)=26。

-- k=2 见证 (min=0)
def witness_k2 : List Nat := [0, 2]

-- H(2) = 2:存在直径恰为 2 的可容许 2 元组,且不存在直径 < 2 的可容许 2 元组
theorem H2_eq_2 :
    (∃ t : List Nat, t.length = 2 ∧ admissible 2 t = true ∧ diameter t = 2) ∧
    (∀ d : Nat, d < 2 → existsAdmissibleWithMin0 2 d = false) := by
  constructor
  · exact ⟨witness_k2, by native_decide, by native_decide, by native_decide⟩
  · native_decide

-- k=3 见证 (min=0)
def witness_k3 : List Nat := [0, 2, 6]

-- H(3) = 6:存在直径恰为 6 的可容许 3 元组,且不存在直径 < 6 的可容许 3 元组
theorem H3_eq_6 :
    (∃ t : List Nat, t.length = 3 ∧ admissible 3 t = true ∧ diameter t = 6) ∧
    (∀ d : Nat, d < 6 → existsAdmissibleWithMin0 3 d = false) := by
  constructor
  · exact ⟨witness_k3, by native_decide, by native_decide, by native_decide⟩
  · native_decide

-- k=4 见证 (min=0)
def witness_k4 : List Nat := [0, 2, 6, 8]

-- H(4) = 8:存在直径恰为 8 的可容许 4 元组,且不存在直径 < 8 的可容许 4 元组
theorem H4_eq_8 :
    (∃ t : List Nat, t.length = 4 ∧ admissible 4 t = true ∧ diameter t = 8) ∧
    (∀ d : Nat, d < 8 → existsAdmissibleWithMin0 4 d = false) := by
  constructor
  · exact ⟨witness_k4, by native_decide, by native_decide, by native_decide⟩
  · native_decide

-- k=5 见证 (min=0)
def witness_k5 : List Nat := [0, 2, 6, 8, 12]

-- H(5) = 12:存在直径恰为 12 的可容许 5 元组,且不存在直径 < 12 的可容许 5 元组
theorem H5_eq_12 :
    (∃ t : List Nat, t.length = 5 ∧ admissible 5 t = true ∧ diameter t = 12) ∧
    (∀ d : Nat, d < 12 → existsAdmissibleWithMin0 5 d = false) := by
  constructor
  · exact ⟨witness_k5, by native_decide, by native_decide, by native_decide⟩
  · native_decide

-- k=6 见证 (min=0)
def witness_k6 : List Nat := [0, 4, 6, 10, 12, 16]

-- H(6) = 16:存在直径恰为 16 的可容许 6 元组,且不存在直径 < 16 的可容许 6 元组
theorem H6_eq_16 :
    (∃ t : List Nat, t.length = 6 ∧ admissible 6 t = true ∧ diameter t = 16) ∧
    (∀ d : Nat, d < 16 → existsAdmissibleWithMin0 6 d = false) := by
  constructor
  · exact ⟨witness_k6, by native_decide, by native_decide, by native_decide⟩
  · native_decide

-- k=7 见证 (min=0)
def witness_k7 : List Nat := [0, 2, 6, 8, 12, 18, 20]

-- H(7) = 20:存在直径恰为 20 的可容许 7 元组,且不存在直径 < 20 的可容许 7 元组
theorem H7_eq_20 :
    (∃ t : List Nat, t.length = 7 ∧ admissible 7 t = true ∧ diameter t = 20) ∧
    (∀ d : Nat, d < 20 → existsAdmissibleWithMin0 7 d = false) := by
  constructor
  · exact ⟨witness_k7, by native_decide, by native_decide, by native_decide⟩
  · native_decide

-- k=8 见证 (min=0)
def witness_k8 : List Nat := [0, 2, 6, 8, 12, 18, 20, 26]

-- H(8) = 26:存在直径恰为 26 的可容许 8 元组,且不存在直径 < 26 的可容许 8 元组
theorem H8_eq_26 :
    (∃ t : List Nat, t.length = 8 ∧ admissible 8 t = true ∧ diameter t = 26) ∧
    (∀ d : Nat, d < 26 → existsAdmissibleWithMin0 8 d = false) := by
  constructor
  · exact ⟨witness_k8, by native_decide, by native_decide, by native_decide⟩
  · native_decide

-- k=9 见证 (min=0)
def witness_k9 : List Nat := [0, 2, 6, 8, 12, 18, 20, 26, 30]

-- H(9) = 30:存在直径恰为 30 的可容许 9 元组,且不存在直径 < 30 的可容许 9 元组
theorem H9_eq_30 :
    (∃ t : List Nat, t.length = 9 ∧ admissible 9 t = true ∧ diameter t = 30) ∧
    (∀ d : Nat, d < 30 → existsAdmissibleWithMin0 9 d = false) := by
  constructor
  · exact ⟨witness_k9, by native_decide, by native_decide, by native_decide⟩
  · native_decide

-- k=10 见证 (min=0)
def witness_k10 : List Nat := [0, 2, 6, 8, 12, 18, 20, 26, 30, 32]

-- H(10) = 32:存在直径恰为 32 的可容许 10 元组,且不存在直径 < 32 的可容许 10 元组
theorem H10_eq_32 :
    (∃ t : List Nat, t.length = 10 ∧ admissible 10 t = true ∧ diameter t = 32) ∧
    (∀ d : Nat, d < 32 → existsAdmissibleWithMin0 10 d = false) := by
  constructor
  · exact ⟨witness_k10, by native_decide, by native_decide, by native_decide⟩
  · native_decide

-- k=11 见证 (min=0)
def witness_k11 : List Nat := [0, 2, 6, 8, 12, 18, 20, 26, 30, 32, 36]

-- H(11) = 36:存在直径恰为 36 的可容许 11 元组,且不存在直径 < 36 的可容许 11 元组
theorem H11_eq_36 :
    (∃ t : List Nat, t.length = 11 ∧ admissible 11 t = true ∧ diameter t = 36) ∧
    (∀ d : Nat, d < 36 → existsAdmissibleWithMin0 11 d = false) := by
  constructor
  · exact ⟨witness_k11, by native_decide, by native_decide, by native_decide⟩
  · native_decide

-- k=12 见证 (min=0)
def witness_k12 : List Nat := [0, 2, 6, 8, 12, 18, 20, 26, 30, 32, 36, 42]

-- H(12) = 42:存在直径恰为 42 的可容许 12 元组,且不存在直径 < 42 的可容许 12 元组
theorem H12_eq_42 :
    (∃ t : List Nat, t.length = 12 ∧ admissible 12 t = true ∧ diameter t = 42) ∧
    (∀ d : Nat, d < 42 → existsAdmissibleWithMin0 12 d = false) := by
  constructor
  · exact ⟨witness_k12, by native_decide, by native_decide, by native_decide⟩
  · native_decide

-- k=13 见证 (min=0)
def witness_k13 : List Nat := [0, 2, 6, 8, 12, 18, 20, 26, 30, 32, 36, 42, 48]

-- H(13) = 48:存在直径恰为 48 的可容许 13 元组,且不存在直径 < 48 的可容许 13 元组
theorem H13_eq_48 :
    (∃ t : List Nat, t.length = 13 ∧ admissible 13 t = true ∧ diameter t = 48) ∧
    (∀ d : Nat, d < 48 → existsAdmissibleWithMin0 13 d = false) := by
  constructor
  · exact ⟨witness_k13, by native_decide, by native_decide, by native_decide⟩
  · native_decide

-- k=14 见证 (min=0)
def witness_k14 : List Nat := [0, 2, 6, 8, 12, 18, 20, 26, 30, 32, 36, 42, 48, 50]

-- H(14) = 50:存在直径恰为 50 的可容许 14 元组,且不存在直径 < 50 的可容许 14 元组
theorem H14_eq_50 :
    (∃ t : List Nat, t.length = 14 ∧ admissible 14 t = true ∧ diameter t = 50) ∧
    (∀ d : Nat, d < 50 → existsAdmissibleWithMin0 14 d = false) := by
  constructor
  · exact ⟨witness_k14, by native_decide, by native_decide, by native_decide⟩
  · native_decide


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
-- ############################# 7. 结构定理 (手写证明,非计算) #############################
-- 本节的定理不依赖计算验证,全部为手写证明 (仅用核心库):
--   F1. 平移不变性: admissible k t = true ⟹ admissible k (t.map (+c)) = true
--        (剩余类整体平移是双射 ⟹ 模 p 剩余类数不变);
--   F2. 存在性: 对任意 k ≥ 1,存在 k 元可容许元组
--        (构造: primorial M = ∏_{素数 p ≤ k} p,元组 [0, M, 2M, ..., (k-1)M],
--         每个素数 p ≤ k 整除 M,故所有元素 ≡ 0 mod p,剩余类数 = 1 < p);
--   F3. 单调性: 删去一个元素仍可容许且直径不增 ⟹ H(k+1) 存在时 H(k) ≤ d。

-- ################### 共享引理 ###################

-- L1: 任意列表去重后是 Nodup 的 (加强为对 filter 子列表也成立,以便归纳)
theorem nodup_eraseDups_filter (l : List Nat) : ∀ q : Nat → Bool, (l.filter q).eraseDups.Nodup := by
  induction l with
  | nil => intro q; simp [List.eraseDups_nil]
  | cons x xs ih =>
      intro q
      by_cases hqx : q x = true
      · rw [List.filter_cons_of_pos hqx]
        rw [List.eraseDups_cons]
        apply List.nodup_cons.mpr
        constructor
        · intro hx
          have hx' : x ∈ (List.filter (fun b => !b == x) (List.filter q xs)).eraseDups := hx
          rw [List.mem_eraseDups] at hx'
          rw [List.mem_filter] at hx'
          have hxx : (x == x) = true := beq_iff_eq.mpr rfl
          have : (!(x == x)) = false := by rw [hxx]; rfl
          rw [this] at hx'
          exact Bool.noConfusion hx'.2
        · rw [List.filter_filter]
          exact ih (fun a => !(a == x) && q a)
      · rw [List.filter_cons_of_neg hqx]
        exact ih q

theorem filter_true (l : List Nat) : List.filter (fun _ : Nat => true) l = l := by
  induction l with
  | nil => rfl
  | cons x xs ih =>
      rw [List.filter_cons_of_pos (rfl : (fun _ : Nat => true) x = true), ih]

theorem nodup_eraseDups (l : List Nat) : l.eraseDups.Nodup := by
  rw [← filter_true l]
  exact nodup_eraseDups_filter l (fun _ => true)

-- L2: 若 a ∈ v,则 v 可分解为 v1 ++ [a] ++ v2
theorem mem_split {a : Nat} {v : List Nat} (h : a ∈ v) : ∃ v1 v2 : List Nat, v = v1 ++ [a] ++ v2 := by
  induction v with
  | nil => simp at h
  | cons x xs ih =>
      rw [List.mem_cons] at h
      rcases h with hx | hxs
      · refine ⟨[], xs, ?_⟩
        simp [hx]
      · rcases ih hxs with ⟨v1, v2, hsplit⟩
        refine ⟨x :: v1, v2, ?_⟩
        rw [hsplit]
        simp [List.cons_append]

-- L3: Nodup + 元素集合包含 ⟹ 长度 ≤
theorem nodup_length_le_of_subset {u v : List Nat}
    (hu : u.Nodup) (hv : v.Nodup) (hsub : ∀ x, x ∈ u → x ∈ v) :
    u.length ≤ v.length := by
  revert v hv hsub
  induction u with
  | nil => intro v hv hsub; simp
  | cons x us ih =>
      intro v hv hsub
      have hx : x ∈ v := hsub x (by simp)
      rcases mem_split hx with ⟨v1, v2, hsplit⟩
      have hxus : ¬ x ∈ us := (List.nodup_cons.mp hu).1
      have hus : us.Nodup := (List.nodup_cons.mp hu).2
      have hsub' : ∀ y, y ∈ us → y ∈ v1 ++ v2 := by
        intro y hy
        have hyv : y ∈ v := hsub y (by simp [hy])
        rw [hsplit] at hyv
        simp [List.mem_append] at hyv
        rcases hyv with hyv1 | hyvx | hyv2
        · exact List.mem_append.mpr (Or.inl hyv1)
        · have hyx : y = x := by simpa using hyvx
          exact False.elim (hxus (by simpa [hyx] using hy))
        · exact List.mem_append.mpr (Or.inr hyv2)
      have hv12 : (v1 ++ v2).Nodup := by
        have hv' : (v1 ++ [x] ++ v2).Nodup := by simpa [hsplit] using hv
        have h1' : (v1 ++ [x]).Nodup := (List.nodup_append.mp hv').1
        have h2' : v2.Nodup := (List.nodup_append.mp hv').2.1
        have h1 : v1.Nodup := (List.nodup_append.mp h1').1
        have hint : ∀ a, a ∈ v1 → ∀ b, b ∈ v2 → a ≠ b := by
          intro a ha b hb hab
          have h1'' : ∀ a, a ∈ v1 ++ [x] → ∀ b, b ∈ v2 → a ≠ b := (List.nodup_append.mp hv').2.2
          exact h1'' a (List.mem_append.mpr (Or.inl ha)) b hb hab
        exact (List.nodup_append.mpr ⟨h1, h2', hint⟩)
      have hle := ih hus hv12 hsub'
      have hsucc : us.length + 1 ≤ (v1 ++ v2).length + 1 := Nat.succ_le_succ hle
      rw [List.length_cons]
      rw [hsplit]
      calc
        us.length + 1 ≤ (v1 ++ v2).length + 1 := hsucc
        _ = v1.length + v2.length + 1 := by rw [List.length_append]
        _ = v1.length + (1 + v2.length) := by
              simp [Nat.add_assoc, Nat.add_comm]
        _ = (v1 ++ [x] ++ v2).length := by
              rw [List.length_append, List.length_append, List.length_singleton]
              simp [Nat.add_comm, Nat.add_left_comm]

-- L4: 单射函数保 Nodup
theorem nodup_map_of_inj {σ : Nat → Nat} {l : List Nat}
    (hσ : ∀ ⦃a⦄, a ∈ l → ∀ ⦃b⦄, b ∈ l → σ a = σ b → a = b) (hl : l.Nodup) :
    (l.map σ).Nodup := by
  induction l with
  | nil => simp
  | cons x xs ih =>
      apply List.nodup_cons.mpr
      constructor
      · intro hx
        rw [List.mem_map] at hx
        rcases hx with ⟨a, ha, hσa⟩
        have hax : a = x := hσ (by simp [ha]) (by simp) hσa
        exact (List.nodup_cons.mp hl).1 (by simpa [hax] using ha)
      · exact ih (fun {a} ha {b} hb h => hσ (by simp [ha]) (by simp [hb]) h) (List.nodup_cons.mp hl).2

-- ################### F3: 单调性 ###################

-- F3-0: max/min 的 foldl 单调
theorem max_le_max_of_le {a b y : Nat} (h : a ≤ b) : max a y ≤ max b y := by
  rcases Nat.le_total y a with hya | hay
  · rw [Nat.max_eq_left hya]
    exact Nat.le_trans h (Nat.le_max_left b y)
  · rw [Nat.max_eq_right hay]
    exact Nat.le_max_right b y

theorem min_le_min_of_le {a b y : Nat} (h : a ≤ b) : min a y ≤ min b y := by
  rcases Nat.le_total a y with hay | hya
  · rw [Nat.min_eq_left hay]
    rcases Nat.le_total b y with hby | hyb
    · rw [Nat.min_eq_left hby]
      exact h
    · rw [Nat.min_eq_right hyb]
      exact hay
  · rw [Nat.min_eq_right hya]
    rcases Nat.le_total y b with hyb | hby
    · rw [Nat.min_eq_right hyb]
      exact Nat.le_refl y
    · rw [Nat.min_eq_left hby]
      exact Nat.le_trans hya h

theorem foldl_max_mono (a b : Nat) (h : a ≤ b) (ys : List Nat) :
    ys.foldl (fun x y => max x y) a ≤ ys.foldl (fun x y => max x y) b := by
  induction ys generalizing a b with
  | nil => exact h
  | cons y ys' ih =>
      simp [List.foldl_cons]
      exact ih (max a y) (max b y) (max_le_max_of_le h)

theorem foldl_min_mono (a b : Nat) (h : a ≤ b) (ys : List Nat) :
    ys.foldl (fun x y => min x y) a ≤ ys.foldl (fun x y => min x y) b := by
  induction ys generalizing a b with
  | nil => exact h
  | cons y ys' ih =>
      simp [List.foldl_cons]
      exact ih (min a y) (min b y) (min_le_min_of_le h)

-- F3-1: 向元组头加入一个元素,模 p 剩余类数不减少 (子列表论证)
theorem residueCount_le_cons (p x : Nat) (t : List Nat) :
    residueCount p t ≤ residueCount p (x :: t) := by
  unfold residueCount
  apply nodup_length_le_of_subset
  · exact nodup_eraseDups (t.map (fun v => v % p))
  · exact nodup_eraseDups ((x :: t).map (fun v => v % p))
  · intro y hy
    rw [List.mem_eraseDups] at hy
    rw [List.mem_eraseDups]
    rw [List.mem_map] at hy ⊢
    rcases hy with ⟨a, ha, hya⟩
    refine ⟨a, ?_, hya⟩
    exact List.mem_cons.mpr (Or.inr ha)

-- F3-2: 删除元组头元素仍可容许 (k+1 元 ⟹ k 元)
theorem admissible_tail {k x : Nat} {t : List Nat} :
    admissible (k + 1) (x :: t) = true → admissible k t = true := by
  intro h
  simp [admissible] at h
  have hlen : t.length = k := by
    have hc : t.length + 1 = k + 1 := by simpa [List.length_cons] using h.1.1
    exact Nat.succ.inj hc
  have hnod : t.Nodup := h.1.2.2
  have hpr : (List.filter (fun p => isPrimeBool p) (List.range (k + 1))).all
        (fun p => residueCount p t < p) = true := by
    rw [List.all_eq_true]
    intro p hp
    rw [List.mem_filter] at hp
    rcases hp with ⟨hpk, hpp⟩
    rw [List.mem_range] at hpk
    have hpk2 : p < k + 2 := by
      exact Nat.lt_succ_of_lt hpk
    have hp' := h.2 p hpk2
    cases hp' with
    | inl hb =>
        have hne : ¬ isPrimeBool p = false := by
          rw [hpp]
          exact fun hh => Bool.noConfusion hh
        exact False.elim (hne hb)
    | inr hlt =>
        have hle : residueCount p t ≤ residueCount p (x :: t) := residueCount_le_cons p x t
        exact decide_eq_true_eq.mpr (Nat.lt_of_le_of_lt hle hlt)
  simp [admissible, hlen, hnod, hpr]

-- F3-3: 删除列表头元素,直径不增
theorem diameter_tail_le {x y : Nat} {ys : List Nat} :
    diameter (y :: ys) ≤ diameter (x :: y :: ys) := by
  unfold diameter
  -- (foldl max y ys) - (foldl min y ys) ≤ (foldl max (max x y) ys) - (foldl min (min x y) ys)
  have hmax : ys.foldl (fun a b => max a b) y ≤ ys.foldl (fun a b => max a b) (max x y) :=
    foldl_max_mono y (max x y) (Nat.le_max_right x y) ys
  have hmin : ys.foldl (fun a b => min a b) (min x y) ≤ ys.foldl (fun a b => min a b) y :=
    foldl_min_mono (min x y) y (Nat.min_le_right x y) ys
  exact Nat.le_trans (Nat.sub_le_sub_left hmin (ys.foldl (fun a b => max a b) y))
    (Nat.sub_le_sub_right hmax (ys.foldl (fun a b => min a b) (min x y)))

-- F3-4: 若存在 k+1 元可容许元组直径 d,则存在 k 元可容许元组直径 ≤ d
-- (删去一个元素仍可容许,直径不增)
theorem exists_admissible_drop {k d : Nat} :
    (∃ t : List Nat, t.length = k + 1 ∧ admissible (k + 1) t = true ∧ diameter t = d) →
    (∃ t : List Nat, t.length = k ∧ admissible k t = true ∧ diameter t ≤ d) := by
  intro h
  rcases h with ⟨t, hlen, hadm, hdiam⟩
  rcases t with rfl | ⟨x, xs⟩
  · exfalso
    exact (Nat.succ_ne_zero k) hlen.symm
  · refine ⟨xs, ?_, ?_, ?_⟩
    · have hc : xs.length + 1 = k + 1 := by simpa [List.length_cons] using hlen
      exact Nat.succ.inj hc
    · exact admissible_tail hadm
    · cases xs with
      | nil => simp [diameter]
      | cons y ys =>
          have hle := diameter_tail_le (x := x) (y := y) (ys := ys)
          calc
            diameter (y :: ys) ≤ diameter (x :: y :: ys) := hle
            _ = d := hdiam

-- ################### F2: 存在性 (所有 k,primorial 构造) ###################

-- primorial:所有 ≤ k 的素数的乘积
def primorial (k : Nat) : Nat :=
  (List.filter (fun p => isPrimeBool p) (List.range (k + 1))).foldl (fun acc p => acc * p) 1

-- foldl 乘积:初始值 b 可提出 (b * 从 1 开始的乘积)
theorem foldl_mul_shift (b : Nat) : ∀ {l : List Nat},
    l.foldl (fun acc p => acc * p) b = b * l.foldl (fun acc p => acc * p) 1 := by
  intro l
  induction l generalizing b with
  | nil => simp [List.foldl_nil, Nat.mul_one]
  | cons y ys ih =>
      simp [List.foldl_cons]
      rw [ih (b * y), ih y, Nat.mul_assoc]

-- 整除乘法: x | z ⟹ x | y * z
theorem dvd_mul_left_factor {x y z : Nat} (h : x ∣ z) : x ∣ y * z := by
  rcases h with ⟨q, hq⟩
  refine ⟨y * q, ?_⟩
  rw [hq]
  calc y * (x * q) = y * x * q := by rw [← Nat.mul_assoc]
       _ = x * y * q := by rw [Nat.mul_comm y x]
       _ = x * (y * q) := by rw [Nat.mul_assoc]

-- foldl 乘积的 cons 展开
theorem foldl_mul_cons (y : Nat) (ys : List Nat) :
    (y :: ys).foldl (fun acc p => acc * p) 1 = y * ys.foldl (fun acc p => acc * p) 1 := by
  rw [List.foldl_cons]
  rw [Nat.one_mul]
  exact foldl_mul_shift y

-- x ∈ l ⟹ x 整除 foldl 乘积
theorem dvd_foldl_mul {l : List Nat} {x : Nat} (hx : x ∈ l) :
    x ∣ l.foldl (fun acc p => acc * p) 1 := by
  induction l with
  | nil => simp at hx
  | cons y ys ih =>
      rw [List.mem_cons] at hx
      cases hx with
      | inl hy =>
          rw [hy, foldl_mul_cons]
          exact Nat.dvd_mul_right y _
      | inr hys =>
          rw [foldl_mul_cons]
          exact dvd_mul_left_factor (ih hys)

-- 素数 p ≤ k ⟹ p | primorial k
theorem prime_dvd_primorial {k p : Nat} (hpk : p ≤ k) (hpp : isPrimeBool p = true) :
    p ∣ primorial k := by
  have hp_in : p ∈ (List.range (k + 1)).filter (fun q => isPrimeBool q) := by
    rw [List.mem_filter]
    constructor
    · rw [List.mem_range]
      exact Nat.lt_succ_of_le hpk
    · exact hpp
  exact dvd_foldl_mul hp_in

-- p | M ⟹ (i * M) % p = 0
theorem mul_dvd_mul_eq_mod_zero {p i M : Nat} (hd : p ∣ M) : (i * M) % p = 0 := by
  rcases hd with ⟨q, hq⟩
  calc (i * M) % p = (i * (p * q)) % p := by rw [hq]
       _ = (p * (i * q)) % p := by
             have hm : i * (p * q) = p * (i * q) := by
               calc i * (p * q) = i * p * q := by rw [← Nat.mul_assoc]
                    _ = p * i * q := by rw [Nat.mul_comm i p]
                    _ = p * (i * q) := by rw [Nat.mul_assoc]
             rw [hm]
       _ = 0 := Nat.mul_mod_right p (i * q)

-- isPrimeBool p = true ⟹ 2 ≤ p
theorem isPrimeBool_true_ge_two {p : Nat} (h : isPrimeBool p = true) : 2 ≤ p := by
  unfold isPrimeBool at h
  by_cases hp : p < 2
  · simp [hp] at h
  · exact Nat.not_lt.mp hp

-- isPrimeBool p = true ⟹ p ≠ 0
theorem isPrimeBool_true_ne_zero {p : Nat} (h : isPrimeBool p = true) : p ≠ 0 := by
  intro hp
  have h2 : 2 ≤ p := isPrimeBool_true_ge_two h
  rw [hp] at h2
  exact (Nat.not_lt_of_ge h2) (by decide : 0 < 2)

-- foldl 乘积非零 (每个因子非零)
theorem foldl_mul_ne_zero {l : List Nat} (hall : ∀ p, p ∈ l → p ≠ 0) :
    l.foldl (fun acc p => acc * p) 1 ≠ 0 := by
  induction l with
  | nil => simp [List.foldl_nil]
  | cons y ys ih =>
      rw [foldl_mul_cons]
      apply Nat.mul_ne_zero
      · exact hall y (by simp)
      · exact ih (fun p hp => hall p (by simp [hp]))

-- primorial k ≠ 0
theorem primorial_ne_zero (k : Nat) : primorial k ≠ 0 := by
  unfold primorial
  apply foldl_mul_ne_zero
  intro p hp
  rw [List.mem_filter] at hp
  exact isPrimeBool_true_ne_zero hp.2

-- 元组 (i * M) 互异 (M ≠ 0 ⟹ ·M 单射,range 互异)
theorem nodup_witness_all_k (k : Nat) :
    ((List.range k).map (fun i => i * primorial k)).Nodup := by
  apply nodup_map_of_inj
  · intro a ha b hb h
    exact Nat.mul_right_cancel (Nat.pos_of_ne_zero (primorial_ne_zero k)) h
  · exact List.nodup_range

-- 全 0 的 replicate 经 filter (!·==0) 后为空
theorem filter_ne_zero_replicate (m : Nat) : List.filter (fun b => !b == 0) (List.replicate m 0) = [] := by
  induction m with
  | zero => simp
  | succ m ih =>
      rw [List.replicate_succ]
      rw [List.filter_cons_of_neg]
      · exact ih
      · decide

-- 非空全 0 列表去重后恰为 [0]
theorem eraseDups_replicate_zero {n : Nat} (hn : 0 < n) : (List.replicate n 0).eraseDups = [0] := by
  cases n with
  | zero => simp at hn
  | succ m =>
      rw [List.replicate_succ]
      rw [List.eraseDups_cons]
      rw [filter_ne_zero_replicate]
      simp

-- 见证元组模 p 剩余类数恰为 1 (p | M 且 k ≥ 1 非空)
theorem residueCount_primorial_one {k p : Nat} (hk : 1 ≤ k) (hpk : p ≤ k) (hpp : isPrimeBool p = true) :
    residueCount p ((List.range k).map (fun i => i * primorial k)) = 1 := by
  unfold residueCount
  have hd : p ∣ primorial k := prime_dvd_primorial hpk hpp
  have hmap : ((List.range k).map (fun i => i * primorial k)).map (fun v => v % p)
      = (List.range k).map (fun i => (i * primorial k) % p) := by
    rw [List.map_map]
    rfl
  have hall0 : (List.range k).map (fun i => (i * primorial k) % p) = (List.range k).map (fun _ => 0) := by
    apply List.map_congr_left
    intro i hi
    exact mul_dvd_mul_eq_mod_zero hd
  rw [hmap, hall0]
  have hrep : (List.range k).map (fun _ => 0) = List.replicate k 0 := by
    change List.map (Function.const Nat 0) (List.range k) = List.replicate k 0
    rw [List.map_const, List.length_range]
  rw [hrep]
  have hkpos : 0 < k := Nat.lt_of_lt_of_le (by decide : 0 < 1) hk
  rw [eraseDups_replicate_zero hkpos]
  simp

-- 主定理:对任意 k ≥ 1,存在 k 元可容许元组
-- (构造:素因子 ≤ k 的 primorial M,取 [0, M, 2M, ..., (k-1)M];
--  每个素数 p ≤ k 整除 M,故所有元素 ≡ 0 mod p,剩余类数 = 1 < p)
def witness_all_k (k : Nat) : List Nat := (List.range k).map (fun i => i * primorial k)

theorem exists_admissible (k : Nat) (hk : 1 ≤ k) :
    ∃ t : List Nat, t.length = k ∧ admissible k t = true := by
  refine ⟨witness_all_k k, ?_, ?_⟩
  · simp [witness_all_k]
  · have hlen : (witness_all_k k).length = k := by simp [witness_all_k]
    have hnod : (witness_all_k k).Nodup := nodup_witness_all_k k
    have hpr : (List.filter (fun p => isPrimeBool p) (List.range (k + 1))).all
        (fun p => residueCount p (witness_all_k k) < p) = true := by
      rw [List.all_eq_true]
      intro p hp
      rw [List.mem_filter] at hp
      rcases hp with ⟨hpk, hpp⟩
      rw [List.mem_range] at hpk
      have hpk' : p ≤ k := Nat.le_of_lt_succ hpk
      have hppos : 0 < p := Nat.lt_of_lt_of_le (by decide : 0 < 2) (isPrimeBool_true_ge_two hpp)
      have hrc : residueCount p (witness_all_k k) = 1 := residueCount_primorial_one hk hpk' hpp
      rw [hrc]
      exact decide_eq_true_eq.mpr (Nat.lt_of_lt_of_le (by decide : 1 < 2) (isPrimeBool_true_ge_two hpp))
    simp [admissible, hlen, hnod, hpr]

-- ################### F1: 平移不变性 ###################

-- 模 p 加法消去 (A < B 情形): (A + c) % p = (B + c) % p 不可能 (A, B < p)
theorem add_mod_left_cancel_lt {p A B c : Nat} (hp : 0 < p)
    (_hAp : A < p) (hBp : B < p) (hAB : A < B)
    (h : (A + c) % p = (B + c) % p) : False := by
  let d := B - A
  have hdlt : d < p := by
    change B - A < p
    exact Nat.lt_of_le_of_lt (Nat.sub_le B A) hBp
  have hdpos : 0 < d := by
    change 0 < B - A
    exact Nat.lt_sub_iff_add_lt.mpr (by simpa using hAB)
  have hB : B = A + d := by
    have hsa : (B - A) + A = B := Nat.sub_add_cancel (Nat.le_of_lt hAB)
    calc B = (B - A) + A := hsa.symm
         _ = A + d := by rw [Nat.add_comm]
  have hEq : (A + c) % p = ((A + c) % p + d) % p := by
    have hB' : (A + c) % p = (A + d + c) % p := by
      rw [hB] at h
      exact h
    calc
      (A + c) % p = (A + d + c) % p := hB'
      _ = ((A + c) % p + d) % p := by
            have hre : A + d + c = (A + c) + d := by
              simp [Nat.add_assoc, Nat.add_comm, Nat.add_left_comm]
            rw [hre, Nat.add_mod]
            rw [Nat.mod_eq_of_lt hdlt]
  have hT : (A + c) % p < p := Nat.mod_lt (A + c) hp
  rcases Nat.lt_or_ge ((A + c) % p + d) p with hTdp | hpTd
  · have hmod : ((A + c) % p + d) % p = (A + c) % p + d := Nat.mod_eq_of_lt hTdp
    have hT' : (A + c) % p = (A + c) % p + d := by
      rw [hmod] at hEq
      exact hEq
    have hd0 : d = 0 := by
      have hEq0 : (A + c) % p + 0 = (A + c) % p + d := by
        calc (A + c) % p + 0 = (A + c) % p := Nat.add_zero _
             _ = (A + c) % p + d := hT'
      exact (Nat.add_left_cancel hEq0).symm
    exact (Nat.ne_of_lt hdpos) hd0.symm
  · have hmod : ((A + c) % p + d) % p = ((A + c) % p + d - p) % p := by
      rw [Nat.mod_eq]
      simp [hp, hpTd]
    have hsub_lt : (A + c) % p + d - p < p :=
      Nat.sub_lt_left_of_lt_add hpTd (Nat.add_lt_add hT hdlt)
    have hmod' : ((A + c) % p + d) % p = (A + c) % p + d - p := by
      rw [hmod]
      exact Nat.mod_eq_of_lt hsub_lt
    have hT' : (A + c) % p = (A + c) % p + d - p := by
      rw [hmod'] at hEq
      exact hEq
    have hEqp : (A + c) % p + p = (A + c) % p + d := by
      calc
        (A + c) % p + p = ((A + c) % p + d - p) + p := by rw [← hT']
        _ = (A + c) % p + d := Nat.sub_add_cancel hpTd
    have hdp : p = d := Nat.add_left_cancel hEqp
    exact (Nat.ne_of_lt hdlt) hdp.symm

-- 模 p 加法可消去: (a + c) % p = (b + c) % p → a % p = b % p
theorem add_mod_left_cancel {p a b c : Nat} (hp : 0 < p) :
    (a + c) % p = (b + c) % p → a % p = b % p := by
  intro h
  have h' : (a % p + c) % p = (b % p + c) % p := by
    simpa [Nat.mod_add_mod] using h
  by_cases hne : a % p = b % p
  · exact hne
  · rcases (Nat.lt_or_gt (a := a % p) (b := b % p)).mp hne with hAB | hBA
    · exact False.elim (add_mod_left_cancel_lt hp (Nat.mod_lt a hp) (Nat.mod_lt b hp) hAB h')
    · exact False.elim (add_mod_left_cancel_lt hp (Nat.mod_lt b hp) (Nat.mod_lt a hp) hBA h'.symm)

-- 剩余类平移 σ(r) = (r + c) % p 在 r < p 上单射
theorem shift_residue_inj {p c r1 r2 : Nat} (hp : 0 < p) (h1 : r1 < p) (h2 : r2 < p) :
    (r1 + c) % p = (r2 + c) % p → r1 = r2 := by
  intro h
  have hmod : r1 % p = r2 % p := add_mod_left_cancel hp h
  rw [Nat.mod_eq_of_lt h1, Nat.mod_eq_of_lt h2] at hmod
  exact hmod

-- 双向子集 + Nodup ⟹ 长度相等
theorem nodup_length_eq_of_same_elems {u v : List Nat} (hu : u.Nodup) (hv : v.Nodup)
    (huv : ∀ x, x ∈ u → x ∈ v) (hvu : ∀ x, x ∈ v → x ∈ u) :
    u.length = v.length := by
  apply Nat.le_antisymm
  · exact nodup_length_le_of_subset hu hv huv
  · exact nodup_length_le_of_subset hv hu hvu

-- σ 在 l 的元素上单射 ⟹ (l.map σ) 与 l 去重后长度相同
theorem eraseDups_length_map_of_inj_on {σ : Nat → Nat} {l : List Nat}
    (hσ : ∀ ⦃a⦄, a ∈ l → ∀ ⦃b⦄, b ∈ l → σ a = σ b → a = b) :
    (l.map σ).eraseDups.length = l.eraseDups.length := by
  have hBmap_nod : (l.eraseDups.map σ).Nodup := by
    apply nodup_map_of_inj
    · intro a ha b hb h
      exact hσ (List.mem_eraseDups.mp ha) (List.mem_eraseDups.mp hb) h
    · exact nodup_eraseDups l
  have hAB : (l.map σ).eraseDups.length = (l.eraseDups.map σ).length := by
    apply nodup_length_eq_of_same_elems
    · exact nodup_eraseDups (l.map σ)
    · exact hBmap_nod
    · intro y hy
      rw [List.mem_eraseDups] at hy
      rw [List.mem_map] at hy
      rcases hy with ⟨a, ha, hya⟩
      rw [List.mem_map]
      refine ⟨a, ?_, hya⟩
      exact List.mem_eraseDups.mpr ha
    · intro y hy
      rw [List.mem_map] at hy
      rcases hy with ⟨a, ha, hya⟩
      rw [List.mem_eraseDups]
      rw [List.mem_map]
      refine ⟨a, List.mem_eraseDups.mp ha, hya⟩
  rw [List.length_map] at hAB
  exact hAB

-- 核心: 平移不改变模 p 剩余类数 (剩余类整体平移是双射)
theorem residueCount_translate (hp : 0 < p) (c : Nat) (t : List Nat) :
    residueCount p t = residueCount p (t.map (fun x => x + c)) := by
  unfold residueCount
  have hmap : (t.map (fun x => x + c)).map (fun v => v % p)
      = (t.map (fun x => x % p)).map (fun r => (r + c) % p) := by
    rw [List.map_map, List.map_map]
    apply List.map_congr_left
    intro x hx
    exact (Nat.mod_add_mod x p c).symm
  rw [hmap]
  symm
  apply eraseDups_length_map_of_inj_on
  intro a ha b hb h
  have hap : a < p := by
    rw [List.mem_map] at ha
    rcases ha with ⟨x, hx, hax⟩
    rw [← hax]
    exact Nat.mod_lt x hp
  have hbp : b < p := by
    rw [List.mem_map] at hb
    rcases hb with ⟨x, hx, hbx⟩
    rw [← hbx]
    exact Nat.mod_lt x hp
  exact shift_residue_inj hp hap hbp h

-- F1 主定理: 可容许性对平移不变 (t ↦ t 逐元素 + c)
theorem admissible_translate {k : Nat} (t : List Nat) (c : Nat) :
    admissible k t = true → admissible k (t.map (fun x => x + c)) = true := by
  intro h
  simp [admissible] at h
  have hlen : (t.map (fun x => x + c)).length = k := by
    rw [List.length_map, h.1.1]
  have hnod : (t.map (fun x => x + c)).Nodup := by
    apply nodup_map_of_inj
    · intro a ha b hb h
      exact Nat.add_right_cancel h
    · exact h.1.2
  have hpr : (List.filter (fun p => isPrimeBool p) (List.range (k + 1))).all
        (fun p => residueCount p (t.map (fun x => x + c)) < p) = true := by
    rw [List.all_eq_true]
    intro p hp
    rw [List.mem_filter] at hp
    rcases hp with ⟨hpk, hpp⟩
    rw [List.mem_range] at hpk
    have hp' := h.2 p hpk
    have hppos : 0 < p := Nat.lt_of_lt_of_le (by decide : 0 < 2) (isPrimeBool_true_ge_two hpp)
    cases hp' with
    | inl hb =>
        have hne : ¬ isPrimeBool p = false := by
          rw [hpp]
          exact fun hh => Bool.noConfusion hh
        exact False.elim (hne hb)
    | inr hlt =>
        have hrc : residueCount p (t.map (fun x => x + c)) = residueCount p t :=
          (residueCount_translate hppos c t).symm
        rw [hrc]
        exact decide_eq_true_eq.mpr hlt
  simp [admissible, hlen, hnod, hpr]

-- k=44 @ 210 见证（本会话独立搜索找到，d=210 为 H(44) 的 OEIS 最优值）
def witness_k44_d210 : List Nat := [0, 2, 6, 8, 12, 18, 20, 26, 30, 32, 36, 42, 48, 50, 56, 62, 68, 72, 78, 86, 90, 96, 98, 102, 110, 116, 120, 128, 132, 138, 140, 146, 152, 156, 158, 162, 168, 176, 182, 186, 188, 198, 200, 210]

theorem witness_admissible_k44_d210 : admissible 44 witness_k44_d210 = true := by
  native_decide

theorem witness_diameter_k44_d210 : diameter witness_k44_d210 = 210 := by
  native_decide

theorem H44_le_210 : ∃ t : List Nat, t.length = 44 ∧ admissible 44 t = true ∧ diameter t = 210 := by
  refine ⟨witness_k44_d210, ?_, ?_, ?_⟩ <;> native_decide

-- k=45 @ 212 见证（独立搜索找到，d=212 为 H(45) 的 OEIS 最优值）
def witness_k45_d212 : List Nat := [0, 2, 6, 8, 12, 18, 20, 26, 30, 32, 36, 42, 48, 50, 56, 62, 68, 72, 78, 86, 90, 96, 98, 102, 110, 116, 120, 128, 132, 138, 140, 146, 152, 156, 158, 162, 168, 176, 182, 186, 188, 198, 200, 210, 212]

theorem witness_admissible_k45_d212 : admissible 45 witness_k45_d212 = true := by
  native_decide

theorem witness_diameter_k45_d212 : diameter witness_k45_d212 = 212 := by
  native_decide

theorem H45_le_212 : ∃ t : List Nat, t.length = 45 ∧ admissible 45 t = true ∧ diameter t = 212 := by
  refine ⟨witness_k45_d212, ?_, ?_, ?_⟩ <;> native_decide

-- ############################# 8. 主定理模块:孪生素数间隔纪录的 SAT 侧 #############################
-- 孪生素数间隔纪录 (prime gap record) 的 SAT 侧核心存在性定理。
-- 对每个 (k, d) ∈ {(50,246),(46,216),(45,212),(44,210),(43,200)} 断言 H(k) ≤ d,
-- 即存在 k 元可容许元组,其直径恰为 d。
-- 全部证明均为 native_decide 机器计算 (零 sorry / 零 axiom);
-- 见证直接复用上文已机器验证的 witness_k50_d246 等 (与 sorted_witnesses.json 逐项一致)。

-- 主定理:H(50) ≤ 246 (Polymath8b 纪录见证)。
-- Maynard 筛法结合该 SAT 侧结果推出 "素数间隔 ≤ 246 无穷多" (分析侧,不在本文件形式化)。
theorem twin_prime_gap_record_sat_side :
    ∃ t : List Nat, t.length = 50 ∧ admissible 50 t = true ∧ diameter t = 246 := by
  refine ⟨witness_k50_d246, ?_, ?_, ?_⟩ <;> native_decide

-- H(46) ≤ 216
theorem twin_prime_gap_sat_side_k46 :
    ∃ t : List Nat, t.length = 46 ∧ admissible 46 t = true ∧ diameter t = 216 := by
  refine ⟨witness_k46_d216, ?_, ?_, ?_⟩ <;> native_decide

-- H(45) ≤ 212
theorem twin_prime_gap_sat_side_k45 :
    ∃ t : List Nat, t.length = 45 ∧ admissible 45 t = true ∧ diameter t = 212 := by
  refine ⟨witness_k45_d212, ?_, ?_, ?_⟩ <;> native_decide

-- H(44) ≤ 210
theorem twin_prime_gap_sat_side_k44 :
    ∃ t : List Nat, t.length = 44 ∧ admissible 44 t = true ∧ diameter t = 210 := by
  refine ⟨witness_k44_d210, ?_, ?_, ?_⟩ <;> native_decide

-- H(43) ≤ 200
theorem twin_prime_gap_sat_side_k43 :
    ∃ t : List Nat, t.length = 43 ∧ admissible 43 t = true ∧ diameter t = 200 := by
  refine ⟨witness_k43_d200, ?_, ?_, ?_⟩ <;> native_decide

-- 结构观察:k44/k45/k46/k50 见证均以 (JSON 中经核对的) k43 见证为公共前缀,
-- 与第 7 节单调性结构定理一致 (见证嵌套,直径随之增长)。
theorem k44_witness_extends_k43 : witness_k44_d210 = witness_k43_d200 ++ [210] := by
  native_decide

theorem k45_witness_extends_k44 : witness_k45_d212 = witness_k44_d210 ++ [212] := by
  native_decide
