import Sound
import lean_certs.cert_29_108

open CertVerify

theorem H29_gt_108 : ¬ ∃ t : List Nat, admissible 29 t = true ∧ diameter t ≤ 108 := by
  exact certValidRoot_sound (k := 29) (d := 108) (c := cert_29_108) (by native_decide)
