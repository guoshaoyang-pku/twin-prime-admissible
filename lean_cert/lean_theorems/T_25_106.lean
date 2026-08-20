import Sound
import lean_certs.cert_25_106

open CertVerify

theorem H25_gt_106 : ¬ ∃ t : List Nat, admissible 25 t = true ∧ diameter t ≤ 106 := by
  exact certValidRoot_sound (k := 25) (d := 106) (c := cert_25_106) (by native_decide)
