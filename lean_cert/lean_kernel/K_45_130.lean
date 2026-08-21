import Sound
import lean_certs.cert_45_130

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H45_gt_130_kernel : ¬ ∃ t : List Nat, admissible 45 t = true ∧ diameter t ≤ 130 := by
  exact certValidRoot_sound (k := 45) (d := 130) (c := cert_45_130) (by decide)
