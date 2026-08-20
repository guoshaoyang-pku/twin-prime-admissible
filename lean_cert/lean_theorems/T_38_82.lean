import Sound
import lean_certs.cert_38_82

open CertVerify

theorem H38_gt_82 : ¬ ∃ t : List Nat, admissible 38 t = true ∧ diameter t ≤ 82 := by
  exact certValidRoot_sound (k := 38) (d := 82) (c := cert_38_82) (by native_decide)
