import Sound
import lean_certs.cert_42_114

open CertVerify

theorem H42_gt_114 : ¬ ∃ t : List Nat, admissible 42 t = true ∧ diameter t ≤ 114 := by
  exact certValidRoot_sound (k := 42) (d := 114) (c := cert_42_114) (by native_decide)
