import Sound
import lean_certs.cert_27_102

open CertVerify

theorem H27_gt_102 : ¬ ∃ t : List Nat, admissible 27 t = true ∧ diameter t ≤ 102 := by
  exact certValidRoot_sound (k := 27) (d := 102) (c := cert_27_102) (by native_decide)
