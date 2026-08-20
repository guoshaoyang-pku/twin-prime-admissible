import Sound
import lean_certs.cert_33_106

open CertVerify

theorem H33_gt_106 : ¬ ∃ t : List Nat, admissible 33 t = true ∧ diameter t ≤ 106 := by
  exact certValidRoot_sound (k := 33) (d := 106) (c := cert_33_106) (by native_decide)
