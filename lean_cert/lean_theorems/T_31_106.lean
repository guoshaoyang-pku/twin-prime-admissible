import Sound
import lean_certs.cert_31_106

open CertVerify

theorem H31_gt_106 : ¬ ∃ t : List Nat, admissible 31 t = true ∧ diameter t ≤ 106 := by
  exact certValidRoot_sound (k := 31) (d := 106) (c := cert_31_106) (by native_decide)
