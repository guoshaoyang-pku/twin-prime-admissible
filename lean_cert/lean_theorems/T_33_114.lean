import Sound
import lean_certs.cert_33_114

open CertVerify

theorem H33_gt_114 : ¬ ∃ t : List Nat, admissible 33 t = true ∧ diameter t ≤ 114 := by
  exact certValidRoot_sound (k := 33) (d := 114) (c := cert_33_114) (by native_decide)
