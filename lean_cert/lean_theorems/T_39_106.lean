import Sound
import lean_certs.cert_39_106

open CertVerify

theorem H39_gt_106 : ¬ ∃ t : List Nat, admissible 39 t = true ∧ diameter t ≤ 106 := by
  exact certValidRoot_sound (k := 39) (d := 106) (c := cert_39_106) (by native_decide)
