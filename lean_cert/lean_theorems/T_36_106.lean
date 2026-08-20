import Sound
import lean_certs.cert_36_106

open CertVerify

theorem H36_gt_106 : ¬ ∃ t : List Nat, admissible 36 t = true ∧ diameter t ≤ 106 := by
  exact certValidRoot_sound (k := 36) (d := 106) (c := cert_36_106) (by native_decide)
