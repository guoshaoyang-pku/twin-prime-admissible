import Sound
import lean_certs.cert_29_58

open CertVerify

theorem H29_gt_58 : ¬ ∃ t : List Nat, admissible 29 t = true ∧ diameter t ≤ 58 := by
  exact certValidRoot_sound (k := 29) (d := 58) (c := cert_29_58) (by native_decide)
