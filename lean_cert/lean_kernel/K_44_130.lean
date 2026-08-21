import Sound
import lean_certs.cert_44_130

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H44_gt_130_kernel : ¬ ∃ t : List Nat, admissible 44 t = true ∧ diameter t ≤ 130 := by
  exact certValidRoot_sound (k := 44) (d := 130) (c := cert_44_130) (by decide)
