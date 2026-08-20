import Sound
import lean_certs.cert_33_116

open CertVerify

theorem H33_gt_116 : ¬ ∃ t : List Nat, admissible 33 t = true ∧ diameter t ≤ 116 := by
  exact certValidRoot_sound (k := 33) (d := 116) (c := cert_33_116) (by native_decide)
