import Sound
import lean_certs.cert_29_72

open CertVerify

theorem H29_gt_72 : ¬ ∃ t : List Nat, admissible 29 t = true ∧ diameter t ≤ 72 := by
  exact certValidRoot_sound (k := 29) (d := 72) (c := cert_29_72) (by native_decide)
