import Sound
import lean_certs.cert_43_130

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H43_gt_130_kernel : ¬ ∃ t : List Nat, admissible 43 t = true ∧ diameter t ≤ 130 := by
  exact certValidRoot_sound (k := 43) (d := 130) (c := cert_43_130) (by decide)
