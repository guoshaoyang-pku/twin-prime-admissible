import Sound
import lean_certs.cert_39_82

open CertVerify

theorem H39_gt_82 : ¬ ∃ t : List Nat, admissible 39 t = true ∧ diameter t ≤ 82 := by
  exact certValidRoot_sound (k := 39) (d := 82) (c := cert_39_82) (by native_decide)
