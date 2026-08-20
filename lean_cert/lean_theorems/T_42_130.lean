import Sound
import lean_certs.cert_42_130

open CertVerify

theorem H42_gt_130 : ¬ ∃ t : List Nat, admissible 42 t = true ∧ diameter t ≤ 130 := by
  exact certValidRoot_sound (k := 42) (d := 130) (c := cert_42_130) (by native_decide)
