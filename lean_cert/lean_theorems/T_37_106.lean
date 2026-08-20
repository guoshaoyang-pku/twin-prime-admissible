import Sound
import lean_certs.cert_37_106

open CertVerify

theorem H37_gt_106 : ¬ ∃ t : List Nat, admissible 37 t = true ∧ diameter t ≤ 106 := by
  exact certValidRoot_sound (k := 37) (d := 106) (c := cert_37_106) (by native_decide)
