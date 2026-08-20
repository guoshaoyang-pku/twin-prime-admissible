import Sound
import lean_certs.cert_33_80

open CertVerify

theorem H33_gt_80 : ¬ ∃ t : List Nat, admissible 33 t = true ∧ diameter t ≤ 80 := by
  exact certValidRoot_sound (k := 33) (d := 80) (c := cert_33_80) (by native_decide)
