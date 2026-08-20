import Sound
import lean_certs.cert_42_138

open CertVerify

theorem H42_gt_138 : ¬ ∃ t : List Nat, admissible 42 t = true ∧ diameter t ≤ 138 := by
  exact certValidRoot_sound (k := 42) (d := 138) (c := cert_42_138) (by native_decide)
