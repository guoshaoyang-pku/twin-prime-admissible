import Sound
import lean_certs.cert_42_108

open CertVerify

theorem H42_gt_108 : ¬ ∃ t : List Nat, admissible 42 t = true ∧ diameter t ≤ 108 := by
  exact certValidRoot_sound (k := 42) (d := 108) (c := cert_42_108) (by native_decide)
