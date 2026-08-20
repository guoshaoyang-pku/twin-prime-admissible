import Sound
import lean_certs.cert_26_106

open CertVerify

theorem H26_gt_106 : ¬ ∃ t : List Nat, admissible 26 t = true ∧ diameter t ≤ 106 := by
  exact certValidRoot_sound (k := 26) (d := 106) (c := cert_26_106) (by native_decide)
