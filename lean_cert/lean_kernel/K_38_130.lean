import Sound
import lean_certs.cert_38_130

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H38_gt_130_kernel : ¬ ∃ t : List Nat, admissible 38 t = true ∧ diameter t ≤ 130 := by
  exact certValidRoot_sound (k := 38) (d := 130) (c := cert_38_130) (by decide)
