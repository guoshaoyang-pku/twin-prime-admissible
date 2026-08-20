import Sound
import lean_certs.cert_27_82

open CertVerify

theorem H27_gt_82 : ¬ ∃ t : List Nat, admissible 27 t = true ∧ diameter t ≤ 82 := by
  exact certValidRoot_sound (k := 27) (d := 82) (c := cert_27_82) (by native_decide)
