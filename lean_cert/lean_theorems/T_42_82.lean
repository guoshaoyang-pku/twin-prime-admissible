import Sound
import lean_certs.cert_42_82

open CertVerify

theorem H42_gt_82 : ¬ ∃ t : List Nat, admissible 42 t = true ∧ diameter t ≤ 82 := by
  exact certValidRoot_sound (k := 42) (d := 82) (c := cert_42_82) (by native_decide)
