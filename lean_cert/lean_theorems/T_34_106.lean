import Sound
import lean_certs.cert_34_106

open CertVerify

theorem H34_gt_106 : ¬ ∃ t : List Nat, admissible 34 t = true ∧ diameter t ≤ 106 := by
  exact certValidRoot_sound (k := 34) (d := 106) (c := cert_34_106) (by native_decide)
