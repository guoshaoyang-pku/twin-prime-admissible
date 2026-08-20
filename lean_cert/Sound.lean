/-
# Sound.lean — CertVerify 的可靠性证明 (soundness)

证明 certValidRoot c k d = true ⟹ ¬ ∃ t, admissible k t ∧ diameter t ≤ d.

结构:
  1. List 基础引理 (filter 长度, Nodup 子集长度)
  2. 幸存计数单调性 (加禁类不减幸存)
  3. 平移: 直径 ≤ d 的可容许元组 ⟹ 含 0 且 ⊆ [0,d] 的可容许元组 (模算术)
  4. 判定等价: 无含 0 可容许元组 ⟸ 所有非零分配幸存 < k
  5. 证书归纳 soundness
  6. 主定理
-/
import CertVerify

namespace CertVerify

open List

-- ================= 1. List 基础 =================

-- filter 谓词蕴含 ⟹ 长度 ≤
theorem filter_le_of_pred_imp {α : Type} {l : List α} {p q : α → Bool}
    (h : ∀ x, p x = true → q x = true) : (l.filter p).length ≤ (l.filter q).length := by
  induction l with
  | nil => simp
  | cons x xs ih =>
      by_cases hp : p x = true
      · have hq : q x = true := h x hp
        simp [hp, hq, ih, Nat.succ_le_succ]
      · by_cases hq : q x = true
        · simp [hp, hq]
          exact Nat.le_trans ih (Nat.le_succ _)
        · simp [hp, hq, ih]

-- 成员蕴含的 filter 子集: p 蕴含 q (作为 Prop 蕴含, 对 filter 谓词用 Bool)
theorem mem_filter_imp {α : Type} {l : List α} {p q : α → Bool}
    (h : ∀ x, p x = true → q x = true) {x : α} (hx : x ∈ l.filter p) : x ∈ l.filter q := by
  have hx1 : x ∈ l := by
    simpa using (List.mem_filter.mp hx).1
  have hx2 : p x = true := by
    simpa using (List.mem_filter.mp hx).2
  have hq : q x = true := h x hx2
  exact List.mem_filter.mpr ⟨hx1, hq⟩

-- Nodup 子集 ⟹ 长度 ≤ (u ⊆ v 且 u 无重复)
theorem nodup_subset_length_le {u v : List Nat}
    (h : u ⊆ v) (hu : u.Nodup) : u.length ≤ v.length := by
  induction u generalizing v with
  | nil => simp
  | cons x xs ih =>
      cases hu with
      | cons hrel htail =>
      have hx : x ∈ v := h (by simp)
      have hsub : xs ⊆ v.erase x := by
        intro y hy
        have hyv : y ∈ v := h (by simp [hy])
        have hne : y ≠ x := by
          intro hyx
          have : x ∈ xs := by simpa [hyx] using hy
          exact (hrel x this) rfl
        simpa [hne] using hyv
      have hlen : v.length = (v.erase x).length + 1 := by
        rw [List.length_erase_of_mem hx]
        have hpos : 0 < v.length := by
          exact List.length_pos_of_mem hx
        omega
      have ih' : xs.length ≤ (v.erase x).length := ih (v := v.erase x) hsub htail
      rw [hlen]
      exact Nat.succ_le_succ ih'

-- ================= 2. 幸存计数单调性 =================

-- assigns 的 all 蕴含 (a ⊆ b 的元素集)
theorem all_append_imp {α : Type} {p : α → Bool} {a extra : List α}
    (h : (a ++ extra).all p = true) : a.all p = true := by
  induction a with
  | nil => simp
  | cons x xs ih =>
      simp at h
      have hall : ∀ x ∈ xs ++ extra, p x = true := by
        intro y hy
        rw [List.mem_append] at hy
        cases hy with
        | inl hy1 => exact h.2.1 y hy1
        | inr hy2 => exact h.2.2 y hy2
      simpa using ⟨h.1, h.2.1⟩

