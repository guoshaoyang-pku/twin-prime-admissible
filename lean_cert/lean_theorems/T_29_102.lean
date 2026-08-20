import Sound
import lean_certs.cert_29_102

open CertVerify

theorem H29_gt_102 : ¬ ∃ t : List Nat, admissible 29 t = true ∧ diameter t ≤ 102 := by
  exact certValidRoot_sound (k := 29) (d := 102) (c := cert_29_102) (by native_decide)
