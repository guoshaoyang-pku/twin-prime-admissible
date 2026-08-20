import Sound
import lean_certs.cert_30_130

open CertVerify

theorem H30_gt_130 : ¬ ∃ t : List Nat, admissible 30 t = true ∧ diameter t ≤ 130 := by
  exact certValidRoot_sound (k := 30) (d := 130) (c := cert_30_130) (by native_decide)
