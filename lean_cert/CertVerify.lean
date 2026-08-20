/-
# CertVerify.lean — 算法C 剩余类分配证书的 Lean 验证器

判定 (定理 `certValidRoot_sound`):
  存在直径 ≤ d 的可容许 k 元组
  ⟺ (平移后含 0 且 ⊆ [0,d]) 存在素数分配 (c_p)_{p≤k 素数}, c_p ∈ [1, p-1],
     使幸存位置数 #{x ∈ [0,d] : ∀p, x mod p ≠ c_p} ≥ k.

证书 (Cert): 递归树
  - leaf: 当前分配下幸存 < k (剪枝: 该分支任何完整分配都失败 — 幸存单调)
  - branch p classes children: 素数 p, classes = 枚举的禁类 (须覆盖 [1, p-1]),
    children[i] 对应 classes[i] 的子树.

certValidRoot c k d = true  ⟹  ¬ ∃ t, admissible k t ∧ diameter t ≤ d
-/
import TwinPrimeAdmissible

namespace CertVerify

-- 素数列表 [2..k] (升序)
def primesUpTo (k : Nat) : List Nat :=
  (List.range (k + 1)).tail.filter isPrimeBool

-- 幸存位置计数: [0..d] 中避开所有已分配禁类 (p, c) 的位置数
def survivorCount (d : Nat) (assigns : List (Nat × Nat)) : Nat :=
  ((List.range (d + 1)).filter
    (fun x => assigns.all (fun a => x % a.1 != a.2))).length

-- 证书树
inductive Cert where
  | leaf : Cert
  | branch (p : Nat) (classes : List Nat) (children : List Cert) : Cert
deriving Repr

-- 分配合法性: 与素数列表逐位对应, c ∈ [1, p-1] (长度必须匹配)
def allClassesValid : List (Nat × Nat) → List Nat → Prop
  | [], [] => True
  | (p, c) :: rest, p' :: ps => p = p' ∧ 1 ≤ c ∧ c < p ∧ allClassesValid rest ps
  | _, _ => False

-- 验证子节点与节点 (相互递归, 结构递减: children 尾部 / Cert 子树)
mutual
  def validateChildren (classes : List Nat) (children : List Cert) (p : Nat) (k d : Nat)
      (assigns : List (Nat × Nat)) (ps : List Nat) : Bool :=
    match classes, children with
    | [], [] => true
    | c :: cs, ch :: chs =>
        certValid ch k d (assigns ++ [(p, c)]) ps && validateChildren cs chs p k d assigns ps
    | _, _ => false

  def certValid (c : Cert) (k d : Nat) (assigns : List (Nat × Nat)) (ps : List Nat) : Bool :=
    match c with
    | .leaf => survivorCount d assigns < k
    | .branch p classes children =>
        match ps with
        | [] => false
        | p' :: rest =>
            p' == p &&
            classes.all (fun c => 1 ≤ c && c < p) &&
            (List.range p).tail.all (fun c => c ∈ classes) &&
            children.length == classes.length &&
            validateChildren classes children p k d assigns rest
end

-- 根验证
def certValidRoot (c : Cert) (k d : Nat) : Bool :=
  certValid c k d [] (primesUpTo k)

-- ============ 主定理 (证明见 Sound.lean) ============

end CertVerify
