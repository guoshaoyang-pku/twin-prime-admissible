import Sound
import lean_certs.cert_41_130

open CertVerify

theorem H41_gt_130 : ¬ ∃ t : List Nat, admissible 41 t = true ∧ diameter t ≤ 130 := by
  exact certValidRoot_sound (k := 41) (d := 130) (c := cert_41_130) (by native_decide)
