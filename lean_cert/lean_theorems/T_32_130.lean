import Sound
import lean_certs.cert_32_130

open CertVerify

theorem H32_gt_130 : ¬ ∃ t : List Nat, admissible 32 t = true ∧ diameter t ≤ 130 := by
  exact certValidRoot_sound (k := 32) (d := 130) (c := cert_32_130) (by native_decide)
