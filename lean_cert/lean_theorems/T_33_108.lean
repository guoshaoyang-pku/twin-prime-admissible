import Sound
import lean_certs.cert_33_108

open CertVerify

theorem H33_gt_108 : ¬ ∃ t : List Nat, admissible 33 t = true ∧ diameter t ≤ 108 := by
  exact certValidRoot_sound (k := 33) (d := 108) (c := cert_33_108) (by native_decide)
