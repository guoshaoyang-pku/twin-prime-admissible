import Sound
import lean_certs.cert_29_90

open CertVerify

theorem H29_gt_90 : ¬ ∃ t : List Nat, admissible 29 t = true ∧ diameter t ≤ 90 := by
  exact certValidRoot_sound (k := 29) (d := 90) (c := cert_29_90) (by native_decide)
