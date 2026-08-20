import Sound
import lean_certs.cert_48_106

open CertVerify

theorem H48_gt_106 : ¬ ∃ t : List Nat, admissible 48 t = true ∧ diameter t ≤ 106 := by
  exact certValidRoot_sound (k := 48) (d := 106) (c := cert_48_106) (by native_decide)
