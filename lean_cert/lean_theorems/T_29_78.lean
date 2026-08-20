import Sound
import lean_certs.cert_29_78

open CertVerify

theorem H29_gt_78 : ¬ ∃ t : List Nat, admissible 29 t = true ∧ diameter t ≤ 78 := by
  exact certValidRoot_sound (k := 29) (d := 78) (c := cert_29_78) (by native_decide)
