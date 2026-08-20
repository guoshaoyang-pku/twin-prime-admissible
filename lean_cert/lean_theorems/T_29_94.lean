import Sound
import lean_certs.cert_29_94

open CertVerify

theorem H29_gt_94 : ¬ ∃ t : List Nat, admissible 29 t = true ∧ diameter t ≤ 94 := by
  exact certValidRoot_sound (k := 29) (d := 94) (c := cert_29_94) (by native_decide)
