import Sound
import lean_certs.cert_41_82

open CertVerify

theorem H41_gt_82 : ¬ ∃ t : List Nat, admissible 41 t = true ∧ diameter t ≤ 82 := by
  exact certValidRoot_sound (k := 41) (d := 82) (c := cert_41_82) (by native_decide)
