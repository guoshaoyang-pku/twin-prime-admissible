import Sound
import lean_certs.cert_46_124

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H46_gt_124_kernel : ¬ ∃ t : List Nat, admissible 46 t = true ∧ diameter t ≤ 124 := by
  exact certValidRoot_sound (k := 46) (d := 124) (c := cert_46_124) (by decide)
