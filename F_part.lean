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
