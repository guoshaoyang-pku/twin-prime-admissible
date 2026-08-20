import Sound
import lean_certs.cert_27_58

open CertVerify

theorem H27_gt_58 : ¬ ∃ t : List Nat, admissible 27 t = true ∧ diameter t ≤ 58 := by
  exact certValidRoot_sound (k := 27) (d := 58) (c := cert_27_58) (by native_decide)
