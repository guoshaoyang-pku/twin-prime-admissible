import Sound
import lean_certs.cert_35_130

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H35_gt_130_kernel : ¬ ∃ t : List Nat, admissible 35 t = true ∧ diameter t ≤ 130 := by
  exact certValidRoot_sound (k := 35) (d := 130) (c := cert_35_130) (by decide)
