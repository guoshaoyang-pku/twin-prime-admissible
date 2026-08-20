import Sound
import lean_certs.cert_42_116

open CertVerify

theorem H42_gt_116 : ¬ ∃ t : List Nat, admissible 42 t = true ∧ diameter t ≤ 116 := by
  exact certValidRoot_sound (k := 42) (d := 116) (c := cert_42_116) (by native_decide)
