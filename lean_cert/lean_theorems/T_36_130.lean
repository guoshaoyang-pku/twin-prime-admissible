import Sound
import lean_certs.cert_36_130

open CertVerify

theorem H36_gt_130 : ¬ ∃ t : List Nat, admissible 36 t = true ∧ diameter t ≤ 130 := by
  exact certValidRoot_sound (k := 36) (d := 130) (c := cert_36_130) (by native_decide)
