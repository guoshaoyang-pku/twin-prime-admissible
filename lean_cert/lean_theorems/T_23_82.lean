import Sound
import lean_certs.cert_23_82

open CertVerify

theorem H23_gt_82 : ¬ ∃ t : List Nat, admissible 23 t = true ∧ diameter t ≤ 82 := by
  exact certValidRoot_sound (k := 23) (d := 82) (c := cert_23_82) (by native_decide)
