import Sound
import lean_certs.cert_16_58

open CertVerify

theorem H16_gt_58 : ¬ ∃ t : List Nat, admissible 16 t = true ∧ diameter t ≤ 58 := by
  exact certValidRoot_sound (k := 16) (d := 58) (c := cert_16_58) (by native_decide)
