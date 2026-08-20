import Sound
import lean_certs.cert_29_74

open CertVerify

theorem H29_gt_74 : ¬ ∃ t : List Nat, admissible 29 t = true ∧ diameter t ≤ 74 := by
  exact certValidRoot_sound (k := 29) (d := 74) (c := cert_29_74) (by native_decide)
