import Sound
import lean_certs.cert_48_130

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H48_gt_130_kernel : ¬ ∃ t : List Nat, admissible 48 t = true ∧ diameter t ≤ 130 := by
  exact certValidRoot_sound (k := 48) (d := 130) (c := cert_48_130) (by decide)
