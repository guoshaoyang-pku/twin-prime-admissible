import Sound
import lean_certs.cert_26_82

open CertVerify

theorem H26_gt_82 : ¬ ∃ t : List Nat, admissible 26 t = true ∧ diameter t ≤ 82 := by
  exact certValidRoot_sound (k := 26) (d := 82) (c := cert_26_82) (by native_decide)
