import Sound
import lean_certs.cert_29_116

open CertVerify

theorem H29_gt_116 : ¬ ∃ t : List Nat, admissible 29 t = true ∧ diameter t ≤ 116 := by
  exact certValidRoot_sound (k := 29) (d := 116) (c := cert_29_116) (by native_decide)
