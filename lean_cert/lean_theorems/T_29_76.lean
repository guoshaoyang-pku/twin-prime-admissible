import Sound
import lean_certs.cert_29_76

open CertVerify

theorem H29_gt_76 : ¬ ∃ t : List Nat, admissible 29 t = true ∧ diameter t ≤ 76 := by
  exact certValidRoot_sound (k := 29) (d := 76) (c := cert_29_76) (by native_decide)
