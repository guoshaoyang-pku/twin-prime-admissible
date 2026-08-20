import Sound
import lean_certs.cert_39_130

open CertVerify

theorem H39_gt_130 : ¬ ∃ t : List Nat, admissible 39 t = true ∧ diameter t ≤ 130 := by
  exact certValidRoot_sound (k := 39) (d := 130) (c := cert_39_130) (by native_decide)
