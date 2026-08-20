import Sound
import lean_certs.cert_25_58

open CertVerify

theorem H25_gt_58 : ¬ ∃ t : List Nat, admissible 25 t = true ∧ diameter t ≤ 58 := by
  exact certValidRoot_sound (k := 25) (d := 58) (c := cert_25_58) (by native_decide)
