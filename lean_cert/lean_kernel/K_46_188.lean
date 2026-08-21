import Sound
import lean_certs.cert_46_188

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H46_gt_188_kernel : ¬ ∃ t : List Nat, admissible 46 t = true ∧ diameter t ≤ 188 := by
  exact certValidRoot_sound (k := 46) (d := 188) (c := cert_46_188) (by decide)