-- survivorCount: 增加禁类 (a ⊆ b) ⟹ 幸存数不增
theorem survivorCount_mono {d : Nat} {a b : List (Nat × Nat)}
    (h : b = a ++ extra) : survivorCount d b ≤ survivorCount d a := by
  unfold survivorCount
  apply filter_le_of_pred_imp
  intro x hx
  -- hx: b.all ... = true ⟹ a.all ... = true
  have hb : a.all (fun q => x % q.1 != q.2) = true := by
    exact all_append_imp (p := fun q => x % q.1 != q.2) (a := a) (extra := extra)
      (by simpa [h] using hx)
  exact hb

-- 叶子剪枝 soundness: 当前幸存 < k ⟹ 任何扩展 < k
theorem survivor_lt_k_of_extend {k d : Nat} {assigns extra : List (Nat × Nat)}
    (h : survivorCount d assigns < k) :
    survivorCount d (assigns ++ extra) < k := by
  have hmono : survivorCount d (assigns ++ extra) ≤ survivorCount d assigns := by
    exact survivorCount_mono (a := assigns) (b := assigns ++ extra) (extra := extra) rfl
  omega

-- ================= 3. 平移 (模算术) =================

-- (x - m) % p = (x % p + (p - m % p)) % p, 当 m ≤ x
theorem mod_sub_eq_mod_add {p m x : Nat} (hp : 0 < p) (hmx : m ≤ x) :
    (x - m) % p = (x % p + (p - m % p)) % p := by
  let r := m % p
  let q := m / p
  have hm : m = q * p + r := by
    have hda := Nat.div_add_mod m p
    have hda' : (m / p) * p + m % p = m := by
      simpa [Nat.mul_comm] using hda
    simpa [q, r] using hda'.symm
  -- RHS = (x % p + (p - r)) % p = (x + (p - r)) % p = ((x - r) + p) % p = (x - r) % p
  have hmodadd : (x % p + (p - r)) % p = (x + (p - r)) % p := by
    simpa using (Nat.mod_add_mod x (p - r) p).symm
  have hxr : x + (p - r) = (x - r) + p := by
    have hrx : r ≤ x := by
      have : r ≤ m := Nat.mod_le m p
      omega
    have hrp : r < p := Nat.mod_lt m hp
    omega
  have hsubp : ((x - r) + p) % p = (x - r) % p := by
    rw [Nat.add_mod]
    simp
  have hR : (x % p + (p - r)) % p = (x - r) % p := by
    rw [hmodadd, hxr, hsubp]
  -- LHS = (x - m) % p = ((x - r) - q*p) % p = (x - r) % p
  have hqle : q * p ≤ x - r := by
    have : q * p + r ≤ x := by simpa [hm] using hmx
    omega
  have hL1 : x - m = (x - r) - q * p := by
    rw [hm]
    omega
  have hL2 : ((x - r) - q * p) % p = (x - r) % p := by
    have hqle' : p * q ≤ x - r := by simpa [Nat.mul_comm] using hqle
    simpa [Nat.mul_comm] using (Nat.sub_mul_mod (x := x - r) (k := q) (n := p) hqle')
  have hL : (x - m) % p = (x - r) % p := by
    rw [hL1, hL2]
  rw [hL, hR]

-- residueCount 对减法平移不变
theorem residueCount_sub {p m : Nat} (hp : 0 < p) (t : List Nat)
    (hm : ∀ x ∈ t, m ≤ x) :
    residueCount p (t.map (fun x => x - m)) = residueCount p t := by
  unfold residueCount
  have hmap : (t.map (fun x => x - m)).map (fun v => v % p)
      = (t.map (fun x => x % p)).map (fun r => (r + (p - m % p)) % p) := by
    rw [List.map_map, List.map_map]
    apply List.map_congr_left
    intro x hx
    exact mod_sub_eq_mod_add hp (hm x hx)
  rw [hmap]
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

-- foldl min a ys ≤ a (seed 是上界)
theorem foldl_min_le_seed {ys : List Nat} {a : Nat} : ys.foldl min a ≤ a := by
  induction ys generalizing a with
  | nil => exact Nat.le_refl a
  | cons y ys' ih =>
      simp [List.foldl_cons]
      exact Nat.le_trans (ih (a := min a y)) (Nat.min_le_left a y)

-- foldl min a ys ≤ x 对 x ∈ ys (seed 任意)
theorem foldl_min_le_of_mem' {ys : List Nat} {x a : Nat} (hx : x ∈ ys) :
    ys.foldl min a ≤ x := by
  induction ys generalizing a with
  | nil => simp at hx
  | cons y ys' ih =>
      cases hx with
      | head =>
          simp [List.foldl_cons]
          exact Nat.le_trans (foldl_min_le_seed (a := min a x) (ys := ys')) (Nat.min_le_right a x)
      | tail y' hxs =>
          simp [List.foldl_cons]
          exact ih hxs

-- foldl min 是 t 的元素的下界
theorem foldl_min_le_of_mem {t : List Nat} {x : Nat} (hx : x ∈ t) :
    (t.foldl min (t.headD 0) ≤ x) := by
  cases t with
  | nil => simp at hx
  | cons y ys =>
      cases hx with
      | head =>
          simp [List.foldl_cons]
          exact foldl_min_le_seed (a := x) (ys := ys)
      | tail y' hxs =>
          simp [List.foldl_cons]
          exact foldl_min_le_of_mem' (a := y) hxs

-- foldl max a ys ≥ a (seed 是下界)
theorem foldl_max_ge_seed {ys : List Nat} {a : Nat} : a ≤ ys.foldl max a := by
  induction ys generalizing a with
  | nil => exact Nat.le_refl a
  | cons y ys' ih =>
      simp [List.foldl_cons]
      exact Nat.le_trans (Nat.le_max_left a y) (ih (a := max a y))

-- foldl max a ys ≥ x 对 x ∈ ys (seed 任意)
theorem foldl_max_ge_of_mem' {ys : List Nat} {x a : Nat} (hx : x ∈ ys) :
    x ≤ ys.foldl max a := by
  induction ys generalizing a with
  | nil => simp at hx
  | cons y ys' ih =>
      cases hx with
      | head =>
          simp [List.foldl_cons]
          exact Nat.le_trans (Nat.le_max_right a x) (foldl_max_ge_seed (a := max a x) (ys := ys'))
      | tail y' hxs =>
          simp [List.foldl_cons]
          exact ih hxs

-- foldl max 是 t 的元素的上界
theorem foldl_max_ge_of_mem {t : List Nat} {x : Nat} (hx : x ∈ t) :
    (x ≤ t.foldl max (t.headD 0)) := by
  cases t with
  | nil => simp at hx
  | cons y ys =>
      cases hx with
      | head =>
          simp [List.foldl_cons]
          exact foldl_max_ge_seed (a := x) (ys := ys)
      | tail y' hxs =>
          simp [List.foldl_cons]
          exact foldl_max_ge_of_mem' (a := y) hxs

-- min 是 t 的元素 (t 非空)
theorem mem_foldl_min {t : List Nat} (ht : t ≠ []) : t.foldl min (t.headD 0) ∈ t := by
  cases t with
  | nil => contradiction
  | cons y ys =>
      have hmain : ∀ a : Nat, ys.foldl min a ∈ a :: ys := by
        clear ht
        intro a
        induction ys generalizing a with
        | nil => simp
        | cons y' ys' ih =>
            simp [List.foldl_cons]
            have hmem := ih (min a y')
            -- 把 foldl 提取为变量, 避免依赖消除失败
            revert hmem
            generalize hg : ys'.foldl min (min a y') = z
            intro hmem
            cases hmem with
            | head =>
                -- z = min a y' (cases 自动 subst)
                have hle : a ≤ y' ∨ y' ≤ a := Nat.le_total a y'
                cases hle with
                | inl h => simp [Nat.min_eq_left h]
                | inr h => simp [Nat.min_eq_right h]
            | tail y'' hmem' =>
                rw [← hg]
                rw [← hg] at hmem'
                exact Or.inr (Or.inr hmem')
      simpa [List.foldl_cons] using hmain y

-- diameter = foldl max - foldl min (非空列表)
theorem diameter_eq_max_sub_min {t : List Nat} (ht : t ≠ []) :
    diameter t = t.foldl max (t.headD 0) - t.foldl min (t.headD 0) := by
  cases t with
  | nil => contradiction
  | cons z zs => simp [diameter]

-- 平移引理: 可容许 + 直径 ≤ d ⟹ 含 0, ⊆ [0,d], 可容许
theorem exists_translated {k d : Nat} (hk : 1 ≤ k) {t : List Nat}
    (hadm : admissible k t = true) (hd : diameter t ≤ d) :
    ∃ t' : List Nat, 0 ∈ t' ∧ t'.all (fun x => x ≤ d) ∧ admissible k t' = true := by
  have htne : t ≠ [] := by
    intro ht
    have hadm' := hadm
    simp [admissible, ht] at hadm'
    omega
  let m := t.foldl min (t.headD 0)
  let t' := t.map (fun x => x - m)
  refine ⟨t', ?_, ?_, ?_⟩
  · -- 0 ∈ t'
    have hm : m ∈ t := mem_foldl_min htne
    rw [List.mem_map]
    exact ⟨m, hm, by simp [m]⟩
  · -- t'.all (≤ d)
    rw [List.all_eq_true]
    intro x hx
    rw [List.mem_map] at hx
    rcases hx with ⟨y, hy, hxy⟩
    rw [← hxy]
    -- y - m ≤ d: y ≤ max t ∧ max - min = diameter ≤ d
    have hym : m ≤ y := foldl_min_le_of_mem hy
    have hmax : y ≤ t.foldl max (t.headD 0) := foldl_max_ge_of_mem hy
    have hdiam : t.foldl max (t.headD 0) - t.foldl min (t.headD 0) ≤ d := by
      rw [← diameter_eq_max_sub_min htne]
      exact hd
    have h1 : y - t.foldl min (t.headD 0) ≤ t.foldl max (t.headD 0) - t.foldl min (t.headD 0) := by
      exact Nat.sub_le_sub_right hmax (t.foldl min (t.headD 0))
    have hym' : m = t.foldl min (t.headD 0) := rfl
    rw [hym']
    exact (decide_eq_true_iff.mpr (Nat.le_trans h1 hdiam))
  · -- admissible k t'
    have hadm' := hadm
    simp [admissible] at hadm'
    unfold admissible
    rw [Bool.and_eq_true, Bool.and_eq_true]
    refine ⟨⟨?_, ?_⟩, ?_⟩
    · -- t'.length = k
      rw [List.length_map]
      simp [hadm'.1.1]
    · -- t'.Nodup: map (x - m) 单射
      have hnod' : t'.Nodup := by
        apply nodup_map_of_inj
        · intro a ha b hb h
          have hma : m ≤ a := foldl_min_le_of_mem ha
          have hmb : m ≤ b := foldl_min_le_of_mem hb
          omega
        · exact hadm'.1.2
      exact (decide_eq_true_iff.mpr hnod')
    · -- 素数条件
      rw [List.all_eq_true]
      intro p hp
      rw [List.mem_filter] at hp
      rcases hp with ⟨hpk, hpp⟩
      rw [List.mem_range] at hpk
      have hpr' := hadm'.2 p hpk
      cases hpr' with
      | inl hb =>
          have hne : ¬ isPrimeBool p = false := by
            rw [hpp]
            exact fun hh => Bool.noConfusion hh
          exact False.elim (hne hb)
      | inr hlt =>
          have hp' : 0 < p := Nat.lt_of_lt_of_le (by decide : 0 < 2) (isPrimeBool_true_ge_two hpp)
          have hsub : residueCount p t' = residueCount p t := by
            unfold t'
            exact residueCount_sub hp' t (fun x hx => foldl_min_le_of_mem hx)
          exact (decide_eq_true_iff.mpr (by rw [hsub]; exact hlt))

-- ================= 4. 判定等价 =================

-- tail 成员蕴含原列表成员
theorem mem_tail_mem {α : Type} {x : α} {l : List α} (h : x ∈ l.tail) : x ∈ l := by
  cases l with
  | nil => simp at h
  | cons y ys => simp at h; exact List.mem_cons.mpr (Or.inr h)

-- range p 无重复
theorem range_nodup (p : Nat) : (List.range p).Nodup := by
  induction p with
  | zero => simp
  | succ p' ih =>
      rw [List.range_succ]
      apply List.nodup_append.mpr
      refine ⟨ih, ?_, ?_⟩
      · simp
      · intro x hx y hy
        rw [List.mem_range] at hx
        simp at hy
        omega

-- 类集长度 < p 且元素 < p ⟹ 存在未覆盖类
theorem exists_lt_not_mem {p : Nat} {L : List Nat} (hn : L.Nodup)
    (hl : L.length < p) (hlt : ∀ y ∈ L, y < p) : ∃ c, c < p ∧ c ∉ L := by
  by_cases h : ∃ c, c < p ∧ c ∉ L
  · exact h
  · -- h : ¬ ∃ c < p, c ∉ L ⟹ ∀ c < p, c ∈ L
    have hcov : List.range p ⊆ L := by
      intro x hx
      rw [List.mem_range] at hx
      by_cases hxL : x ∈ L
      · exact hxL
      · exact False.elim (h ⟨x, hx, hxL⟩)
    have hlen : (List.range p).length ≤ L.length := nodup_subset_length_le hcov (range_nodup p)
    have hle : p ≤ L.length := by simpa using hlen
    exact False.elim (Nat.lt_irrefl p (Nat.lt_of_le_of_lt hle hl))

-- residueCount p t < p ⟹ 存在类 c < p 未被 t 覆盖
theorem exists_missing_class {p : Nat} (hp : 2 ≤ p) {t : List Nat}
    (hc : residueCount p t < p) : ∃ c, c < p ∧ ∀ x ∈ t, x % p ≠ c := by
  unfold residueCount at hc
  let L := (t.map (fun v => v % p)).eraseDups
  have hn : L.Nodup := by
    exact nodup_eraseDups _
  have hl : L.length < p := hc
  have hlt : ∀ y ∈ L, y < p := by
    intro y hy
    rw [List.mem_eraseDups] at hy
    rw [List.mem_map] at hy
    rcases hy with ⟨x, hx, hyx⟩
    rw [← hyx]
    exact Nat.mod_lt x (Nat.lt_of_lt_of_le (by decide : 0 < 2) hp)
  rcases exists_lt_not_mem hn hl hlt with ⟨c, hcp, hcL⟩
  refine ⟨c, hcp, ?_⟩
  intro x hx
  have hmem : x % p ∈ L := by
    rw [List.mem_eraseDups]
    exact List.mem_map.mpr ⟨x, hx, rfl⟩
  exact fun hcx => hcL (by simpa [hcx] using hmem)

-- 0 ∈ t ⟹ 未覆盖类 ≠ 0
theorem missing_class_ne_zero {p : Nat} {t : List Nat} (h0 : 0 ∈ t) {c : Nat}
    (hc : ∀ x ∈ t, x % p ≠ c) : c ≠ 0 := by
  intro hc0
  have h00 : 0 % p ≠ c := by simpa [hc0] using hc 0 h0
  exact False.elim (h00 (by simp [hc0]))

-- t ⊆ 幸存位置集 ⟹ 幸存 ≥ |t|
theorem survivor_ge_of_subset {d : Nat} {assigns : List (Nat × Nat)} {t : List Nat}
    (hsub : t.all (fun x => x ≤ d))
    (hnot : ∀ x ∈ t, assigns.all (fun a => x % a.1 != a.2) = true)
    (hnod : t.Nodup) : survivorCount d assigns ≥ t.length := by
  unfold survivorCount
  have hsub' : t ⊆ (List.range (d + 1)).filter
      (fun x => assigns.all (fun a => x % a.1 != a.2)) := by
    intro x hx
    have hxd' : decide (x ≤ d) = true := List.all_eq_true.mp hsub x hx
    have hxd : x ≤ d := (decide_eq_true_iff.mp hxd')
    have hsurv : assigns.all (fun a => x % a.1 != a.2) = true := hnot x hx
    exact List.mem_filter.mpr ⟨List.mem_range.mpr (Nat.lt_succ_of_le hxd), hsurv⟩
  exact nodup_subset_length_le hsub' hnod

-- 判定等价主引理 (逆否方向)
theorem no_admissible_of_all_assigns_small {k d : Nat} {ps : List Nat}
    (hps : ps = primesUpTo k)
    (hall : ∀ assigns : List (Nat × Nat), allClassesValid assigns ps →
      survivorCount d assigns < k) :
    ¬ ∃ t : List Nat, 0 ∈ t ∧ t.all (fun x => x ≤ d) ∧ admissible k t = true := by
  intro h
  rcases h with ⟨t, h0, hsub, hadm⟩
  -- 从 admissible 提取: length, Nodup, 素数条件
  have hadm' := hadm
  simp [admissible] at hadm'
  have hlen : t.length = k := hadm'.1.1
  have hnod : t.Nodup := hadm'.1.2
  have hk : 1 ≤ k := by
    have : 0 < t.length := List.length_pos_of_mem h0
    omega
  -- 每个素数 p ∈ ps 有未覆盖且非零的类
  have hmissall : ∀ p ∈ ps, ∃ c, c < p ∧ c ≠ 0 ∧ ∀ x ∈ t, x % p ≠ c := by
    intro p hp
    have hpk' : p ∈ primesUpTo k := by simpa [hps] using hp
    simp [primesUpTo] at hpk'
    rcases hpk' with ⟨hpk, hpp⟩
    have hpr' := hadm'.2 p (by omega)
    cases hpr' with
    | inl hb =>
        have hne : ¬ isPrimeBool p = false := by
          rw [hpp]
          exact fun hh => Bool.noConfusion hh
        exact False.elim (hne hb)
    | inr hlt =>
        have hp2 : 2 ≤ p := isPrimeBool_true_ge_two hpp
        rcases exists_missing_class (hp := hp2) (hc := hlt) with ⟨c, hcp, hcnot⟩
        have hc0 : c ≠ 0 := missing_class_ne_zero h0 hcnot
        exact ⟨c, hcp, hc0, hcnot⟩
  -- 归纳构造 assigns
  have hbuild : ∀ ps' : List Nat, (∀ p ∈ ps', ∃ c, c < p ∧ c ≠ 0 ∧ ∀ x ∈ t, x % p ≠ c) →
      ∃ assigns : List (Nat × Nat), allClassesValid assigns ps' ∧
        ∀ a ∈ assigns, ∀ x ∈ t, x % a.1 ≠ a.2 := by
    intro ps'
    induction ps' with
    | nil =>
        intro _
        refine ⟨[], trivial, ?_⟩
        intro a ha
        simp at ha
    | cons p ps'' ih =>
        intro hall
        rcases hall p (by simp) with ⟨c, hcp, hc0, hcnot⟩
        have hrest : ∀ q ∈ ps'', ∃ c, c < q ∧ c ≠ 0 ∧ ∀ x ∈ t, x % q ≠ c := by
          intro q hq
          exact hall q (by simp [hq])
        rcases ih hrest with ⟨assigns, hvalid, hnot⟩
        refine ⟨(p, c) :: assigns, ?_, ?_⟩
        · exact ⟨rfl, (by omega : 1 ≤ c), hcp, hvalid⟩
        · intro a ha
          cases ha with
          | head =>
              exact hcnot
          | tail y' ha' =>
              exact hnot a ha'
  rcases hbuild ps hmissall with ⟨assigns, hvalid, hnota⟩
  -- hall: survivorCount d assigns < k
  have hsmall := hall assigns hvalid
  -- t ⊆ 幸存位置集 ⟹ survivor ≥ t.length = k
  have hnotall : ∀ x ∈ t, assigns.all (fun a => x % a.1 != a.2) = true := by
    intro x hx
    rw [List.all_eq_true]
    intro a ha
    have hnp := hnota a ha x hx
    simpa using (decide_eq_true_iff.mpr hnp)
  have hsurv : t.length ≤ survivorCount d assigns := survivor_ge_of_subset hsub hnotall hnod
  omega

-- ================= 5. 证书 soundness (归纳) =================

-- range (n+1) = 0 :: (range n).map (+1)
theorem range_succ_map : ∀ n : Nat, List.range (n + 1) = 0 :: (List.range n).map (fun x => x + 1) := by
  intro n
  induction n with
  | zero => rfl
  | succ n' ih =>
      calc
        List.range (n' + 1 + 1) = List.range (n' + 1) ++ [n' + 1] := by
          rw [show n' + 1 + 1 = (n' + 1) + 1 by omega]
          rw [List.range_succ]
        _ = (0 :: (List.range n').map (fun x => x + 1)) ++ [n' + 1] := by
          rw [ih]
        _ = 0 :: ((List.range n').map (fun x => x + 1) ++ [(n' + 1)]) := by
          rfl
        _ = 0 :: (List.range (n' + 1)).map (fun x => x + 1) := by
          rw [List.range_succ]
          rw [List.map_append]
          simp [Nat.add_comm]

-- (range (n+1)).headD 0 = 0
theorem headD_range_zero (n : Nat) : (List.range (n + 1)).headD 0 = 0 := by
  rw [range_succ_map]
  rfl

-- x ∈ l ∧ x ≠ l.headD 0 ⟹ x ∈ l.tail
theorem mem_tail_nat {l : List Nat} {x : Nat} (hx : x ∈ l) (hne : x ≠ l.headD 0) : x ∈ l.tail := by
  cases l with
  | nil => simp at hx
  | cons y ys =>
      have hxy : x = y ∨ x ∈ ys := List.mem_cons.mp hx
      cases hxy with
      | inl heq =>
          have : x = (y :: ys).headD 0 := by simp [heq]
          exact False.elim (hne this)
      | inr hxs => exact hxs

-- 1 ≤ c ∧ c < p ⟹ c ∈ (range p).tail
theorem mem_tail_range {p c : Nat} (h1 : 1 ≤ c) (hlt : c < p) : c ∈ (List.range p).tail := by
  have hmem : c ∈ List.range p := List.mem_range.mpr hlt
  have hne : c ≠ (List.range p).headD 0 := by
    cases p with
    | zero => omega
    | succ p' =>
        rw [headD_range_zero p']
        omega
  exact mem_tail_nat hmem hne

-- validateChildren 的中缀定位: classes 中 c 的位置对应 children 中的子节点被验证
theorem validateChildren_mid {classes : List Nat} {children : List Cert} {p k d : Nat}
    {assigns : List (Nat × Nat)} {ps : List Nat}
    (hv : validateChildren classes children p k d assigns ps = true)
    (hl : children.length = classes.length)
    (c : Nat) (hc : c ∈ classes) :
    ∃ (ch : Cert) (chmem : ch ∈ children), ∃ cl1 cl2 : List Nat, ∃ ch1 ch2 : List Cert,
      classes = cl1 ++ [c] ++ cl2 ∧ children = ch1 ++ [ch] ++ ch2 ∧
      ch1.length = cl1.length ∧
      certValid ch k d (assigns ++ [(p, c)]) ps = true := by
  induction classes generalizing children with
  | nil => simp at hc
  | cons x xs ih =>
      cases children with
      | nil => simp at hl
      | cons y ys =>
          cases hc with
          | head =>
              -- x = c (cases 自动), 第一个子节点 y 对应
              have hvy : certValid y k d (assigns ++ [(p, c)]) ps = true := by
                simp [validateChildren] at hv
                exact hv.1
              refine ⟨y, List.Mem.head ys, [], xs, [], ys, rfl, rfl, rfl, ?_⟩
              simpa using hvy
          | tail y' hc' =>
              -- c ∈ xs, 归纳
              have hv' : validateChildren xs ys p k d assigns ps = true := by
                simp [validateChildren] at hv
                exact hv.2
              have hl' : ys.length = xs.length := by
                simp at hl
                omega
              rcases ih hv' hl' hc' with ⟨ch, chmem, cl1, cl2, ch1, ch2, hcls, hchl, hlen1, hval⟩
              refine ⟨ch, List.Mem.tail y chmem, x :: cl1, cl2, y :: ch1, ch2, ?_, ?_, ?_, hval⟩
              · simp [hcls]
              · simp [hchl]
              · simp [hlen1]
-- 证书验证 ⟹ 所有完整分配幸存 < k
theorem certValid_sound_aux {c : Cert} {k d : Nat} {assigns : List (Nat × Nat)} {ps : List Nat}
    (hv : certValid c k d assigns ps = true) :
    ∀ cs : List (Nat × Nat), allClassesValid cs ps → survivorCount d (assigns ++ cs) < k := by
  intro cs hc
  -- 手动 Cert.rec: motive_1 是主命题, motive_2 是"每个子节点都满足"的列表动机
  refine Cert.rec
    (motive_1 := fun c => ∀ k d assigns ps, certValid c k d assigns ps = true →
      ∀ cs, allClassesValid cs ps → survivorCount d (assigns ++ cs) < k)
    (motive_2 := fun children => ∀ ch ∈ children,
      ∀ k d assigns ps, certValid ch k d assigns ps = true →
        ∀ cs, allClassesValid cs ps → survivorCount d (assigns ++ cs) < k)
    ?hleaf ?hbranch ?hnil ?hcons c k d assigns ps hv cs hc
  · -- hleaf: 叶子情形
    intro k d assigns ps hv cs hc
    have hsurv : survivorCount d assigns < k := by
      simpa [certValid] using (decide_eq_true_iff.mp hv)
    exact survivor_lt_k_of_extend hsurv
  · -- hbranch
    intro p classes children ihlist k d assigns ps hv cs hc
    cases ps with
    | nil => simp [certValid] at hv
    | cons p' rest =>
        revert hv
        cases cs with
        | nil => simp [allClassesValid] at hc
        | cons hd cs' =>
            intro hv
            simp [certValid, Bool.and_eq_true] at hv
            -- hv : (((p' = p ∧ 合法) ∧ 覆盖) ∧ 长度) ∧ validateChildren = true
            have hp' : p' = p := hv.1.1.1.1
            have hcov0 : ∀ x, 1 ≤ x → x < 1 + (p - 1) → x ∈ classes := hv.1.1.2
            have hlen : children.length = classes.length := hv.1.2
            have hval : validateChildren classes children p k d assigns rest = true := hv.2
            rcases hd with ⟨pc, cc⟩
            rcases hc with ⟨hpc, hc1, hclt, hc'⟩
            have hccp : cc < p := by
              rw [← hp', ← hpc]
              exact hclt
            have hccmem : cc ∈ classes := by
              exact hcov0 cc hc1 (by omega)
            rcases validateChildren_mid (classes := classes) (children := children)
                hval hlen cc hccmem with ⟨ch, chmem, cl1, cl2, ch1, ch2, hcls, hchl, hlen1, hvalch⟩
            have hsmall := ihlist ch chmem k d (assigns ++ [(p, cc)]) rest hvalch cs' hc'
            have hpc' : pc = p := by omega
            simpa [hpc'] using hsmall
  · -- hnil: 空列表动机
    intro ch hmem
    simp at hmem
  · -- hcons
    intro ch children ihch ihchildren ch' hmem
    cases hmem with
    | head => exact ihch
    | tail y' hmem' => exact ihchildren ch' hmem'

-- ================= 6. 主定理 =================

-- certValidRoot_sound: 证书根验证通过 ⟹ 不存在直径 ≤ d 的可容许 k 元组
theorem certValidRoot_sound {k d : Nat} {c : Cert}
    (hv : certValidRoot c k d = true) : ¬ ∃ t : List Nat, admissible k t = true ∧ diameter t ≤ d := by
  intro h
  rcases h with ⟨t, hadm, hd⟩
  have hk : 1 ≤ k := by
    have hlen : t.length = k := by
      have hadm' := hadm
      simp [admissible] at hadm'
      exact hadm'.1.1
    by_cases hk1 : 1 ≤ k
    · exact hk1
    · have hk0 : k = 0 := by omega
      have hv0 : certValidRoot c 0 d = true := by
        simpa [hk0] using hv
      cases c with
      | leaf => simp [certValidRoot, certValid, primesUpTo] at hv0
      | branch p classes children => simp [certValidRoot, certValid, primesUpTo] at hv0
  rcases exists_translated (k := k) hk hadm hd with ⟨t', h0, hsub, hadm'⟩
  have hroot : certValid c k d [] (primesUpTo k) = true := by
    simpa [certValidRoot] using hv
  have hno : ¬ ∃ t : List Nat, 0 ∈ t ∧ t.all (fun x => x ≤ d) ∧ admissible k t = true := by
    apply no_admissible_of_all_assigns_small (ps := primesUpTo k) rfl
    intro assigns hvalid
    simpa using certValid_sound_aux hroot assigns hvalid
  exact hno ⟨t', h0, hsub, hadm'⟩

end CertVerify
