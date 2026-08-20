import Sound
import lean_certs.cert_42_102

open CertVerify

theorem H42_gt_102 : ¬ ∃ t : List Nat, admissible 42 t = true ∧ diameter t ≤ 102 := by
  exact certValidRoot_sound (k := 42) (d := 102) (c := cert_42_102) (by native_decide)
