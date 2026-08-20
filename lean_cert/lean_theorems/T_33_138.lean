import Sound
import lean_certs.cert_33_138

open CertVerify

theorem H33_gt_138 : ¬ ∃ t : List Nat, admissible 33 t = true ∧ diameter t ≤ 138 := by
  exact certValidRoot_sound (k := 33) (d := 138) (c := cert_33_138) (by native_decide)
