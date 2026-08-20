import Sound
import lean_certs.cert_27_108

open CertVerify

theorem H27_gt_108 : ¬ ∃ t : List Nat, admissible 27 t = true ∧ diameter t ≤ 108 := by
  exact certValidRoot_sound (k := 27) (d := 108) (c := cert_27_108) (by native_decide)
