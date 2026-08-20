import Sound
import lean_certs.cert_38_106

open CertVerify

theorem H38_gt_106 : ¬ ∃ t : List Nat, admissible 38 t = true ∧ diameter t ≤ 106 := by
  exact certValidRoot_sound (k := 38) (d := 106) (c := cert_38_106) (by native_decide)
