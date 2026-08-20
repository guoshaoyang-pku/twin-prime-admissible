import Sound
import lean_certs.cert_29_64

open CertVerify

theorem H29_gt_64 : ¬ ∃ t : List Nat, admissible 29 t = true ∧ diameter t ≤ 64 := by
  exact certValidRoot_sound (k := 29) (d := 64) (c := cert_29_64) (by native_decide)
