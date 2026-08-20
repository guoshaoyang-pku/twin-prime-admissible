import Sound
import lean_certs.cert_34_82

open CertVerify

theorem H34_gt_82 : ¬ ∃ t : List Nat, admissible 34 t = true ∧ diameter t ≤ 82 := by
  exact certValidRoot_sound (k := 34) (d := 82) (c := cert_34_82) (by native_decide)
