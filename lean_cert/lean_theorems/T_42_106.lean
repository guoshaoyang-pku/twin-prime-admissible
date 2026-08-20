import Sound
import lean_certs.cert_42_106

open CertVerify

theorem H42_gt_106 : ¬ ∃ t : List Nat, admissible 42 t = true ∧ diameter t ≤ 106 := by
  exact certValidRoot_sound (k := 42) (d := 106) (c := cert_42_106) (by native_decide)
