import Sound
import lean_certs.cert_29_70

open CertVerify

theorem H29_gt_70 : ¬ ∃ t : List Nat, admissible 29 t = true ∧ diameter t ≤ 70 := by
  exact certValidRoot_sound (k := 29) (d := 70) (c := cert_29_70) (by native_decide)
