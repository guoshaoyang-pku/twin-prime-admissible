import Sound
import lean_certs.cert_49_106

open CertVerify

theorem H49_gt_106 : ¬ ∃ t : List Nat, admissible 49 t = true ∧ diameter t ≤ 106 := by
  exact certValidRoot_sound (k := 49) (d := 106) (c := cert_49_106) (by native_decide)
