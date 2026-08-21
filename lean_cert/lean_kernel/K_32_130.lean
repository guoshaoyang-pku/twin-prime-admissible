import Sound
import lean_certs.cert_32_130

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H32_gt_130_kernel : ¬ ∃ t : List Nat, admissible 32 t = true ∧ diameter t ≤ 130 := by
  exact certValidRoot_sound (k := 32) (d := 130) (c := cert_32_130) (by decide)
