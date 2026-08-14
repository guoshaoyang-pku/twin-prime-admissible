-- 冒烟测试：定义 + native_decide 全流程验证
def isPrimeLoop : Nat → Nat → Bool
| n, 0 => true
| n, d + 1 =>
    let c := n - (d + 1)
    if 2 ≤ c && n % c == 0 then false else isPrimeLoop n d

def isPrimeBool (n : Nat) : Bool :=
  if n < 2 then false else isPrimeLoop n (n - 2)

def residueCount (p : Nat) (t : List Nat) : Nat :=
  (t.map (fun v => v % p)).eraseDups.length

def admissible (k : Nat) (t : List Nat) : Bool :=
  t.length = k && t.Nodup &&
  (List.filter (fun p => isPrimeBool p) (List.range (k + 1))).all
    (fun p => residueCount p t < p)

def diameter (t : List Nat) : Nat :=
  match t with
  | [] => 0
  | x :: xs => (xs.foldl (fun a b => max a b) x) - (xs.foldl (fun a b => min a b) x)

#eval isPrimeBool 43
#eval admissible 3 [0, 2, 6]
#eval diameter [0, 2, 6]
#eval admissible 3 [0, 2, 4]

theorem smoke_adm : admissible 3 [0, 2, 6] = true := by native_decide
theorem smoke_diam : diameter [0, 2, 6] = 6 := by native_decide
theorem smoke_not_adm : admissible 3 [0, 2, 4] = false := by native_decide
