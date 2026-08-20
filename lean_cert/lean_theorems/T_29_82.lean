import Sound
import lean_certs.cert_29_82

open CertVerify

theorem H29_gt_82 : ¬ ∃ t : List Nat, admissible 29 t = true ∧ diameter t ≤ 82 := by
  exact certValidRoot_sound (k := 29) (d := 82) (c := cert_29_82) (by native_decide)
