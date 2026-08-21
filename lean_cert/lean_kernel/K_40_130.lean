import Sound
import lean_certs.cert_40_130

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H40_gt_130_kernel : ¬ ∃ t : List Nat, admissible 40 t = true ∧ diameter t ≤ 130 := by
  exact certValidRoot_sound (k := 40) (d := 130) (c := cert_40_130) (by decide)
