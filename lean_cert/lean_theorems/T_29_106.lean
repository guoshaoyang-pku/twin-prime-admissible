import Sound
import lean_certs.cert_29_106

open CertVerify

theorem H29_gt_106 : ¬ ∃ t : List Nat, admissible 29 t = true ∧ diameter t ≤ 106 := by
  exact certValidRoot_sound (k := 29) (d := 106) (c := cert_29_106) (by native_decide)
