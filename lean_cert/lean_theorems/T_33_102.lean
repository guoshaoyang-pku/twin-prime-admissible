import Sound
import lean_certs.cert_33_102

open CertVerify

theorem H33_gt_102 : ¬ ∃ t : List Nat, admissible 33 t = true ∧ diameter t ≤ 102 := by
  exact certValidRoot_sound (k := 33) (d := 102) (c := cert_33_102) (by native_decide)
