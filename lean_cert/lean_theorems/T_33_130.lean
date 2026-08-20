import Sound
import lean_certs.cert_33_130

open CertVerify

theorem H33_gt_130 : ¬ ∃ t : List Nat, admissible 33 t = true ∧ diameter t ≤ 130 := by
  exact certValidRoot_sound (k := 33) (d := 130) (c := cert_33_130) (by native_decide)
