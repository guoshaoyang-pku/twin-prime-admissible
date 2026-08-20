import Sound
import lean_certs.cert_31_130

open CertVerify

theorem H31_gt_130 : ¬ ∃ t : List Nat, admissible 31 t = true ∧ diameter t ≤ 130 := by
  exact certValidRoot_sound (k := 31) (d := 130) (c := cert_31_130) (by native_decide)
