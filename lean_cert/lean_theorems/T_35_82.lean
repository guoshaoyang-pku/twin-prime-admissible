import Sound
import lean_certs.cert_35_82

open CertVerify

theorem H35_gt_82 : ¬ ∃ t : List Nat, admissible 35 t = true ∧ diameter t ≤ 82 := by
  exact certValidRoot_sound (k := 35) (d := 82) (c := cert_35_82) (by native_decide)
