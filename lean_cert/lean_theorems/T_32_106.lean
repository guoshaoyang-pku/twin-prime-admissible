import Sound
import lean_certs.cert_32_106

open CertVerify

theorem H32_gt_106 : ¬ ∃ t : List Nat, admissible 32 t = true ∧ diameter t ≤ 106 := by
  exact certValidRoot_sound (k := 32) (d := 106) (c := cert_32_106) (by native_decide)
