import Sound
import lean_certs.cert_27_116

open CertVerify

theorem H27_gt_116 : ¬ ∃ t : List Nat, admissible 27 t = true ∧ diameter t ≤ 116 := by
  exact certValidRoot_sound (k := 27) (d := 116) (c := cert_27_116) (by native_decide)
