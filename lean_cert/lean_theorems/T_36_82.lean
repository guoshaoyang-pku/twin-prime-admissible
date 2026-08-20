import Sound
import lean_certs.cert_36_82

open CertVerify

theorem H36_gt_82 : ¬ ∃ t : List Nat, admissible 36 t = true ∧ diameter t ≤ 82 := by
  exact certValidRoot_sound (k := 36) (d := 82) (c := cert_36_82) (by native_decide)
