import Sound
import lean_certs.cert_42_156

open CertVerify

theorem H42_gt_156 : ¬ ∃ t : List Nat, admissible 42 t = true ∧ diameter t ≤ 156 := by
  exact certValidRoot_sound (k := 42) (d := 156) (c := cert_42_156) (by native_decide)
