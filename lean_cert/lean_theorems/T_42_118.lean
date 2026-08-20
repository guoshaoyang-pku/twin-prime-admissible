import Sound
import lean_certs.cert_42_118

open CertVerify

theorem H42_gt_118 : ¬ ∃ t : List Nat, admissible 42 t = true ∧ diameter t ≤ 118 := by
  exact certValidRoot_sound (k := 42) (d := 118) (c := cert_42_118) (by native_decide)
