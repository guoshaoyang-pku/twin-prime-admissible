import Sound
import lean_certs.cert_28_82

open CertVerify

theorem H28_gt_82 : ¬ ∃ t : List Nat, admissible 28 t = true ∧ diameter t ≤ 82 := by
  exact certValidRoot_sound (k := 28) (d := 82) (c := cert_28_82) (by native_decide)
