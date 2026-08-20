import Sound
import lean_certs.cert_25_82

open CertVerify

theorem H25_gt_82 : ¬ ∃ t : List Nat, admissible 25 t = true ∧ diameter t ≤ 82 := by
  exact certValidRoot_sound (k := 25) (d := 82) (c := cert_25_82) (by native_decide)
